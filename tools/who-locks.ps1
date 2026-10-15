# Descobre quais processos estao segurando um arquivo/pasta (Restart Manager API).
# Uso: powershell -ExecutionPolicy Bypass -File tools/who-locks.ps1 "E:\caminho\pasta"
param([Parameter(Mandatory = $true)][string]$Path)

Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public static class RestartManagerHelper
{
    [StructLayout(LayoutKind.Sequential)]
    public struct RM_UNIQUE_PROCESS { public int dwProcessId; public System.Runtime.InteropServices.ComTypes.FILETIME ProcessStartTime; }

    const int CCH_RM_MAX_APP_NAME = 255;
    const int CCH_RM_MAX_SVC_NAME = 63;
    const int ERROR_MORE_DATA = 234;

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct RM_PROCESS_INFO
    {
        public RM_UNIQUE_PROCESS Process;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCH_RM_MAX_APP_NAME + 1)] public string strAppName;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCH_RM_MAX_SVC_NAME + 1)] public string strServiceShortName;
        public int ApplicationType;
        public uint AppStatus;
        public uint TSSessionId;
        [MarshalAs(UnmanagedType.Bool)] public bool bRestartable;
    }

    [DllImport("rstrtmgr.dll", CharSet = CharSet.Unicode)]
    static extern int RmStartSession(out uint pSessionHandle, int dwSessionFlags, string strSessionKey);
    [DllImport("rstrtmgr.dll")]
    static extern int RmEndSession(uint pSessionHandle);
    [DllImport("rstrtmgr.dll", CharSet = CharSet.Unicode)]
    static extern int RmRegisterResources(uint pSessionHandle, uint nFiles, string[] rgsFilenames,
        uint nApplications, RM_UNIQUE_PROCESS[] rgApplications, uint nServices, string[] rgsServiceNames);
    [DllImport("rstrtmgr.dll")]
    static extern int RmGetList(uint dwSessionHandle, out uint pnProcInfoNeeded, ref uint pnProcInfo,
        [In, Out] RM_PROCESS_INFO[] rgAffectedApps, ref uint lpdwRebootReasons);

    public static List<int> Who(string path)
    {
        var result = new List<int>();
        uint session;
        string key = Guid.NewGuid().ToString();
        if (RmStartSession(out session, 0, key) != 0) return result;
        try
        {
            var resources = new string[] { path };
            if (RmRegisterResources(session, (uint)resources.Length, resources, 0, null, 0, null) != 0) return result;
            uint needed = 0, count = 0, reasons = 0;
            int res = RmGetList(session, out needed, ref count, null, ref reasons);
            if (res == ERROR_MORE_DATA)
            {
                var arr = new RM_PROCESS_INFO[needed];
                count = needed;
                if (RmGetList(session, out needed, ref count, arr, ref reasons) == 0)
                    for (int i = 0; i < count; i++) result.Add(arr[i].Process.dwProcessId);
            }
            return result;
        }
        finally { RmEndSession(session); }
    }
}
'@

if (-not (Test-Path -LiteralPath $Path)) { Write-Output "nao existe: $Path"; exit 0 }

$files = @()
if ((Get-Item -LiteralPath $Path -Force).PSIsContainer) {
    $files = @(Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
        Select-Object -First 500 -ExpandProperty FullName)
    if ($files.Count -eq 0) { $files = @($Path) }
} else { $files = @((Get-Item -LiteralPath $Path).FullName) }

Write-Output "checando $($files.Count) arquivo(s) em: $Path"
$ids = @{}
foreach ($f in $files) { foreach ($procId in [RestartManagerHelper]::Who($f)) { $ids[$procId] = $true } }

if ($ids.Count -eq 0) { Write-Output "== nenhum processo segurando (via Restart Manager) =="; exit 0 }

Write-Output "== processos que seguram =="
foreach ($procId in $ids.Keys) {
    $p = Get-Process -Id $procId -ErrorAction SilentlyContinue
    if ($p) { Write-Output ("  PID {0}  {1}  {2}" -f $procId, $p.ProcessName, $p.Path) }
    else { Write-Output ("  PID {0}  (saiu)" -f $procId) }
}
