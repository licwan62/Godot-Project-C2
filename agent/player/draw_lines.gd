extends Node2D
@onready var attack_state: AttackState = %Attack
@onready var player: Player = get_parent()
var height_to_slash_down: float

func _ready() -> void:
	height_to_slash_down = attack_state.get_distance_to_slash_down()

func _draw() -> void:
	var target_pos = Vector2(position.x, position.y + height_to_slash_down)
	draw_line(position, target_pos, Color.RED, 1)
