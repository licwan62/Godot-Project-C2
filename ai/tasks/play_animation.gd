@tool
extends BTAction
@export var anim_to_play := &"walk"
@export var anim_sprite_offset := Vector2()
var anim_sprite: AnimatedSprite2D

func _generate_name() -> String:
	return "Play animation: %s, offset: %s" % \
		[anim_to_play, anim_sprite_offset]

func _enter() -> void:
	anim_sprite =blackboard.get_var(&"anim_sprite")
	anim_sprite.offset = anim_sprite_offset
	anim_sprite.play(anim_to_play)
	
func _tick(delta: float) -> Status:
	return SUCCESS
