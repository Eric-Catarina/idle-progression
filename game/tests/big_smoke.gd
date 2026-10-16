extends SceneTree
## Smoke test for the BigNumber addon (CONTEXT-018 §1.9) — `Big` (ChronoDK/GodotBigNumberClass).
## Run: godot --headless --path game --script res://tests/big_smoke.gd
## Uses preload so it does not depend on the editor's global-class cache.
## Kept in tests/ so the headless loop can re-check after an addon update.

const BigClass := preload("res://addons/big_number/Big.gd")


func _initialize() -> void:
	print("=== BigNumber smoke test ===")
	BigClass.tests()                                # the addon's own assertions

	var a: RefCounted = BigClass.new(1.0, 100)      # 1e100
	var b: RefCounted = a.multiply(BigClass.new(1.0, 100))   # 1e200
	print("  1e100 x 1e100 = ", b.toScientific())
	print("  log10        = ", b.absLog10())
	print("  AA notation  = ", b.toAA(false, true, false))
	print("  metric       = ", b.toMetricSymbol(false))
	print("  plain        = ", a.toString())

	var growth: RefCounted = BigClass.new(1.0, 3)   # 1e3 — a typical idle tick gain
	for i in 60:
		growth = growth.multiply(BigClass.new(1.15, 0))  # +15% compounding, 60x
	print("  1e3 x 1.15^60 = ", growth.toScientific())
	print("=== done ===")
	quit(0)
