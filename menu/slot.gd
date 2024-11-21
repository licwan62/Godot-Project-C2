extends TextureButton

@export var item: Weapon = null:
	set(value):
		item = value
		if value != null:
			%TextureRect.texture = value.texture

func _on_mouse_entered() -> void:
	ItemPopup.popup_show(
		Rect2i(global_position, size),
		item
	)
		
	%Panel.visible = true


func _on_mouse_exited() -> void:
	ItemPopup.popup_hide()
	%Panel.visible = false
