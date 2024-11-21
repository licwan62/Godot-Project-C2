extends VBoxContainer

signal new_camera_enter_tree(camera: Camera2D)
var camera_move_focusd_target: Node2D
var current_camera: Camera


func _ready() -> void:
	new_camera_enter_tree.connect(_on_new_player_enter_tree)
	

func _physics_process(delta: float) -> void:
	# specify the new target that button to track
	if get_tree().get_node_count_in_group(&"enemies") > 0:
		camera_move_focusd_target = get_tree().get_first_node_in_group("enemies")
		

func _on_new_player_enter_tree(camera: Camera2D):
	current_camera = camera
	print_debug("get new camera %s" % camera)


func _on_camera_movement_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# move camera to other object
		if camera_move_focusd_target == null:
			return
			
		current_camera.move_camera(
			camera_move_focusd_target, 1
		)
	else:
		# move camera back to player 
		var pos_to_reset = current_camera.get_parent().global_position
		current_camera.reset_position()


func _on_clear_button_pressed() -> void:
	var world: World = get_tree().get_first_node_in_group(&"world")
	if world:
		world.emit_signal("ready_clear")
