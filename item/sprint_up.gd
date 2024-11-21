extends Area2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var sprint_force :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Agent:
		_play_sprint_anim()
		if body.has_method("get_bounced"):
			body.get_bounced(sprint_force)

func _play_sprint_anim():
	anim_sprite.play(&"sprint")
	
