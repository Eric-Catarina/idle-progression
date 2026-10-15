extends Node2D
## LevelView — monta a cena do nivel a partir do DADO (SYSTEM-004).
## Desenho por codigo (CONTEXT-009), sem TileSet. Colisao por retangulos fundidos.

const PORTAL_FASE := preload("res://prefabs/props/portal_fase.tscn")
const PORTAL_INTRA := preload("res://prefabs/props/portal_intrafase.tscn")

const LAYER_SOLID := 1
const LAYER_ONEWAY := 2

const COL_FLOOR := Color(0.17, 0.26, 0.18)
const COL_PLATFORM := Color(0.28, 0.40, 0.29)
const COL_WALL := Color(0.22, 0.22, 0.26)

var level: LevelData


func build(l: LevelData) -> void:
	level = l
	for c in get_children():
		c.queue_free()
	var geo := LevelGeometry.build(level)
	_add_body(geo["solids"], "Solids", false)
	_add_body(geo["platforms"], "Platforms", true)
	_spawn_portals()
	queue_redraw()


func _add_body(rects: Array, node_name: String, one_way: bool) -> void:
	if rects.is_empty():
		return
	var body := StaticBody2D.new()
	body.name = node_name
	body.collision_layer = LAYER_ONEWAY if one_way else LAYER_SOLID
	body.collision_mask = 0
	add_child(body)
	for r in rects:
		var cs := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(r.size.x * level.cell_size, r.size.y * level.cell_size)
		cs.shape = shape
		cs.position = Vector2(
			(r.position.x + r.size.x * 0.5) * level.cell_size,
			(r.position.y + r.size.y * 0.5) * level.cell_size)
		cs.one_way_collision = one_way
		body.add_child(cs)


func _spawn_portals() -> void:
	var holder := Node2D.new()
	holder.name = "Portals"
	add_child(holder)
	# Intrafase (tile 2): pareado em ORDEM DE LEITURA (DESIGN-023 §3)
	var intra := level.cells_of(LevelData.TILE_PORTAL_INTRA)
	for i in intra.size():
		var p := PORTAL_INTRA.instantiate()
		p.pair_id = i / 2
		p.position = level.cell_center(intra[i].x, intra[i].y)
		holder.add_child(p)
	for c in level.cells_of(LevelData.TILE_PORTAL_IN):
		_add_portal(holder, c, 0)
	for c in level.cells_of(LevelData.TILE_PORTAL_OUT):
		_add_portal(holder, c, 1)


func _add_portal(holder: Node2D, cell: Vector2i, kind: int) -> void:
	var p := PORTAL_FASE.instantiate()
	p.kind = kind
	p.position = level.cell_center(cell.x, cell.y)
	holder.add_child(p)


func _draw() -> void:
	if level == null:
		return
	var s := float(level.cell_size)
	for y in level.rows:
		for x in level.cols:
			var t := level.cell(x, y)
			var col: Color
			if t == LevelData.TILE_WALL:
				col = COL_WALL
			elif t == LevelData.TILE_PLATFORM:
				col = COL_FLOOR if level.is_floor_row(y) else COL_PLATFORM
			else:
				continue
			var r := Rect2(x * s, y * s, s, s)
			draw_rect(r, col, true)
			draw_rect(r, col.lightened(0.35), false, 1.0)
