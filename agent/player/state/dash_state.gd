extends "res://agent/player/state/limbo_state.gd"
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var particle: GPUParticles2D = %GhostParticle
@export var animations: Array[StringName]
@export var dash_speed := 2000.0
@export var duration_msec := 500
@export var cooldown_sec := .5
@export var dash_sprite_sheet: Texture2D
@export var front_flip_sprite_sheet: Texture2D
## infer if cooldown over since last full combo
var can_enter: bool = true

func _enter() -> void:
	super._enter()
	
	# apply dash animation in set speed and of type
	if not player.is_on_floor():
		Util.set_anim_speed(anim_sprite, animations[0], float(duration_msec) / 1000)
		anim_sprite.play(animations[0])
	else:
		Util.set_anim_speed(anim_sprite, animations[1], float(duration_msec) / 1000)
		anim_sprite.play(animations[1])
	player.dash(dash_speed, float(duration_msec) / 1000)
		
	_handle_particle_effect()
	particle.emitting = true
	
func _update(delta: float) -> void:
	if get_time_elapsed_msec() > duration_msec:
		get_root().dispatch(EVENT_FINISHED)
	
func _exit() -> void:
	particle.emitting = false
	
	can_enter = false
	await get_tree().create_timer(cooldown_sec).timeout
	can_enter = true
	
	# DEBUG output dash cooldown is over
	print_debug("[DASH] complete dash cooldown: %.1f sec" % cooldown_sec)
	
func _handle_particle_effect():
	var shader_material: ShaderMaterial = particle.material
	if player.is_on_floor():
		particle.texture = dash_sprite_sheet
		shader_material.set("shader_param/particles_anim_h_frames", 3)
		shader_material.set("shader_param/particles_anim_v_frames", 1)
	else:
		particle.texture = front_flip_sprite_sheet
		shader_material.set("shader_param/particles_anim_h_frames", 3)
		shader_material.set("shader_param/particles_anim_v_frames", 3)
		
	
