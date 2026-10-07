extends CharacterBody2D

const ENEMY_PROJECTILE_SCENE := preload("res://enemy_projectile.tscn")

@onready var body = self
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_collision: Area2D = $Area2D
@onready var shoot_timer: Timer = $Timer

var player: Node2D
const SPEED = 50.0
var is_hurting: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	if not is_instance_valid(player):
		_find_player()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		_find_player()
		return
	if is_hurting:
		velocity = Vector2.ZERO
		animated_sprite.play("hurt")
	else:
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		animated_sprite.play("walk")
		
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0

	move_and_slide()
	if is_on_wall():
		animated_sprite.play("idle")
		
func _find_player() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player or body.is_in_group("player"):
		is_hurting = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player or body.is_in_group("player"):
		is_hurting = false
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ally_projectile") and not is_hurting:
		is_hurting = true
		area.queue_free()
		animated_sprite.play("hurt")
		await animated_sprite.animation_finished
		is_hurting = false
				
func _on_shoot_timer_timeout() -> void:
	# Don't shoot if player isn't in game or enemy is currently playing hurt animation
	if not is_instance_valid(player) or is_hurting or ENEMY_PROJECTILE_SCENE == null:
		return
	shoot()

func shoot() -> void:
	var proj = ENEMY_PROJECTILE_SCENE.instantiate() as Area2D
	var aim_direction := global_position.direction_to(player.global_position)
	proj.direction = aim_direction
	proj.shooter = self
	proj.global_position = global_position
	get_tree().current_scene.add_child(proj)
