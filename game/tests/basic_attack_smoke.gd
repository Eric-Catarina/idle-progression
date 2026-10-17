extends SceneTree
## Headless checks for the pure basic-attack transition.
## Run: godot --headless --path game --script res://tests/basic_attack_smoke.gd

const BasicAttack := preload("res://sim/combat/basic_attack.gd")


func _initialize() -> void:
	var mobs := PackedVector2Array([Vector2(15.0, 0.0), Vector2(2.0, 0.0), Vector2(100.0, 0.0)])
	var first := BasicAttack.tick(0.0, 1.0 / 60.0, Vector2.ZERO, mobs, 0.7)
	assert(first["target_index"] == 1)
	assert(is_equal_approx(first["cooldown_remaining"], 0.7))

	var before_ready := BasicAttack.tick(first["cooldown_remaining"], 0.699, Vector2.ZERO, mobs, 0.7)
	assert(before_ready["target_index"] == -1)
	assert(is_equal_approx(before_ready["cooldown_remaining"], 0.001))
	var ready := BasicAttack.tick(before_ready["cooldown_remaining"], 0.001, Vector2.ZERO, mobs, 0.7)
	assert(ready["target_index"] == 1)

	var empty := PackedVector2Array()
	var skipped := BasicAttack.tick(0.0, 0.0, Vector2.ZERO, empty, 0.7)
	assert(skipped["target_index"] == -1)
	assert(skipped["cooldown_remaining"] == 0.0, "no target must leave attack ready")

	var adapter := BasicAttack.new()
	adapter.interval = 0.7
	assert(adapter.advance(1.0 / 60.0, Vector2.ZERO, mobs) == 1)
	assert(adapter.advance(0.699, Vector2.ZERO, mobs) == -1)
	assert(adapter.advance(0.001, Vector2.ZERO, mobs) == 1)
	print("=== basic attack smoke test passed ===")
	quit(0)
