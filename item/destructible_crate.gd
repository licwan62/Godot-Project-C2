class_name DestructibleCrate
extends StaticBody2D

@export var health := 1
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.disabled = false

func _on_destroy():
	if anim_sprite:
		collision.disabled = true
		anim_sprite.play(&"destroy")
		await anim_sprite.animation_finished
	queue_free()
	
func take_damage(attack: Global.Attack):
	health -= attack.damage
	if health <= 0:
		_on_destroy.call_deferred()
