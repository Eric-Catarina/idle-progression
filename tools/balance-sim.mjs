#!/usr/bin/env node
/* Simulador + SOLVER de balanceamento do jogo.
 * Resolve mobHp e mobXp por nível de conteúdo para bater os TEMPOS e os NÍVEIS alvo.
 * As metas (tempos, níveis, cotas) vivem em DATA-013/DATA-014; a saída alimenta DATA-014.
 * Uso: node tools/balance-sim.mjs
 */

// --- fórmulas espelhadas do proto/core.js ---
const statOf = (lvl) => 10 + (lvl - 1);
const dmgAt = (lvl, flatBonus = 0) => {
  const st = statOf(lvl);
  const statBlock = st * 4 + st + st;              // Main×4 + Sec + Tert
  const flat = 8 + 3 * (lvl - 1) + flatBonus;      // damageFlat
  const crit = 1 + (5 / 100) * (50 / 100);
  return statBlock * (flat / 100) * crit;
};
const xpNeed = (lvl) => Math.floor(20 * Math.pow(lvl, 2.2));
const ATK_RATE = 1 / 0.7;
const AOE = 1.8;

// alvos de design
const TARGET_MIN = [2, 5, 7, 9, 12];       // minutos p/ bater a cota
const STARTS = [1, 10, 22, 36, 52];        // nível do jogador ao ENTRAR
const ENDS = [10, 22, 36, 52, 70];         // nível do jogador ao SAIR
const QUOTA = [60, 110, 150, 180, 220];    // kills p/ abrir o portal de saída
const MOB_ATK = [2, 5, 12, 28, 60];

const xpSpan = (a, b) => { let s = 0; for (let l = a; l < b; l++) s += xpNeed(l); return s; };

function sim(mobHp, mobXp, quota, startLvl, tLimit) {
  let lvl = startLvl, xp = 0, kills = 0, t = 0; const DT = 0.05;
  const lim = tLimit || 1e6;
  while (kills < quota && t < lim) {
    const kps = (dmgAt(lvl) * ATK_RATE * AOE) / mobHp;
    const k = kps * DT;
    kills += k; t += DT; xp += k * mobXp;
    while (xp >= xpNeed(lvl) && lvl < 200) { xp -= xpNeed(lvl); lvl++; }
  }
  return { t, lvl };
}

const rows = [];
for (let i = 0; i < 5; i++) {
  const mobXp = Math.max(1, Math.round(xpSpan(STARTS[i], ENDS[i]) / QUOTA[i]));
  const tLimit = TARGET_MIN[i] * 60 * 6;
  let lo = 1, hi = dmgAt(STARTS[i]) * 40000;
  for (let it = 0; it < 70; it++) {
    const mid = Math.sqrt(lo * hi);          // busca log
    const r = sim(mid, mobXp, QUOTA[i], STARTS[i], tLimit);
    if (r.t > TARGET_MIN[i] * 60) hi = mid; else lo = mid;
  }
  const mobHp = Math.round(Math.sqrt(lo * hi));
  const r = sim(mobHp, mobXp, QUOTA[i], STARTS[i], tLimit);
  rows.push({
    nivel: "1-" + (i + 1), cota: QUOTA[i], "alvo(min)": TARGET_MIN[i], "tempo(min)": (r.t / 60).toFixed(2),
    "lvl inicio": STARTS[i], "lvl fim": r.lvl, mobHp, mobXp, mobAtk: MOB_ATK[i],
    "hits/mob(inicio)": (mobHp / dmgAt(STARTS[i])).toFixed(1),
    "hits/mob(fim)": (mobHp / dmgAt(r.lvl)).toFixed(1),
    essence: Math.round(Math.pow(4, i)),
  });
}
console.table(rows);
console.log("\n// valores para DATA-014 (Populacao Mundo 1):");
console.log(JSON.stringify(rows.map((r) => ({ level: r.nivel, hp: r.mobHp, atk: r.mobAtk, xp: r.mobXp, essence: r.essence, quota: r.cota })), null, 2));
