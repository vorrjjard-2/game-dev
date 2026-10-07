extends Node2D

const ENEMY_SCENE = preload("res://enemy.tscn")
@onready var player: Node2D = $Player
const SPAWN_DISTANCE = 500 

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate() as CharacterBody2D
	var facing_dir := Vector2.RIGHT
	if player is CharacterBody2D and player.velocity != Vector2.ZERO:
		facing_dir = player.facing

	var spawn_pos = player.global_position + (facing_dir * SPAWN_DISTANCE)
	enemy.global_position = spawn_pos
	enemy.player = player # 
	
	add_child(enemy)
