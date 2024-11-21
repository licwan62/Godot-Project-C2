class_name LocalPopup
extends Popup
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var pop_clear_timer: Timer = $Timer
var instantiator: Node2D
var popup_pos: Vector2
var text: String
var texture_path: NodePath

func _ready() -> void:
	label.text = text
	texture_rect.texture = load(texture_path) if texture_path else null
	texture_rect.visible = true if texture_path else false
	
func _popup_hide():
	queue_free()

func _on_timer_timeout() -> void:
	_popup_hide()
	
func _get_adjusted_center(_offset: Vector2 = Vector2.ZERO) -> Vector2:
	var viewport_center: Vector2 = Util.get_viewport_center()
	var pos_correction: Vector2 = size / 2
	return viewport_center - pos_correction + _offset
	
func init_popup(_instantiator, _text: String, _texture_path: NodePath) -> LocalPopup:
	instantiator = _instantiator
	text = _text
	texture_path = _texture_path	
	return self

func popup_show(_popup_last_sec: float, adjust_offset: Vector2 = Vector2.DOWN * 100):
	pop_clear_timer.start(_popup_last_sec)
	popup(Rect2i(
		_get_adjusted_center(adjust_offset), size
	))
	anim_player.play(&"typing_label")

func popup_hide_later(hide_later_sec: float = .5):
	await get_tree().create_timer(hide_later_sec).timeout
	_popup_hide()
