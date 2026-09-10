extends Area2D

@export var player: CharacterBody2D
@export var forced_move: Vector2

func _ready() -> void:
	body_entered.connect(_on_pit_body_entered)
	body_exited.connect(_on_pit_body_exited)
	
func _on_pit_body_entered(body: Node2D) -> void:
	# Read directly from forced_move so inspector changes are captured accurately
	if forced_move.x == 1 and "forced_move_x" in body:
		body.forced_move_x = 1
	elif forced_move.x == -1 and "forced_move_x" in body:
		body.forced_move_x = -1
		
	if forced_move.y == 1 and "forced_move_y" in body:
		body.forced_move_y = 1
	elif forced_move.y == -1 and "forced_move_y" in body:
		body.forced_move_y = -1
		
func _on_pit_body_exited(body: Node2D) -> void:
	if "forced_move_x" in body:
		body.forced_move_x = 0
	if "forced_move_y" in body:
		body.forced_move_y = 0
