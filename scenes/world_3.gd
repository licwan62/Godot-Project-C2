extends World


@onready var mechanical_door: MechanicalDoor = %MechanicalDoor

func _ready() -> void:
	super._ready()
	var bgm: NodePath = "res://music/Night1.ogg"
	SoundManager.play_bgm(bgm)
	
	
func _on_world_clear():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/world_4.tscn")


func _on_ready_clear():
	mechanical_door.open_door()
