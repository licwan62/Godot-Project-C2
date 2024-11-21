class_name Agent
extends CharacterBody2D
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = %Hitbox
@onready var root: Node2D = %Root
@onready var health: Health = $HealthComponent
@onready var death_effect: GPUParticles2D = $Root/FX/Death
var move_this_frame: bool = false
var gravity: Vector2
var direction: int = 1
var is_dead := false

func _ready() -> void: 
	health.die.connect(_on_die)

func _physics_process(delta: float) -> void:
	move_this_frame = false
	gravity = get_gravity()
	_post_physics_process.call_deferred(delta)
		
func _post_physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta
	
	# stop by process if no movement made
	if not move_this_frame:
		velocity.x = move_toward(velocity.x, 0.0, 5000 * delta)
		
	# face as direction by input
	if direction != root.scale.x:
		root.scale.x = move_toward(root.scale.x, float(direction), 20 * delta)
		
	move_and_slide()
	
func _apply_damaged(amount: float):
	var previous_anim = anim_sprite.animation
	anim_sprite.play(&"hurt")
	
	var hsm = get_node_or_null("LimboHSM") as LimboHSM
	var btplayer = get_node_or_null("BTPlayer") as BTPlayer
	if hsm:
		hsm.set_active(false)
	if btplayer:
		btplayer.set_active(false)
		
	await anim_sprite.animation_finished
	anim_sprite.play(previous_anim)
	
	if hsm and not is_dead:
		hsm.set_active(true)
	if btplayer and not is_dead:
		btplayer.restart()
	
func _apply_knockback(knockback: Vector2, frames: int = 10):
	if knockback.is_zero_approx():
		return
		
	for f in range(frames):
		velocity = knockback
		move_this_frame = true
		await get_tree().physics_frame
		
func _on_die():
	# death anim has been set in sub class
	is_dead = true
	await anim_sprite.animation_finished
	if death_effect:
		death_effect.emitting = true
		await death_effect.emitting == false
	queue_free()
	
func _impulse(_velocity: Vector2):
	velocity = _velocity
	move_this_frame = true

func _decelerate(target_velocity: float, rate: float):
	velocity.x = lerp(velocity.x, target_velocity, rate)
	move_this_frame = true
	
func take_damage(attack: Global.Attack):
	# agent get health decreased on hurt
	var damage = attack.damage
	var knockback = attack.knockback
	_apply_damaged(damage)
	
	# agent get knockback on hurt
	#print_debug("%s get hurt with damage: %d, knockback: %s" % [self.name, damage, knockback]) 
	_apply_knockback(knockback)
	
	# send to health to deal with HP
	health.emit_signal("get_damaged", damage)
	
func get_bounced(force: Vector2):
	_impulse(force)
	
func turn_dir():
	var facing = get_facing()
	face_dir(-1 * facing)
		
# update direction with 1 or -1
func face_dir(dir: int):
	if get_facing() != dir:
		direction = dir
		
func get_facing() -> float:
	#return signf(root.scale.x)
	return direction
		
func move(x_velocity: float):
	var target_velocity = Vector2(x_velocity, velocity.y) 
	velocity = lerp(velocity, target_velocity, .5)
	move_this_frame = true
	
