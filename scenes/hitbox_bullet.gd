class_name Bullet
extends Hitbox
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var velocity: Vector2
var agent_shot_this: Agent

func _physics_process(delta: float) -> void:
	# constantly smashing util explode
	position += velocity * delta
	
func _explode():
	# stop bullet, trigger explode animation then destroy it
	velocity = Vector2.ZERO
	anim_sprite.play(&"explode")
	await anim_sprite.animation_finished
	queue_free()

func _on_timer_timeout() -> void:
	_explode()

func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBox or area.owner == agent_shot_this:
		print_debug("bullet enter area of type: %s, shooter: %s, owner of area: %s" % 
		[type_string(typeof(area)), agent_shot_this, area.owner])
		return
		
	_explode()
		
func init_bullet(_shooter: Agent, _info: Global.BulletInfo, _attack: Global.Attack):
	position = _info.position
	rotation = _info.direction.angle()
	velocity = _info.direction * _info.speed
	attack = _attack
	agent_shot_this = _shooter
