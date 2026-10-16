@tool
class_name PortalFase
extends Area2D
## Level Portal - switches **level** (tiles `4` Entry / `5` Exit).
##
## Forwards the decision to the level scene / `GameState` by signal (see SYSTEM-004):
## on enter, the player is placed at `target_portal` of `target_level`.
## Reference: DESIGN-023 (Platforms & Portals).

signal portal_requested(kind: Kind, target_level: String, target_portal: String)

enum Kind { ENTRADA, SAIDA }

@export var kind: Kind = Kind.ENTRADA:
	set(value):
		kind = value
		queue_redraw()
## Target level (e.g. "Level1_2"). Empty = stay in the current level.
@export var target_level: String = ""
## Where the player spawns at the destination (logical name of the entry portal).
@export var target_portal: String = "entrada"


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		portal_requested.emit(kind, target_level, target_portal)


func _draw() -> void:
	# Code-drawn (CONTEXT-009). Blue = Entry, red = Exit.
	var base := Color(0.30, 0.55, 0.98) if kind == Kind.ENTRADA else Color(0.95, 0.30, 0.35)
	var half := Vector2(18, 26)
	var rect := Rect2(-half, half * 2.0)
	draw_rect(rect, base * Color(1, 1, 1, 0.22), true)
	draw_rect(rect, base, false, 2.0)
	# Top arc (portal)
	draw_arc(Vector2(0, -half.y), half.x, PI, TAU, 24, base.lightened(0.3), 2.0)
