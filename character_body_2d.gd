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

	var input_x = Input.get_axis("ui_left", "ui_right")
	var input_y = Input.get_axis("ui_up", "ui_down")
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
