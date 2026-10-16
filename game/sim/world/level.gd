class_name LevelData
extends RefCounted
## Data of ONE level (pure/headless) - see DATA-006 and SYSTEM-006.
## The grid is kept in a **flat PackedInt32Array**: `cell(y * cols + x)`.

const TILE_EMPTY := 0
const TILE_PLATFORM := 1
const TILE_PORTAL_INTRA := 2
const TILE_WALL := 3
const TILE_PORTAL_IN := 4
const TILE_PORTAL_OUT := 5
const TILE_SPAWN := 6

var name: String = ""
var cols: int = 0
var rows: int = 0
var cell_size: int = 21
var grid: PackedInt32Array = PackedInt32Array()
var interactables: Array = []


func cell(x: int, y: int) -> int:
	if x < 0 or y < 0 or x >= cols or y >= rows:
		return TILE_EMPTY
	return grid[y * cols + x]


func is_floor_row(y: int) -> bool:
	return y == rows - 1


## Player spawn cell (tile 6); fallback to the lower-left corner.
func spawn_cell() -> Vector2i:
	var c := cells_of(TILE_SPAWN)
	if c.size() > 0:
		return c[0]
	return Vector2i(2, rows - 2)


## All cells of a tile (to instantiate portal prefabs).
func cells_of(tile: int) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for y in rows:
		for x in cols:
			if grid[y * cols + x] == tile:
				out.append(Vector2i(x, y))
	return out


## cell centre in pixels (world).
func cell_center(x: int, y: int) -> Vector2:
	return Vector2((x + 0.5) * cell_size, (y + 0.5) * cell_size)


func pixel_size() -> Vector2:
	return Vector2(cols * cell_size, rows * cell_size)


static func from_dict(d: Dictionary) -> LevelData:
	var l := LevelData.new()
	l.name = String(d.get("name", "?"))
	l.cols = int(d.get("cols", 0))
	l.rows = int(d.get("rows", 0))
	l.cell_size = int(d.get("cellSize", 21))
	l.grid.resize(l.cols * l.rows)
	var g: Array = d.get("grid", [])
	for y in g.size():
		var row: Array = g[y]
		for x in row.size():
			if x < l.cols and y < l.rows:
				l.grid[y * l.cols + x] = int(row[x])
	l.interactables = d.get("interactables", [])
	return l
