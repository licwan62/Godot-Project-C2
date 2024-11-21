extends Area2D
signal lever_on
@export var popup_last_sec := 1.0
@export var tranform_destination: Node2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var lever_anim_sprite: AnimatedSprite2D = $Lever/AnimatedSprite2D
var lever_popup: LocalPopup
var touching_player: Player

func _process(delta: float) -> void:
	if lever_anim_sprite.animation == &"turn_on" and \
	Input.is_action_just_pressed("ui_accept"):
		await lever_anim_sprite.animation_finished
		
		_transform_player()
		


func _transform_player():
	anim_sprite.play(&"activate")
	await anim_sprite.animation_finished
	
	var destination_pos: Vector2 = tranform_destination.global_position
	touching_player.player_transform(destination_pos)


func _popup_show():
	var text = "turn on (space)"
	lever_popup = preload("res://scenes/popup.tscn")\
		.instantiate()\
		.init_popup(self, text, "")
	add_child(lever_popup)
	lever_popup.popup_show(popup_last_sec)


func _alter_animation():
	lever_anim_sprite.play(&"turn_on")
	var timer: Timer = %LeverAutoTurnOffTimer
	timer.start()
	await timer.timeout
	
	lever_anim_sprite.play(&"turn_off")


func _on_body_entered(body) -> void:
	if body is Player:
		touching_player = body


func _on_body_exited(body) -> void:
	if body is Player:
		touching_player = null
	

func _on_lever_area_entered(area) -> void:
	if area is Hitbox:
		_popup_show()
		_alter_animation()
