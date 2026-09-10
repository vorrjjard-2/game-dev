extends CharacterBody2D

const tile_size = 16
const GRID_SPEED: float = 150.0 

@onready var body = $Body
@onready var animated_sprite = $Body/AnimatedSprite2D
var forced_move_x: int
var forced_move_y: int

# Track movement state and destination tile coordinates
var is_moving: bool = false
var target_position: Vector2 = Vector2.ZERO
var last_input_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	animated_sprite.play("idle")
	target_position = global_position
	
func get_move_direction(input_x: float, input_y: float) -> Vector2:
	var dir_x = sign(input_x)
	var dir_y = sign(input_y)
	
	if forced_move_x != 0:
		dir_x = forced_move_x
		return Vector2(dir_x, 0)
	elif dir_x != 0:
		return Vector2(dir_x, 0)
		
	if forced_move_y != 0:
		return Vector2(0, sign(forced_move_y))
	elif dir_y != 0:
		return Vector2(0, dir_y)
		
	return Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_moving:
		global_position = global_position.move_toward(target_position, GRID_SPEED * delta)
		if animated_sprite and animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		if global_position != target_position:
			return
		is_moving = false

	var input_x = 0.0
	var input_y = 0.0

	if last_input_dir.x == 1.0 and Input.is_action_pressed("ui_right"):
		input_x = 1.0
	elif last_input_dir.x == -1.0 and Input.is_action_pressed("ui_left"):
		input_x = -1.0
	elif last_input_dir.y == 1.0 and Input.is_action_pressed("ui_down"):
		input_y = 1.0
	elif last_input_dir.y == -1.0 and Input.is_action_pressed("ui_up"):
		input_y = -1.0
	else:
		if Input.is_action_pressed("ui_right"):
			input_x = 1.0
			last_input_dir = Vector2(1, 0)
		elif Input.is_action_pressed("ui_left"):
			input_x = -1.0
			last_input_dir = Vector2(-1, 0)
		elif Input.is_action_pressed("ui_down"):
			input_y = 1.0
			last_input_dir = Vector2(0, 1)
		elif Input.is_action_pressed("ui_up"):
			input_y = -1.0
			last_input_dir = Vector2(0, -1)
		else:
			# Fully released all movement keys
			last_input_dir = Vector2.ZERO
			
	var move_dir = get_move_direction(input_x, input_y)
	
	if move_dir != Vector2.ZERO:
		var move = move_dir * tile_size
		var is_colliding = test_move(global_transform, move)
		if not is_colliding:
			target_position = global_position + move
			is_moving = true
			if animated_sprite:
				if animated_sprite.animation != "walk":
					animated_sprite.play("walk")
				if move_dir.x != 0:
					animated_sprite.flip_h = move_dir.x < 0
		else:
			if animated_sprite and animated_sprite.animation != "idle":
				animated_sprite.play("idle")
	else:
		if animated_sprite and animated_sprite.animation != "idle":
			animated_sprite.play("idle")
