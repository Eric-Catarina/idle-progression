extends CharacterBody2D
## Player - thin ADAPTER. KEYBOARD movement (placeholder).
## Tap-to-move (navgraph) arrives with DESIGN-025 / SYSTEM-002.

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


func _ready() -> void:
	add_to_group("player")


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
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(-6, -8, 12, 18), COL_BODY, true)
	draw_circle(Vector2(0, -12), 6.0, COL_HEAD)
