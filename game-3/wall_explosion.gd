extends AnimatedSprite2D

func _ready() -> void:
	sprite_frames.set_animation_loop("default", false)
	frame = 0
	play("default")
	animation_finished.connect(queue_free)
