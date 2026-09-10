extends Area2D

func _ready() -> void:
	body_entered.connect(_on_ice_body_entered)
	body_exited.connect(_on_ice_body_exited)

func _on_ice_body_entered(body: Node2D) -> void:
	if not "last_move_dir" in body:
		return
	body.ice_count += 1
	body.forced_move_x = int(body.last_move_dir.x)
	body.forced_move_y = int(body.last_move_dir.y)

func _on_ice_body_exited(body: Node2D) -> void:
	if not "last_move_dir" in body:
		return
	body.ice_count -= 1
	if body.ice_count <= 0:
		body.ice_count = 0
		body.forced_move_x = 0
		body.forced_move_y = 0
