class_name DestructibleChest
extends StaticBody2D
@export var score_reward := 10
@export var health := 50
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_collistion: CollisionShape2D = $HurtBox/CollisionShape2D

func _ready() -> void:
	collision.disabled = false
	hurtbox_collistion.disabled = false
	
func _on_chest_hurt():
	anim_sprite.play(&"hurt")

func _on_chest_open():
	anim_sprite.play(&"open")
	await anim_sprite.animation_finished
	
	hurtbox_collistion.disabled = true
	collision.disabled = true
	_add_score()

func _add_score():
	Global.scene_score += score_reward
	
func take_damage(attack: Global.Attack):
	health -= attack.damage
	if health <= 0:
		_on_chest_open.call_deferred()
	else:
		_on_chest_hurt()
