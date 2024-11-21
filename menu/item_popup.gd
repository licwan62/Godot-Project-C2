extends Control

@onready var panel: PopupPanel = %PopupPanel

func popup_show(slot: Rect2i, item: Weapon):
	if item == null:
		return
	var slot_pos = slot.position
	#var slot_size = slot.size
	var mouse_pos = get_viewport().get_mouse_position()
	var pos_correction: Vector2i
	var padding = 10.0
	
	if mouse_pos.x + panel.size.x < get_viewport_rect().size.x:
		pos_correction = Vector2i(0, -panel.size.y - padding)
	else:
		pos_correction = Vector2i(-panel.size.x, -panel.size.y - padding)
		
	panel.size.x = 0
	set_popup_content(item)
		
	panel.popup(
		Rect2i(slot_pos + pos_correction, panel.size))
		
func set_popup_content(item: Weapon):
	%Name.text = item.name
	%StrenghValue.text = str(item.strengh) 
	%AttributeType.text = item.attribute_type
	%AttributeValue.text = str(item.attribute_value) 
	
func popup_hide():
	panel.hide()
