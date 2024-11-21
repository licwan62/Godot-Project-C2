extends Node2D

signal emit_bullet(bullet: Bullet)

func _ready() -> void:
	emit_bullet.connect(_emit_bullet)
	
func _emit_bullet(bullet: Bullet):
	add_child(bullet)
