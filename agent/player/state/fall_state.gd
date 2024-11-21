extends "res://agent/player/state/limbo_state.gd"
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var animations: Array[StringName]
@export var fall_velocity_threhold = 400.0
var anim_to_play: StringName

func _enter() -> void:
	super._enter()
	
	var idx = weapon_component.current_weapon
	anim_to_play = animations[idx]
	# fall over platform - idle, move -> fall
	if anim_sprite.animation != anim_to_play:
		anim_sprite.play(anim_to_play)
		# begin with frame that starts falling
		anim_sprite.frame = 2
		
func _update(delta: float) -> void:
	_update_animation()
	
	if Util.is_move_key_pressed:
		player.face_dir(Util.is_move_key_pressed)
		var velocity = sign(player.get_facing()) * player.get_current_speed()
		player.move(velocity)
		
	# hit the ground and change state to idle
	if player.is_on_floor():
		get_root().dispatch(EVENT_FINISHED)
		
	if Input.is_action_just_pressed("dash"):
		get_root().dispatch(&"dash!")
		
	if Input.is_action_just_pressed("attack"):
		get_root().dispatch(&"attack!")

## falling animation after jump		
func _update_animation():
	if player.velocity.y > fall_velocity_threhold:
		anim_sprite.frame = 2
	else:
		anim_sprite.frame = 1
