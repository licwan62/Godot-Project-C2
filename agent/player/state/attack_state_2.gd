# handle attack duration to exit attack state
# handle playing attack animation
# specify cooldown and combo break
class_name AttackState2
extends LimboState
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var attack_state: AttackState = get_parent()
@onready var player: Player = Util.apply_player_owner(owner)
@export var cooldown_ms: int
@export var combo_break_ms: int = 500
@export var combo_resource: ComboResource
## set before entry, set in parent attack state
var anim_to_play: StringName
var duration_sec: float = 0
var combo_anims: Array[StringName]

func _ready() -> void:
	var ground_combo = combo_resource.ground_stand_combo
	var air_combo = combo_resource.air_combo
	combo_anims = ground_combo if (name.contains("Ground")) else air_combo

func _enter() -> void:
	_post_enter.call_deferred()
	duration_sec = Util.get_sprite_animation_duration(anim_sprite, anim_to_play)
	anim_sprite.play(anim_to_play)
	
	if _anim_is_attack_floating():
		player.float_in_air(duration_sec)
	
	var impulse_out = [] ## ref to hold value out from function
	if _anim_is_attack_up(impulse_out):
		var impulse = impulse_out[0] as Vector2
		player.slash_up(abs(impulse.y))
		
	if _anim_is_attack_down(impulse_out):
		var impulse = impulse_out[0] as Vector2
		player.slash_down(abs(impulse.y))
	
func _post_enter():
	await get_tree().create_timer(duration_sec).timeout
	_exit()
	
func _exit() -> void:
	attack_state.exit_attack_state()

func _is_good_height_to_slash_down() -> bool:
	var distance_to_slash_down = attack_state.get_distance_to_slash_down()
	var height = player.get_height_over_ground()
	return  height > distance_to_slash_down

func _anim_is_attack_floating():
	var dict: Dictionary = Global.attack_dict
	assert(dict.has(anim_to_play), "dict %s do not has key: %s" %[dict, anim_to_play])
	
	var attack: Global.Attack = dict.get(anim_to_play)
	return attack.is_attack_floating()
	
func _anim_is_attack_up(impulse_out: Array):
	var dict = Global.attack_dict
	assert(dict.has(anim_to_play), "dict %s do not has key: %s" %[dict, anim_to_play])
	
	var attack: Global.Attack = dict.get(anim_to_play)
	var impulse: Vector2 = attack.get_attack_impulse()
	if impulse.y < 0:
		impulse_out.append(impulse)
		return true
	return false
		
func _anim_is_attack_down(impulse_out: Array = []):
	var dict = Global.attack_dict
	assert(dict.has(anim_to_play), "dict %s do not has key: %s" %[dict, anim_to_play])
	
	var attack: Global.Attack = dict.get(anim_to_play)
	var impulse: Vector2 = attack.get_attack_impulse()
	if impulse.y > 0:
		impulse_out.append(impulse)
		return true
	return false

func init(idx: int):
	anim_to_play = combo_anims[idx]
	assert(anim_sprite.sprite_frames.has_animation(anim_to_play),
			"non-existent animation %s" % anim_to_play)
	
func get_full_combo_count() -> int:
	return combo_anims.size()

func get_combo_break_ms() -> int:
	return combo_break_ms
	
func get_cooldown_ms() -> int:
	return cooldown_ms
	
func get_playing_anim() -> StringName:
	return anim_to_play
	
func get_attack() -> Global.Attack:
	var anim_exist = Global.attack_dict.has(anim_to_play)
	assert(anim_exist, "current animation %s isn't exist in dictionary" % anim_to_play)
	
	if anim_exist:
		return Global.attack_dict.get(anim_to_play)
	return
