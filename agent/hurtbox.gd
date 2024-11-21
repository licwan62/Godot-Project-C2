class_name HurtBox
extends Area2D

func _init() -> void:
	collision_layer = 32
	collision_mask = 16
	
func _ready() -> void:
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(area: Area2D):
	# detected other agents'hitbox 
	if area is not Hitbox or area.owner == owner:
		return
	
	var overlaped_hitbox = area
	if owner is Agent:
		var attack = overlaped_hitbox.get_attack()
		owner.take_damage(attack)
		
	if owner is DestructibleCrate:
		var attack = overlaped_hitbox.get_attack()
		owner.take_damage(attack)
		
	if owner is DestructibleChest:
		var attack = overlaped_hitbox.get_attack()
		owner.take_damage(attack)
