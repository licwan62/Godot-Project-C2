class_name World
extends Node2D

signal world_clear
signal ready_clear
var ready_clare_emit := false

func _ready() -> void:
	Global.scene_score = 0
	world_clear.connect(_on_world_clear)
	ready_clear.connect(_on_ready_clear)


func _physics_process(delta: float) -> void:
	if not ready_clare_emit:
		var enemies_count = get_tree().get_node_count_in_group(&"enemies")
		if not enemies_count == null and enemies_count == 0:
			ready_clear.emit()
			ready_clare_emit = true
		

func _on_world_clear():
	pass
	

func _on_ready_clear():
	pass
