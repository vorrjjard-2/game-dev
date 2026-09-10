extends Area2D


@export var door: StaticBody2D 
@export var door_sprite: AnimatedSprite2D
@export var door_collision: CollisionShape2D


@onready var lever_sprite = $AnimatedSprite2D
@onready var lever_collision = $CollisionShape2D
var trigger: bool = false

func _ready() -> void:
	lever_sprite.play("default")
	body_entered.connect(_on_lever_body_entered)
	body_exited.connect(_on_body_exited)
func _on_lever_body_entered(body: Node2D) -> void:
	if body.name == "Player" and lever_sprite.animation == "default" and not trigger: 
		open_lever()
	elif body.name == "Player" and lever_sprite.animation == "default2" and not trigger:
		close_lever()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		trigger = false
	
func open_lever() -> void:
	trigger = true
	lever_sprite.play("triggered")
	if door_sprite != null:
		door_sprite.play("open")
	if door_collision != null:
		door_collision.set_deferred("disabled", true)
	await lever_sprite.animation_finished 
	lever_sprite.play("default2")
		
func close_lever() -> void:
	trigger = true
	lever_sprite.play("triggered2")
	if door_sprite != null:
		door_sprite.play("close")
	if door_collision != null:
		door_collision.set_deferred("disabled", false)
	await lever_sprite.animation_finished 
	lever_sprite.play("default")
