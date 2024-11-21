extends Node

var is_move_key_pressed: int:
	get: return Input.get_axis("move_left", "move_right")
	
var is_move_key_released: bool:
	get: return Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")

func get_enum_name(_enum: Dictionary, value: int) -> StringName:
	for key in _enum.keys():
		if _enum[key] == value:
			return key
	return ""
	
func get_sprite_animation_duration(anim_sprite: AnimatedSprite2D, anim_name: StringName) -> float:
	var frame_count = anim_sprite.sprite_frames.get_frame_count(anim_name)
	var speed = anim_sprite.sprite_frames.get_animation_speed(anim_name)
	if speed == 0:
		return 0
	return frame_count / speed
	
func pause_animation_at_frame(anim_sprite: AnimatedSprite2D, anim_name: StringName, frame_to_stop: int):
	var frame_count = anim_sprite.sprite_frames.get_frame_count(anim_name)
	if frame_to_stop > frame_count - 1:
		return
	if anim_sprite.frame == frame_to_stop:
		anim_sprite.pause()
	
func set_anim_speed(anim_sprite: AnimatedSprite2D, anim: StringName, desire_duration: float):
	if desire_duration == 0:
		return
	var frame_count = anim_sprite.sprite_frames.get_frame_count(anim)
	var desire_speed = frame_count / desire_duration
	anim_sprite.sprite_frames.set_animation_speed(anim, desire_speed)

func add_action(action: StringName, key: int, alt_key: int = KEY_NONE):
	if not InputMap.has_action(action):
		InputMap.add_action(action)
		var event = InputEventKey.new()
		event.keycode = key
		InputMap.action_add_event(action, event)
		if alt_key != KEY_NONE:
			var alt_event = InputEventKey.new()
			alt_event.keycode = alt_key
			InputMap.action_add_event(action, alt_event)
			
func get_move_forward_weight(from, to, duration_sec: float) -> float:
	if from is Vector2 and to is Vector2:
		var length = float(abs(to.length() - from.length()))
		return length / duration_sec
	return float(abs(to - from)) / duration_sec

func get_lerp_weight(elapsed_time: float, duration: float) -> float:
	return clamp(pow(elapsed_time / duration, 2), 0.0, 1.0)
	
func apply_player_owner(_owner) -> Player:
	assert(_owner is Player, "owner (%s) of type %s, which should be Player" % 
								[_owner.name, typeof(_owner)])
	return _owner
	
# play animation with speed calculated by duration of attacking sprite animation 
func get_good_anim_speed(sprite_anim: StringName, player_anim: StringName,\
anim_sprite: AnimatedSprite2D, anim_player: AnimationPlayer):
	# get duration of playing animation
	var duration = Util.get_sprite_animation_duration(anim_sprite, sprite_anim)
	var animation = anim_player.get_animation(player_anim)
	return animation.length / duration
	
func scale_all_frames_in_anim_player(anim_player: AnimationPlayer, anim_name: StringName, 
									duration_sec: float):
	assert(anim_player.has_animation(anim_name), "%s not exist" % anim_name)
	var anim: Animation = anim_player.get_animation(anim_name)
	var original_duration = anim.length
	var scale_factor = duration_sec / original_duration
	for track_idx in anim.get_track_count():
		for key_idx in anim.track_get_key_count(track_idx):
			var key_time = anim.track_get_key_time(track_idx, key_idx)
			var new_key_time = scale_factor * key_time
			var key_value = anim.track_get_key_value(track_idx, key_idx)
			anim.track_remove_key(track_idx, key_idx)
			anim.track_insert_key(track_idx, new_key_time, key_value)
	anim.length = duration_sec
	
func get_physics_delta() -> float:
	return 1.0 / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	
func equal_with_tolerance(v1: Vector2, v2: Vector2, tolerance: float = .01):
	return abs(v1.x - v2.x) < tolerance or abs(v1.y - v2.y) < tolerance
	
func get_viewport_center() -> Vector2:
	var rect = get_viewport().get_visible_rect()
	return rect.size / 2
