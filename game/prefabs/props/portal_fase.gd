@tool
class_name PortalFase
extends Area2D
## Portal de Fase — troca de **nível** (tiles `4` Entrada / `5` Saída).
##
## Encaminha a decisão para a cena de nível / `GameState` via sinal (ver SYSTEM-004):
## ao entrar, o player é reposicionado no `target_portal` do `target_level`.
## Referencia: DESIGN-023 (Plataformas & Portais).

signal portal_requested(kind: Kind, target_level: String, target_portal: String)

enum Kind { ENTRADA, SAIDA }

@export var kind: Kind = Kind.ENTRADA:
	set(value):
		kind = value
		queue_redraw()
## Nível destino (ex.: "Level1_2"). Vazio = permanece no nível corrente.
@export var target_level: String = ""
## Onde o player nasce no destino (nome lógico do portal de entrada).
@export var target_portal: String = "entrada"


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		portal_requested.emit(kind, target_level, target_portal)


func _draw() -> void:
	# Desenho por codigo (CONTEXT-009). Azul = Entrada, vermelho = Saida.
	var base := Color(0.30, 0.55, 0.98) if kind == Kind.ENTRADA else Color(0.95, 0.30, 0.35)
	var half := Vector2(18, 26)
	var rect := Rect2(-half, half * 2.0)
	draw_rect(rect, base * Color(1, 1, 1, 0.22), true)
	draw_rect(rect, base, false, 2.0)
	# Arco superior (portal)
	draw_arc(Vector2(0, -half.y), half.x, PI, TAU, 24, base.lightened(0.3), 2.0)
