extends CanvasLayer
signal score_change(new_score: int)
@onready var state_machine = %StateMachine
@onready var weapon_status = %WeaponStatus
@onready var fragment_status = %FragmentStatus
	
func _ready() -> void:
	score_change.connect(_update_fragment_status)

func update_state_machine(_name: StringName):
	var state_name: Label = state_machine.get_node("StateName")
	state_name.text = _name

func update_weapon_status(_name: StringName):
	var weapon_name: Label = weapon_status.get_node("WeaponName")
	weapon_name.text = _name
	
func _update_fragment_status(_score: int):
	var count_label: Label = fragment_status.get_node("FragmentCount")
	count_label.text = str(_score)
