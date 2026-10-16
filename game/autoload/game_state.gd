extends Node
## GameState - AUTHORITATIVE state (headless). See CONTEXT-012 §2.
## Only the fields the Footer needs for now; grows with the game.

var level_name: String = ""
var player_level: int = 1
var player_xp: int = 0
var player_xp_need: int = 380
var player_hp: int = 1000
var player_hp_max: int = 1000
var kill_count: int = 0
var kill_quota: int = 60


func load_level(level_name_: String) -> void:
	level_name = level_name_
	kill_count = 0
