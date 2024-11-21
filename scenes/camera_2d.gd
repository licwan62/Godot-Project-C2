class_name Camera
extends Camera2D
@export var start_zoom_scale := 1.0
@export var zoomming_length_sec := .5
@export var tracking_target: Node2D
var init_target: Node2D
var track_target_this_frame = true

func _ready() -> void:
	init_target = tracking_target
	
	zoom = Vector2.ONE * 2
	move_camera(tracking_target, start_zoom_scale)
	
	var debug_buttons_container = Hud.get_node("DebugButtons")
	debug_buttons_container.emit_signal("new_camera_enter_tree", self)

func _process(delta: float) -> void:
	if track_target_this_frame:
		global_position = tracking_target.global_position

func _apply_zoom_scale(target_zoom: Vector2, elapsed_time: float, length_sec: float):
	zoom = lerp(
		zoom, target_zoom, Util.get_lerp_weight(elapsed_time, length_sec)
	)
	
func _apply_camera_move(target_pos: Vector2, weight: float):
	global_position = lerp(
		global_position, target_pos, weight
	)

func move_camera(new_target: Node2D, target_zoom_scale: float, length_sec: float = .5):
	if not track_target_this_frame:
		return
		
	var elapsed_time = 0.0
	var target_zoom: Vector2 = Vector2.ONE * target_zoom_scale
	
	while not Util.equal_with_tolerance(global_position, new_target.global_position) or \
	not zoom.is_equal_approx(target_zoom):
		
		track_target_this_frame = false
		
		elapsed_time += Util.get_physics_delta()
		var weight = Util.get_lerp_weight(elapsed_time, length_sec)
		_apply_camera_move(new_target.global_position, weight)
		_apply_zoom_scale(target_zoom, elapsed_time, length_sec)
		
		await get_tree().physics_frame
	
	tracking_target = new_target
	track_target_this_frame = true
		
func reset_position(length_sec: float = .5):
	if not track_target_this_frame:
		return
		
	var elapsed_time = 0.0
	var init_zoom: Vector2 = Vector2.ONE * start_zoom_scale
	
	while not Util.equal_with_tolerance(global_position, init_target.global_position) or \
	not zoom.is_equal_approx(init_zoom):
		
		track_target_this_frame = false
		
		elapsed_time += Util.get_physics_delta()
		var weight = Util.get_lerp_weight(elapsed_time, length_sec)
		_apply_camera_move(init_target.global_position, weight)
		_apply_zoom_scale(init_zoom, elapsed_time, length_sec)
		
		await get_tree().physics_frame
		
	tracking_target = init_target
	track_target_this_frame = true
