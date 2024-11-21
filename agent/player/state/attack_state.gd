extends "res://agent/player/state/limbo_state.gd"
# melee combo of 3 punches and 3 kicks
# entry denied if key pressed before a duration from last full combo
# combo break if state entered after a duration - do first punch
class_name AttackState
signal sub_attack_state_changed
@onready var ground_punch_state: AttackState2 = $GroundPunch
@onready var air_punch_state: AttackState2 = $AirPunch
@onready var ground_sword_state: AttackState2 = $GroundSword
@onready var air_sword_state: AttackState2 = $AirSword
@onready var ground_gun_state: AttackState2 = $GroundGun
@onready var air_gun_state: AttackState2 = $AirGun
@export var distance_to_slash_down := 100.0
var sub_attack_state: AttackState2:
	set(value):
		if sub_attack_state != value:
			# init combo when sub state changed
			sub_attack_state = value
			emit_signal("sub_attack_state_changed")
const COMBO_FINISH_ANIMS: Array[StringName] = [
	"slash_down", 
	"ground_slam", 
	"punch_up"
]
var state_map = {}
var last_attack_ms := -1000
## infer if is cool down over last full combo
var can_enter := true
## flag inferring to exit attack state
var attack_finished := false
## updated on enter new attack, zero if combo broken
var combo_idx := -1

func _ready() -> void:
	super._ready()
	state_map = {
		0: air_punch_state,
		1: air_sword_state,
		2: air_gun_state,
		10: ground_punch_state,
		11: ground_sword_state,
		12: ground_gun_state
	}
	
	# init combo index when switching to different attack state
	sub_attack_state_changed.connect(func():
		combo_idx = -1
	)

func _enter() -> void:
	super._enter()
	attack_finished = false
	
	# get specified sub attack state
	var current_weapon = Global.current_weapon
	var key = int(player.is_on_floor()) * 10 + current_weapon
	sub_attack_state = state_map.get(key) as AttackState2
	
	# transit to specified attack state depending on weapon and if on floor
	if sub_attack_state != null:
		var interval = Time.get_ticks_msec() - last_attack_ms
		var combo_break_ms = sub_attack_state.get_combo_break_ms()
		combo_idx = _get_combo_idx(interval, combo_break_ms)
		sub_attack_state.init(combo_idx)
		
		sub_attack_state._enter()
		
		var attack = sub_attack_state.get_attack()
		if attack == null:
			return
			
		if not current_weapon == WeaponComponent.Weapons.GUN and \
		player.has_method(&"melee_attack"):
			player.melee_attack.call_deferred(attack)
		
		if current_weapon == WeaponComponent.Weapons.GUN and \
		player.has_method(&"remote_attack"):
			player.remote_attack.call_deferred()
			
		# DEBUG output attack state
		#print("enter: %s" % [sub_attack_state.name])

func _update(delta: float) -> void:
	if sub_attack_state != null and sub_attack_state.has_method("_update"):
		sub_attack_state._update(delta)
		
	if attack_finished:
		get_root().dispatch(EVENT_FINISHED)

func _exit() -> void:
	var playing_anim = sub_attack_state.get_playing_anim()
	var cooldown_ms = sub_attack_state.get_cooldown_ms()
	if _get_is_full_combo(playing_anim):
		can_enter = false
		await get_tree().create_timer(cooldown_ms / 1000).timeout
		can_enter = true
	
	last_attack_ms = Time.get_ticks_msec()
	
## specify sequence of attack animation
func _get_combo_idx(interval_ms: int, _combo_break_ms: int):
	var idx = 0
	var full_combo_count = sub_attack_state.get_full_combo_count()
	# DEBUG output combo status on combo broke
	if interval_ms < _combo_break_ms:
		idx = (combo_idx + 1) % full_combo_count
		# DEBUG output combo status on combo broke
	print_debug("[COMBO] name: %s, index: %d / %d" % 
		[sub_attack_state.name, idx + 1, full_combo_count])
	return idx
	
func _get_is_full_combo(_playing_anim: StringName) -> bool:
	if combo_idx == sub_attack_state.get_full_combo_count() - 1:
		return true
		
	return false
	
## alter flag to exit attack state and update variables to do with combo and cooldown
func exit_attack_state():
	attack_finished = true
	
func get_distance_to_slash_down() -> float:
	return distance_to_slash_down
	
func get_playing_animation() -> StringName:
	assert(sub_attack_state, "null attack state")
	return sub_attack_state.anim_to_play
