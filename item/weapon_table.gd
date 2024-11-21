extends Area2D
class_name WeaponTable
# go processing on player colliding
# colliding and pressed button to open menu
# select weapon by dragging item in placeholder or click option
# press button to exit menu, equip selected weapon
# TODO drag item system 
signal feedback_animation_finish
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var weapon_menu_scene: PackedScene
var detected_player: bool = false

func _ready() -> void:
	Util.add_action(&"open_menu", KEY_O)

func _physics_process(delta: float) -> void:
	if detected_player and Input.is_action_just_pressed("open_menu"):
		# TODO open menu
		var weapon_menu: WeaponMenu = weapon_menu_scene.instantiate()
		weapon_menu.weapon_table = self
		add_child(weapon_menu)
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		detected_player = true
		if anim_sprite.animation != "success" and anim_sprite.animation != "error":
			anim_sprite.play("process")
		else:
			await feedback_animation_finish.connect(func():
				anim_sprite.play("process"))

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		detected_player = false
		anim_sprite.play("default")

func on_menu_close(weapon_changed: bool):
	if weapon_changed:
		anim_sprite.play("success")
	else:
		anim_sprite.play("error")
	await anim_sprite.animation_finished
	emit_signal("feedback_animation_finish")
