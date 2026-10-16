extends Node2D
## Main — compoe MUNDO + FOOTER (SYSTEM-004 §4b, CONTEXT-010 §3b).
## O mundo vive num SubViewport de altura `H - F`; a camera nunca enquadra o footer.

const FOOTER_H := 89.0
const PAD := 8.0
const MARGIN := 24.0      # respiro (px de tela) quando o nivel e enquadrado
const MAX_FIT := 3.0      # teto do zoom de enquadramento
const PLAYER := preload("res://prefabs/actors/player.tscn")

@export var start_level: String = "Level1_1"

@onready var world_area: SubViewportContainer = $WorldArea
@onready var sub_viewport: SubViewport = $WorldArea/SubViewport
@onready var world: Node2D = $WorldArea/SubViewport/World
@onready var level_view: Node2D = $WorldArea/SubViewport/World/LevelView
@onready var camera: Camera2D = $WorldArea/SubViewport/World/Camera

var _level: LevelData
var _player: Node2D


func _ready() -> void:
	# Controls ancorados a um Node2D nao herdam a area do viewport: dimensionar aqui.
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
		push_error("Main: nivel '%s' nao encontrado (rode tools/export-data.mjs)" % level_name)
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


func _frame_camera() -> void:
	var vs := sub_viewport.size
	var ls := _level.pixel_size()
	# ENQUADRAMENTO: se o nivel for menor que a area do mundo, da ZOOM pra ele preencher
	# (nunca afasta: fit < 1 e ignorado). Ver DESIGN-041 / CONTEXT-010 §3b.
	var fit := minf((vs.x - MARGIN * 2.0) / ls.x, (vs.y - MARGIN * 2.0) / ls.y)
	fit = clampf(fit, 1.0, MAX_FIT)
	camera.zoom = Vector2(fit, fit)
	var vis := vs / fit                       # area visivel em unidades do mundo
	if fit > 1.0:
		# o nivel CABE na tela: sem limites, apenas centrado (o MARGIN vira a folga)
		camera.limit_left = -100000
		camera.limit_right = 100000
		camera.limit_top = -100000
		camera.limit_bottom = 100000
		camera.position = Vector2(ls.x * 0.5, ls.y * 0.5)
		camera.make_current()
		return
	# sem zoom: limita se o nivel for maior que a area; senao ancora o piso acima do footer
	if ls.x + PAD * 2.0 >= vis.x:
		camera.limit_left = 0
		camera.limit_right = int(ls.x)
	else:
		camera.limit_left = -100000
		camera.limit_right = 100000
	if ls.y + PAD * 2.0 >= vis.y:
		camera.limit_top = 0
		camera.limit_bottom = int(ls.y + PAD)
	else:
		camera.limit_top = -100000
		camera.limit_bottom = 100000
	camera.position = Vector2(ls.x * 0.5, ls.y + PAD - vis.y * 0.5)
	camera.make_current()


func _process(_delta: float) -> void:
	# segue o player na vertical apenas quando o nivel e mais alto que a area
	if _player == null or _level == null:
		return
	var vs := sub_viewport.size
	var ls := _level.pixel_size()
	if ls.y <= vs.y:
		return
	var target := clampf(_player.global_position.y, vs.y * 0.5, ls.y + PAD - vs.y * 0.5)
	camera.position.y = lerpf(camera.position.y, target, 0.12)
