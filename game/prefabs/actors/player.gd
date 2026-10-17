extends CharacterBody2D
const BasicAttackScript := preload("res://sim/combat/basic_attack.gd")
## Player - thin ADAPTER. KEYBOARD movement (placeholder).
## Tap-to-move (navgraph) arrives with DESIGN-025 / SYSTEM-002.
## Attack cadence + target pick live in sim/combat/basic_attack.gd.

const SPEED := 150.0
const ACCEL := 1400.0
const FRICTION := 1800.0
const GRAVITY := 980.0
const JUMP_VELOCITY := -280.0
const COYOTE := 0.10
const DROP_TIME := 0.20

const COL_BODY := Color(0.29, 0.56, 0.85)
const COL_HEAD := Color(0.94, 0.77, 0.54)

var _coyote := 0.0
var _drop := 0.0
var _attack := BasicAttackScript.new()
var _swing_end := Vector2.ZERO
var _swing := 0.0


func _ready() -> void:
	add_to_group("player")
	_attack.interval = _basic_interval()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		_coyote = maxf(0.0, _coyote - delta)
	else:
		_coyote = COYOTE

	# down-jump: DOWN + JUMP drops through the one-way platform (DESIGN-023 §2)
	if _drop > 0.0:
		_drop -= delta
		if _drop <= 0.0:
			set_collision_mask_value(2, true)

	if Input.is_action_just_pressed("ui_accept"):
		if Input.is_action_pressed("ui_down") and is_on_floor():
			_drop = DROP_TIME
			set_collision_mask_value(2, false)
		elif is_on_floor() or _coyote > 0.0:
			velocity.y = JUMP_VELOCITY
			_coyote = 0.0

	var dir := Input.get_axis("ui_left", "ui_right")
	if absf(dir) > 0.01:
		velocity.x = move_toward(velocity.x, dir * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	move_and_slide()
	_sync_attack(delta)
	queue_redraw()


func _basic_interval() -> float:
	var table: Variant = DataDB.table("data-018")
	if table is Dictionary:
		return float(table.get("basicCooldown", 0.7))
	return 0.7


## Snapshot positions only. Nearest + 0.7s live in BasicAttack.
func _mob_positions() -> PackedVector2Array:
	var out := PackedVector2Array()
	for n in get_tree().get_nodes_in_group("mobs"):
		if n is Node2D:
			out.append((n as Node2D).global_position)
	return out


func _sync_attack(delta: float) -> void:
	var mobs := _mob_positions()
	var hit := _attack.advance(delta, global_position, mobs)
	if hit >= 0:
		_swing_end = mobs[hit]
		_swing = 0.12
	elif _swing > 0.0:
		_swing = maxf(0.0, _swing - delta)


func _draw() -> void:
	draw_rect(Rect2(-6, -8, 12, 18), COL_BODY, true)
	draw_circle(Vector2(0, -12), 6.0, COL_HEAD)
	if _swing > 0.0:
		draw_line(Vector2.ZERO, to_local(_swing_end), Color(1.0, 0.85, 0.3), 2.0)
