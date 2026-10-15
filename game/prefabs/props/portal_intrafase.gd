@tool
class_name PortalIntrafase
extends Area2D
## Portal Intrafase (tile `2`) — teleporta o player para o **par** na MESMA fase.
##
## A **autoridade do par** vive em `sim/world/portals.gd` (ver SYSTEM-004): a cena
## apenas detecta a entrada e emite `teleport_requested`. Nada de regra de jogo aqui.
## Referencia: DESIGN-023 (Plataformas & Portais).

signal teleport_requested(pair_id: int)

## Mesmo `pair_id` = par (dois portais com o mesmo id se conectam).
@export var pair_id: int = 0
## Offset pequeno aplicado na chegada (evita re-trigger no portal destino).
@export var spawn_offset: Vector2 = Vector2(0, -8)
## Cor do portal — amarelo (DESIGN-023).
@export var portal_color: Color = Color(0.98, 0.84, 0.25)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport_requested.emit(pair_id)


func _draw() -> void:
	# Desenho por codigo (CONTEXT-009: vetor + brilho, sem textura).
	var half := Vector2(16, 16)
	var rect := Rect2(-half, half * 2.0)
	draw_rect(rect, portal_color * Color(1, 1, 1, 0.25), true)
	draw_rect(rect, portal_color, false, 2.0)
	draw_rect(rect.grow(-4.0), portal_color.lightened(0.4), false, 1.0)
