class_name Hitbox
extends Area2D
var attack: Global.Attack

func _init() -> void:
	collision_layer = 16
	collision_mask = 32
	
func init(_attack: Global.Attack):
	attack = _attack
	
func get_attack() -> Global.Attack:
	if owner is Agent:
		var knockback = attack.knockback
		var true_knockback = knockback if owner.direction > 0 else Vector2(-knockback.x, knockback.y)
		attack.knockback = true_knockback
		return attack
		
	return attack
