extends Node2D


func _on_goal_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$UI/WinLabel.visible = true
