#extends Resource
#class_name Attack
#@export var type: StringName
#@export var damage: int
#@export var knockback: Vector2
#
#func init(_type: StringName, _damage: int, _knockback: Vector2) -> Attack:
	#type = _type
	#damage = _damage
	#knockback = _knockback
	#return self
