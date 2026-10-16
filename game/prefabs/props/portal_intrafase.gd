@tool
class_name PortalIntrafase
extends Area2D
## Intra-level Portal (tile `2`) - teleports the player to its **pair** in the SAME level.
##
## Pair authority lives in `sim/world/portals.gd` (see SYSTEM-004): the scene
## only detects the entry and emits `teleport_requested`. No game rules here.
## Reference: DESIGN-023 (Platforms & Portals).

signal teleport_requested(pair_id: int)

## Same `pair_id` = pair (two portals with the same id connect).
@export var pair_id: int = 0
## Small offset applied on arrival (avoids re-trigger at the destination portal).
@export var spawn_offset: Vector2 = Vector2(0, -8)
## Portal color - yellow (DESIGN-023).
@export var portal_color: Color = Color(0.98, 0.84, 0.25)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport_requested.emit(pair_id)


func _draw() -> void:
	# Code-drawn (CONTEXT-009: vector + glow, no texture).
	var half := Vector2(16, 16)
	var rect := Rect2(-half, half * 2.0)
	draw_rect(rect, portal_color * Color(1, 1, 1, 0.25), true)
	draw_rect(rect, portal_color, false, 2.0)
	draw_rect(rect.grow(-4.0), portal_color.lightened(0.4), false, 1.0)
