extends Node2D

var good_distance: float

func _ready() -> void:
	if owner.has_method("get_distance_ready_to_attack"):
		good_distance = owner.get_distance_ready_to_attack()
		
func _draw() -> void:
	if good_distance:
		draw_circle(position, good_distance, Color.YELLOW, false, .5)
