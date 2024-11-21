class_name PlayerHSM
extends LimboHSM
@onready var idle_state: LimboState = $Idle
@onready var move_state: LimboState = $Move
@onready var jump_state: LimboState = $Jump
@onready var fall_state: LimboState = $Fall
@onready var attack_state: LimboState = $Attack
@onready var dash_state: LimboState = $Dash
@onready var stun_state: LimboState = $Stun
@onready var die_state: LimboState = $Die
@onready var climb_state: LimboState = $Climb
@export var can_control = true

func _ready() -> void:
	init_input_events()
	init_state_machine()
	
	# update state machine on real time
	active_state_changed.connect(_on_active_state_changed)
	
func init_state_machine():
	initial_state = idle_state
	
	move_state.set_guard(func(): return can_control)
	jump_state.set_guard(func(): return can_control and jump_state.can_jump)
	dash_state.set_guard(func(): return can_control and dash_state.can_enter)
	attack_state.set_guard(func(): return can_control and attack_state.can_enter)
	
	# basic motion
	add_transition(idle_state, move_state, &"move!")
	add_transition(idle_state, jump_state, &"jump!")
	add_transition(idle_state, fall_state, &"fall!")
	add_transition(move_state, idle_state, move_state.EVENT_FINISHED) # key released and motion stopped
	add_transition(move_state, jump_state, &"jump!")
	add_transition(move_state, fall_state, &"fall!")
	add_transition(jump_state, fall_state, fall_state.EVENT_FINISHED)
	add_transition(fall_state, idle_state, fall_state.EVENT_FINISHED) # reached the ground
	
	# dodge
	add_transition(ANYSTATE, dash_state, &"dash!")
	add_transition(dash_state, idle_state, dash_state.EVENT_FINISHED)
	add_transition(dash_state, attack_state, &"attack!")
	
	# attack
	add_transition(ANYSTATE, attack_state, &"attack!")
	add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	
	# stun
	add_transition(ANYSTATE, stun_state, "get_damage")
	add_transition(stun_state, idle_state, stun_state.EVENT_FINISHED)
	
	# die
	#add_transition(ANYSTATE, die_state, "die!")
	
	initialize(owner)
	set_active(true)
	
func init_input_events():
	Util.add_action(&"move_left", KEY_A)
	Util.add_action(&"move_right", KEY_D)
	Util.add_action(&"face_up", KEY_W)
	Util.add_action(&"jump", KEY_K)
	Util.add_action(&"attack", KEY_J)
	Util.add_action(&"dash", KEY_L)

## DEBUG update state machine on top bar, output transition message
func _on_active_state_changed(new_state, previous_state):
	Global.update_state(previous_state, new_state)
	Hud.update_state_machine(new_state.name)
	#print("Transition from %s to %s" %[previous_state.name, new_state.name])
	
func set_can_control(_can_control: bool):
	can_control = _can_control
	
