extends Node
class_name Health
signal die
signal get_damaged(damage: float)
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var max_health := 100
var health: int

func _ready() -> void:
	health = max_health
	get_damaged.connect(_take_damage)
		
func _take_damage(damage: float):
	health -= damage
	if health <= 0:
		health = 0
		die.emit()
		print_debug("%s is killed and died" % owner.name)
	else:
		print_debug("%s health minus %d, current %d" % [owner, damage, health])
	
func get_health() -> float:
	return health
