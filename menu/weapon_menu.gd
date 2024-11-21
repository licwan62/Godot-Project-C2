class_name WeaponMenu
extends Node2D

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var player_hsm: PlayerHSM
var selected_weapon: int = -1:
	set(value):
		if selected_weapon != value:
			selected_weapon = value
			play_anim_of_selected_weapon(value)
var weapon_on_enter: int
var weapon_component: WeaponComponent = Global.weapon_component
var weapon_table: WeaponTable ## table that calls this menu, parsed on menu instantiated

func _ready() -> void:
	selected_weapon = Global.current_weapon
	weapon_on_enter = selected_weapon
	
	var player = get_tree().get_first_node_in_group(&"player")
	player_hsm = player.get_node("LimboHSM")
	player_hsm.set_can_control(false)

func _on_button_pressed() -> void:
	weapon_component.current_weapon = selected_weapon
	close_menu()
	
func play_anim_of_selected_weapon(new_selection: int):
	match new_selection:
		WeaponComponent.Weapons.NONE: anim_sprite.play("none")
		WeaponComponent.Weapons.SWORD: anim_sprite.play("sword")
		WeaponComponent.Weapons.GUN: anim_sprite.play("gun")
	
func close_menu():
	var weapon_changed = weapon_on_enter != selected_weapon
	weapon_table.on_menu_close(weapon_changed)
	
	player_hsm.set_can_control(true)
	
	queue_free()

func _on_slot_none_pressed() -> void:
	selected_weapon = WeaponComponent.Weapons.NONE

func _on_slot_sword_pressed() -> void:
	selected_weapon = WeaponComponent.Weapons.SWORD

func _on_slot_gun_pressed() -> void:
	selected_weapon = WeaponComponent.Weapons.GUN
