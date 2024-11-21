extends LimboState

@onready var player: Player
@onready var weapon_component: WeaponComponent = %WeaponComponent
var state_enter_msec: int

func _ready() -> void:
	player = Util.apply_player_owner(owner)

func _enter() -> void:
	state_enter_msec = Time.get_ticks_msec()
	
func get_time_elapsed_msec() -> int:
	return Time.get_ticks_msec() - state_enter_msec
