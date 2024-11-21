extends "res://agent/player/state/limbo_state.gd"
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var animations: Array[StringName]
var speed_rate: float
	
func _enter() -> void:
	super._enter()
	
	match player.move_action:
		0: _apply_walk_anim()
		1: _apply_run_anim()
		
func _update(delta: float) -> void:
	if Util.is_move_key_pressed:
		player.face_dir(Util.is_move_key_pressed)
		var velocity = sign(player.get_facing()) * player.get_current_speed()
		player.move(velocity)
		
	if not Util.is_move_key_pressed:
		get_root().dispatch(EVENT_FINISHED)
			
	if Input.is_action_just_pressed("jump"):
		get_root().dispatch(&"jump!")
		
	if not player.is_on_floor():
		get_root().dispatch(&"fall!")
		
	if Input.is_action_just_pressed("dash"):
		get_root().dispatch(&"dash!")
		
	if Input.is_action_just_pressed("attack"):
		get_root().dispatch(&"attack!")
		
func _apply_run_anim():
	var idx = weapon_component.current_weapon
	var anim = animations[idx]
	anim_sprite.play(anim)
	
func _apply_walk_anim():
	anim_sprite.play(animations[3])
