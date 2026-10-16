class_name LevelGeometry
extends RefCounted
## Turns the grid into collision RECTANGLES (pure). Merges horizontal "runs".
## Floor (last row) and Walls = solid; the rest = ONE-WAY platform (DESIGN-023).

const KIND_NONE := 0
const KIND_PLATFORM := 1
const KIND_SOLID := 2


static func build(level: LevelData) -> Dictionary:
	var platforms: Array[Rect2i] = []
	var solids: Array[Rect2i] = []
	for y in level.rows:
		var kind := KIND_NONE
		var start := -1
		for x in range(level.cols + 1):
			var k := KIND_NONE
			if x < level.cols:
				k = _kind_of(level.cell(x, y), y == level.rows - 1)
			if k != kind:
				if kind != KIND_NONE:
					var r := Rect2i(start, y, x - start, 1)
					if kind == KIND_PLATFORM:
						platforms.append(r)
					else:
						solids.append(r)
				kind = k
				start = x
	return { "platforms": platforms, "solids": solids }


static func _kind_of(tile: int, floor_row: bool) -> int:
	if tile == LevelData.TILE_WALL:
		return KIND_SOLID
	if tile == LevelData.TILE_PLATFORM:
		return KIND_SOLID if floor_row else KIND_PLATFORM
	return KIND_NONE
