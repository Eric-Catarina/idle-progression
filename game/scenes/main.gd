extends Node2D
## Main - composes WORLD + FOOTER (SYSTEM-004 §4b, CONTEXT-010 §3b).
## The world lives in a SubViewport of height `H - F`; the camera never frames the footer.
## Camera: Phantom Camera (CONTEXT-018 §1.10) with a plain-Camera2D fallback.

const FOOTER_H := 89.0
const PAD := 8.0
const MARGIN := 24.0      # slack (screen px) when the level is framed
const MAX_FIT := 3.0      # zoom ceiling for framing
const PLAYER := preload("res://prefabs/actors/player.tscn")

@export var start_level: String = "Level1_1"

@onready var world_area: SubViewportContainer = $WorldArea
@onready var sub_viewport: SubViewport = $WorldArea/SubViewport
@onready var world: Node2D = $WorldArea/SubViewport/World
@onready var level_view: Node2D = $WorldArea/SubViewport/World/LevelView
@onready var camera: Camera2D = $WorldArea/SubViewport/World/Camera
@onready var pcam: Node = get_node_or_null("WorldArea/SubViewport/World/PCam")

var _level: LevelData
var _player: Node2D


func _ready() -> void:
	# Controls anchored to a Node2D do not inherit the viewport rect: size them here.
	_resize_world_area()
	get_viewport().size_changed.connect(_on_viewport_resized)
	_start()


func _on_viewport_resized() -> void:
	_resize_world_area()
	if _level != null:
		_frame_camera()


func _resize_world_area() -> void:
	var vp := get_viewport_rect().size
	world_area.size = Vector2(vp.x, vp.y - FOOTER_H)


func _start() -> void:
	var level_name := start_level if start_level != "" else "Level1_1"
	_level = DataDB.level(level_name)
	if _level == null:
		push_error("Main: level '%s' not found (run tools/export-data.mjs)" % level_name)
		return
	GameState.load_level(level_name)
	level_view.build(_level)
	_frame_camera()
	_spawn_player()


func _spawn_player() -> void:
	_player = PLAYER.instantiate()
	var sc := _level.spawn_cell()
	_player.position = _level.cell_center(sc.x, sc.y)
	world.add_child(_player)
	if pcam != null:
		pcam.follow_target = _player          # Phantom Camera follows the player


## Frames the level: ZOOM so a small level fills the world area (never zooms out).
## See DESIGN-041 / CONTEXT-010 §3b.
func _frame_camera() -> void:
	var vs := sub_viewport.size
	var ls := _level.pixel_size()
	var fit := clampf(minf((vs.x - MARGIN * 2.0) / ls.x, (vs.y - MARGIN * 2.0) / ls.y), 1.0, MAX_FIT)

	# Limits: only when the level is larger than the visible area.
	var vis := vs / fit                        # visible area in world units
	var lm := {}
	if ls.x + PAD * 2.0 >= vis.x:
		lm["limit_left"] = 0
		lm["limit_right"] = int(ls.x)
	if ls.y + PAD * 2.0 >= vis.y:
		lm["limit_top"] = 0
		lm["limit_bottom"] = int(ls.y + PAD)

	# The camera never shows below the level floor: for a fitting level, centre it.
	var fits := fit > 1.0
	var centre := Vector2(ls.x * 0.5, ls.y + PAD - vis.y * 0.5)

	if pcam != null:
		pcam.zoom = Vector2(fit, fit)
		pcam.limit_left = lm.get("limit_left", -100000)
		pcam.limit_right = lm.get("limit_right", 100000)
		pcam.limit_top = lm.get("limit_top", -100000)
		pcam.limit_bottom = lm.get("limit_bottom", 100000)
		if fits:
			# static, centred: dead-zone follow would still drift on a still player
			pcam.follow_mode = PhantomCamera2D.FollowMode.NONE
			pcam.global_position = centre
		else:
			pcam.follow_mode = PhantomCamera2D.FollowMode.FRAMED
		return

	# --- fallback: plain Camera2D ---
	camera.zoom = Vector2(fit, fit)
	camera.limit_left = lm.get("limit_left", -100000)
	camera.limit_right = lm.get("limit_right", 100000)
	camera.limit_top = lm.get("limit_top", -100000)
	camera.limit_bottom = lm.get("limit_bottom", 100000)
	camera.position = centre
	camera.make_current()


func _process(_delta: float) -> void:
	# Fallback only: Phantom Camera follows on its own when it is present.
	if pcam != null or _player == null or _level == null:
		return
	var vs := sub_viewport.size
	var ls := _level.pixel_size()
	if ls.y <= vs.y:
		return
	var target := clampf(_player.global_position.y, vs.y * 0.5, ls.y + PAD - vs.y * 0.5)
	camera.position.y = lerpf(camera.position.y, target, 0.12)
