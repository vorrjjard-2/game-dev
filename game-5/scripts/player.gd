extends CharacterBody3D

@export var move_speed := 6.0
@export var mouse_sensitivity := 0.003
@export var min_pitch := -1.2
@export var max_pitch := 1.0

@onready var pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
const bullet_scene := preload("res://bullet.tscn")
var dir := Vector3.FORWARD
var can_shoot: bool = true
@export var fire_rate = 0.25
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotation.x = clampf(pivot.rotation.x - event.relative.y * mouse_sensitivity, min_pitch, max_pitch)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	dir = (global_basis * Vector3(input.x, 0.0, input.y)).normalized()
	velocity.x = dir.x * move_speed
	velocity.z = dir.z * move_speed
	move_and_slide()
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()


func shoot() -> void:
	can_shoot = false
	var bullet := bullet_scene.instantiate()
	var screen_center := get_viewport().get_visible_rect().size / 2.0
	var shoot_dir := camera.project_ray_normal(screen_center)
	bullet.direction = shoot_dir
	bullet.shooter = self
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector3.UP * 1.5
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
