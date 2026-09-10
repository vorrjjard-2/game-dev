extends Area2D

var entered = false

func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: CharacterBody2D) -> void:
	Global.return_position = body.global_position - Vector2(0,-16)
	Global.should_reposition = false
	Global.world_1_door_open = true
	get_tree().change_scene_to_file("res://world_2.tscn")
