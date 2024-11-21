extends CanvasLayer


func _ready() -> void:
	var bgm: NodePath = "res://music/Night1.ogg"
	SoundManager.play_bgm(bgm)

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/world_1.tscn")


func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/help_page.tscn")


func _on_story_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_board.tscn")


func _on_gallery_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gallery.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
