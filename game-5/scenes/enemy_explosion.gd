extends Node3D


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, 1)
	tween.tween_callback(queue_free)
