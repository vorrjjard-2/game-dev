extends Area2D

func _ready() -> void:
	body_entered.connect(_on_ice_body_entered)
	body_exited.connect(_on_ice_body_exited)

func _on_ice_body_entered(body: Node2D) -> void:
	if "ice_count" in body:
		body.ice_count += 1

func _on_ice_body_exited(body: Node2D) -> void:
	if not "ice_count" in body:
		return
	body.ice_count -= 1
	if body.ice_count <= 0:
		body.ice_count = 0
		body.forced_move_x = 0
		body.forced_move_y = 0
