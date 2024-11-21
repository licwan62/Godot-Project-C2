extends "res://agent/player/state/limbo_state.gd"
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var animations: Array[StringName]
var anim_to_play: StringName

func _enter() -> void:
	super._enter()
	# set idle animation if holding weapon
	var idx = weapon_component.current_weapon
	anim_to_play = animations[idx]
	anim_sprite.play(anim_to_play)
	
func _update(delta: float) -> void:
	if Util.is_move_key_pressed:
		get_root().dispatch(&"move!")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		get_root().dispatch(&"jump!")
		
	if not player.is_on_floor():
		get_root().dispatch(&"fall!")
	
	if Input.is_action_just_pressed("dash"):
		get_root().dispatch(&"dash!")
		
	if Input.is_action_just_pressed("attack"):
		get_root().dispatch(&"attack!")
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			get_root().dispatch(&"dash!")
