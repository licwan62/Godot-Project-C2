extends StaticBody2D
class_name MechanicalDoor

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	collision.disabled = false
	
	
func _on_collision_disabled():
	collision.disabled = true
	
	
func open_door():
	anim_sprite.play(&"open")
	await anim_sprite.animation_finished
	
	_on_collision_disabled.call_deferred()
	
