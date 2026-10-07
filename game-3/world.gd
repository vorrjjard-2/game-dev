extends Node2D

const ENEMY_SCENE = preload("res://enemy.tscn")
@onready var player: Node2D = $Player
const SPAWN_DISTANCE = 500 
@export var min_spawn_time: float = 2.0  # Minimum delay (seconds)
@export var max_spawn_time: float = 10.0  # Maximum delay (seconds)

func _ready() -> void:
	start_spawn_loop()

func start_spawn_loop() -> void:
	while is_instance_valid(player):
		var wait_time := randf_range(min_spawn_time, max_spawn_time)
		await get_tree().create_timer(wait_time).timeout		
		spawn_enemy()

# func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept"):
#		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate() as CharacterBody2D
	var facing_dir := Vector2.RIGHT
	if player is CharacterBody2D and player.velocity != Vector2.ZERO:
		facing_dir = player.facing

	var spawn_pos = player.global_position + (facing_dir * SPAWN_DISTANCE)
	enemy.global_position = spawn_pos
	enemy.player = player 
	
	add_child(enemy)
