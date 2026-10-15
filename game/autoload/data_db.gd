extends Node
## DataDB — carrega TODO o dado imutavel UMA vez no boot (SYSTEM-006).
## O dado vem de `res://data/**` (gerado do vault por tools/export-data.mjs).
## CONTRATO: e somente-leitura. Quem precisa mutar deve `duplicate()`.

const LEVELS_DIR := "res://data/levels"
const TABLES_DIR := "res://data/tables"

var levels: Dictionary = {}
var tables: Dictionary = {}


func _ready() -> void:
	_load_levels()
	_load_tables()
	print("DataDB: %d nivel(is), %d tabela(s)" % [levels.size(), tables.size()])


func level(level_name: String) -> LevelData:
	return levels.get(level_name)


func table(id: String) -> Variant:
	return tables.get(id)


func _load_levels() -> void:
	for file in _list_json(LEVELS_DIR):
		var raw: Variant = _read_json(LEVELS_DIR + "/" + file)
		if raw is Dictionary:
			var lvl := LevelData.from_dict(raw)
			levels[lvl.name] = lvl


func _load_tables() -> void:
	for file in _list_json(TABLES_DIR):
		var raw: Variant = _read_json(TABLES_DIR + "/" + file)
		if raw != null:
			tables[file.get_basename()] = raw


func _list_json(dir_path: String) -> PackedStringArray:
	var out := PackedStringArray()
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_error("DataDB: pasta nao encontrada: %s" % dir_path)
		return out
	for f in dir.get_files():
		if f.ends_with(".json"):
			out.append(f)
	out.sort()
	return out


func _read_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		push_error("DataDB: arquivo ausente: %s" % path)
		return null
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed == null:
		push_error("DataDB: JSON invalido: %s" % path)
	return parsed
