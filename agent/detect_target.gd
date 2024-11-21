extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@export var detect_radius: int = 100
var shape: CircleShape2D

func _ready() -> void:
	if collision.shape == null:
		shape = CircleShape2D.new()
		shape.radius = detect_radius
		collision.shape = shape
	else:
		shape = collision.shape

func _physics_process(delta: float) -> void:
	shape.radius = detect_radius
