class_name SideDoor
extends StaticBody2D
@export var popup_last_sec := 1.0
@export_enum(&"close", &"open") var init_anim := "close"
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detection_collision: CollisionShape2D = $AreaDetectPlayer/CollisionShape2D
var collision_shape: RectangleShape2D
var colliding_player := false
var door_popup: LocalPopup

func _ready() -> void:
	anim_sprite.play(init_anim)
	collision_shape = collision.shape as RectangleShape2D
	# enable detecting player, make obstacle
	_disable_collision(false)
	
func _process(delta: float) -> void:
	if colliding_player and Input.is_action_just_pressed("ui_accept"):
		open_door()

func _on_door_open():
	anim_sprite.play(&"open")
	await anim_sprite.animation_finished
	# stop detecting player, shut obstacle
	_disable_collision(true)
	
func _disable_collision(_disable: bool):
	collision.disabled = _disable
	detection_collision.disabled = _disable
	
func open_door():
	_on_door_open.call_deferred()
	
func _popup_show():
	var text = "open (space)"
	# instantiate, add and show popup
	door_popup = preload("res://scenes/popup.tscn")\
		.instantiate()\
		.init_popup(self, text, "")
	
	add_child(door_popup)
	door_popup.popup_show(popup_last_sec)

func _on_area_detect_player_body_entered(body: Node2D) -> void:
	if body is Player:
		colliding_player = true
		_popup_show()

func _on_area_detect_player_body_exited(body: Node2D) -> void:
	if body is Player:
		colliding_player = false
		if door_popup == null:
			return
			
		door_popup.popup_hide_later()
