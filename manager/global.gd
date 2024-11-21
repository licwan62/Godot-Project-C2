extends Node
var basic_knockback := Vector2(100, -100)
@onready var previous_state: LimboState
@onready var active_state: LimboState
@onready var weapon_component: WeaponComponent
@onready var current_weapon: int

var _attack_dict = {
	"kick_up" : Attack.new().init(
		"kick_up", 10, basic_knockback
	),
	"kick_stand" : Attack.new().init(
		"kick_stand", 10, basic_knockback
	),
	"kick_down" : Attack.new().init(
		"kick_down", 20, basic_knockback
	),
	"punch_up" : Attack.new().init(
		"punch_up", 10, basic_knockback
	),
	"punch_1" : Attack.new().init(
		"punch_1", 10, basic_knockback
	),
	"punch_2" : Attack.new().init(
		"punch_2", 10, basic_knockback
	),
	"ground_slam" : Attack.new().init(
		"ground_slam", 20, basic_knockback, Vector2.DOWN * 500
	),
	"slash_1" : Attack.new().init(
		"slash_1", 20, basic_knockback
	),
	"slash_2" : Attack.new().init(
		"slash_2", 20, basic_knockback
	),
	"slash_3" : Attack.new().init(
		"slash_3", 20, basic_knockback
	),
	"slash_stand" : Attack.new().init(
		"slash_stand", 20, basic_knockback
	),
	"slash_up" : Attack.new().init(
		"slash_up", 20, basic_knockback, Vector2.UP * 500
	),
	"slash_run" : Attack.new().init(
		"slash_run", 15, basic_knockback
	),
	"slash_end" : Attack.new().init(
		"slash_end", 30, basic_knockback, Vector2.RIGHT * 100
	),
	"slash_air" : Attack.new().init(
		"slash_air", 20, basic_knockback
	),
	"slash_down" : Attack.new().init(
		"slash_down", 20, basic_knockback, Vector2.DOWN * 500
	),
	"gun_fire_stand" : Attack.new().init(
		"gun_fire_stand", 10, basic_knockback
	),
	"gun_fire_run" : Attack.new().init(
		"gun_fire_run", 10, basic_knockback
	)
}
var attack_dict: Dictionary: 
	get(): return _attack_dict
	
var _scene_score := -1
@onready var scene_score: int: 
	get(): return _scene_score
	set(value): 
		if not _scene_score == value:
			_scene_score = value
			Hud.emit_signal("score_change", value)

func update_state(_previous_state: LimboState, _active_state: LimboState):
	previous_state = _previous_state
	active_state = _active_state
	
class BulletInfo:
	var position: Vector2
	var direction: Vector2
	var speed: int
	
	func init(_pos: Vector2, _dir: Vector2, _speed: int) -> BulletInfo:
		position = _pos
		direction = _dir
		speed = _speed
		return self

class Attack:
	var type: StringName
	var damage: int
	var knockback: Vector2 ## knockback on attackee
	var impulse: Vector2 ## attacker get impulsed
	
	func init(_type: StringName, _damage: int, 
			_knockback: Vector2, _impulse: Vector2 = Vector2.ZERO) -> Attack:
		type = _type
		damage = _damage
		knockback = _knockback
		impulse = _impulse
		return self
		
	func is_attack_floating():
		if type.contains("air"): 
			return true
		return false
		
	func get_attack_impulse() -> Vector2: 
		return impulse
