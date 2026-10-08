extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var explosion_sprite = $"../Explosion"
@onready var shot_explosion = $"../ShotExplosion"

const ARROW_SCENE := preload("res://arrow.tscn")
var facing := Vector2.RIGHT
const SPEED := 200.0
var is_hurting: bool = false
var playerHealth = 100

func _ready() -> void:
	explosion_sprite.visible = false
	shot_explosion.visible = false
	health_bar.value = playerHealth
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		facing = direction.normalized()
		velocity = direction * SPEED
		animated_sprite.play("walk")
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)	
		animated_sprite.play("idle")
	move_and_slide()
		
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if is_on_wall() and not is_hurting:
		animated_sprite.play("idle")
		
func damagePlayer(damage):
	is_hurting = true
	animated_sprite.play("hurt")
	playerHealth -= damage
	health_bar.value = playerHealth
	if playerHealth <= 0:
		set_physics_process(false)
		animated_sprite.visible = false
		health_bar.visible = false
		explosion_sprite.global_position = global_position
		explosion_sprite.sprite_frames.set_animation_loop("default", false)
		explosion_sprite.frame = 0
		explosion_sprite.visible = true
		explosion_sprite.play("default")
		await explosion_sprite.animation_finished
		get_tree().change_scene_to_file("res://gameover.tscn")
		return
	is_hurting = false
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		damagePlayer(5)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		is_hurting = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectile") and not is_hurting:
		shot_explosion.global_position = area.global_position
		shot_explosion.sprite_frames.set_animation_loop("default", false)
		shot_explosion.frame = 0
		damagePlayer(10)
		area.queue_free()
		shot_explosion.visible = true
		shot_explosion.play("default")
		await shot_explosion.animation_finished
		shot_explosion.visible = false
		
func shoot() -> void:
	var arrow := ARROW_SCENE.instantiate()
	arrow.direction = facing
	arrow.shooter = self
	arrow.global_position = global_position + facing * 20
	get_parent().add_child(arrow)
