extends Node
class_name WeaponComponent
signal current_weapon_changed(new_weapon)
enum Weapons {NONE, SWORD, GUN}
@export var current_weapon: int = Weapons.NONE:
	set(value): 
		if current_weapon != value:
			current_weapon = value
			emit_signal("current_weapon_changed", value)

func _ready() -> void:
	Global.weapon_component = self
	var current_weapon_name: StringName = Util.get_enum_name(Weapons, current_weapon) 
	Hud.update_weapon_status(current_weapon_name)
	Global.current_weapon = current_weapon
	
	current_weapon_changed.connect(func(new_weapon):
		Hud.update_weapon_status(current_weapon_name)
		Global.current_weapon = new_weapon
	)
		
