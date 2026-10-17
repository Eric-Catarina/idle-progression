class_name BasicAttack
extends RefCounted
## Headless basic-attack state and transition. Inputs are value snapshots, never nodes.

const READY_EPSILON := 0.000001

var interval: float = 0.0
var _cooldown_remaining: float = 0.0

## Adapter-friendly wrapper: stores only sim state; all targeting stays in tick().
func advance(delta: float, player_position: Vector2, mob_positions: PackedVector2Array) -> int:
	var result := tick(_cooldown_remaining, delta, player_position, mob_positions, interval)
	_cooldown_remaining = float(result["cooldown_remaining"])
	return int(result["target_index"])


## Pure transition: returns the next cooldown and nearest target index (or -1).
## Does not mutate its inputs, inspect the scene tree, or retain external references.
static func tick(
	cooldown_remaining: float,
	delta: float,
	player_position: Vector2,
	mob_positions: PackedVector2Array,
	attack_cooldown: float
) -> Dictionary:
	var remaining := maxf(cooldown_remaining - maxf(delta, 0.0), 0.0)
	if remaining > READY_EPSILON:
		return _result(remaining, -1)

	var cooldown := maxf(attack_cooldown, 0.0)
	if cooldown <= 0.0:
		return _result(0.0, -1)

	var nearest_distance_squared := INF
	var nearest_index := -1
	for i in mob_positions.size():
		var mob_position: Vector2 = mob_positions[i]
		var distance_squared := player_position.distance_squared_to(mob_position)
		if distance_squared < nearest_distance_squared:
			nearest_distance_squared = distance_squared
			nearest_index = i

	if nearest_index < 0:
		# No target means no cooldown is consumed (DESIGN-036 / DATA-018).
		return _result(0.0, -1)
	return _result(cooldown, nearest_index)


static func _result(cooldown_remaining: float, target_index: int) -> Dictionary:
	return {
		"cooldown_remaining": cooldown_remaining,
		"target_index": target_index,
	}
