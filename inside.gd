extends Area2D

var entered = false

func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: CharacterBody2D) -> void:
	Global.should_reposition = true
	get_tree().change_scene_to_file("res://node_2d.tscn")
