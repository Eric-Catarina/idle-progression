extends Control
## Footer - bottom main UI (CONTEXT-010 §3b). F = 89 px.
## Info on the left, menu buttons on the right. Code-drawn (CONTEXT-009).

const F := 89.0
const BG := Color(0.12, 0.13, 0.15, 0.97)
const LINE := Color(1.0, 0.82, 0.40)
const BAR_BG := Color(0.08, 0.09, 0.11)
const COL_HP := Color(0.85, 0.29, 0.29)
const COL_XP := Color(0.29, 0.56, 0.85)
const COL_QUOTA := Color(0.88, 0.63, 0.29)
const TXT := Color(0.85, 0.89, 0.95)

const MENU := ["AUTO", "SKILLS", "EQUIP", "CARDS", "PET", "OSIRIS", "MAP", "ITEMS", "MENU"]


func _ready() -> void:
	custom_minimum_size.y = F
	_build_buttons()
	queue_redraw()


func _build_buttons() -> void:
	var btn_w := 68.0
	var gap := 8.0
	var x := 468.0
	for label in MENU:
		var b := Button.new()
		b.text = label
		b.focus_mode = Control.FOCUS_NONE
		b.size = Vector2(btn_w, 50)
		b.position = Vector2(x, (F - 50.0) * 0.5 + 4.0)
		b.pressed.connect(_on_menu.bind(label))
		add_child(b)
		x += btn_w + gap
		if x + btn_w > size.x and size.x > 0.0:
			break


func _on_menu(label: String) -> void:
	print("UI: menu '%s' (not implemented yet)" % label)


func _draw() -> void:
	var w := size.x
	draw_rect(Rect2(0, 0, w, F), BG, true)
	draw_line(Vector2(0, 1), Vector2(w, 1), LINE, 2.0)

	var font := get_theme_default_font()

	# Level (left)
	draw_string(font, Vector2(16, 26), "Lv %d" % GameState.player_level,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 15, TXT)
	draw_string(font, Vector2(16, 44), "%s" % GameState.level_name,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 11, TXT.darkened(0.3))

	# Bars
	var bg := 148.0
	_bar(Rect2(bg, 14, 300, 13), GameState.player_hp, GameState.player_hp_max, COL_HP,
		"HP %d / %d" % [GameState.player_hp, GameState.player_hp_max])
	_bar(Rect2(bg, 33, 300, 13), GameState.player_xp, GameState.player_xp_need, COL_XP,
		"XP %d / %d" % [GameState.player_xp, GameState.player_xp_need])
	_bar(Rect2(bg, 52, 300, 10), GameState.kill_count, GameState.kill_quota, COL_QUOTA,
		"QUOTA %d / %d" % [GameState.kill_count, GameState.kill_quota])


func _bar(r: Rect2, value: int, max_value: int, color: Color, label: String) -> void:
	var font := get_theme_default_font()
	draw_rect(r, BAR_BG, true)
	var ratio := 0.0 if max_value <= 0 else clampf(float(value) / float(max_value), 0.0, 1.0)
	if ratio > 0.0:
		draw_rect(Rect2(r.position, Vector2(r.size.x * ratio, r.size.y)), color, true)
	draw_rect(r, color.darkened(0.4), false, 1.0)
	draw_string(font, r.position + Vector2(4, r.size.y - 2), label,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 11, TXT)
