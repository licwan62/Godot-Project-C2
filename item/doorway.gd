extends Area2D
@onready var world: World = get_tree().get_first_node_in_group(&"world")


func _on_body_entered(body) -> void:
	if body is Player:
		world.emit_signal("world_clear")
