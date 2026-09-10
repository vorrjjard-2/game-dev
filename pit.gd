extends Area2D

@export var player: CharacterBody2D
@export var forced_direction: Vector2
const SPEED = 150.0
var x = forced_direction.x
var y = forced_direction.y

func _ready() -> void:
	body_entered.connect(_on_pit_body_entered)
	body_exited.connect(_on_pit_body_exited)
	
func _on_pit_body_entered(body: Node2D) -> void:
	
	if x == 1:
		body.forced_direction_x = 1
	elif x == -1:
		body.forced_direction_x = -1
	elif y == 1:
		body.forced_direction_y = 1
	elif y == -1:
		body.forced_direction_y = -1
		
func _on_pit_body_exited(body: Node2D) -> void:
	body.forced_direction_x = 0
	body.forced_direction_y = 0
