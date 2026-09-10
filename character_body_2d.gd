extends CharacterBody2D

const tile_size = 16


@onready var body = $Body
@onready var animated_sprite = $Body/AnimatedSprite2D
var forced_direction_x: int
var forced_direction_y: int

func _ready() -> void:
	animated_sprite.play("idle")
	
func get_move_direction(input_x: float, input_y: float) -> Vector2:
	var dir_x = sign(input_x)
	var dir_y = sign(input_y)
	
	if forced_direction_x != 0:
		return Vector2(sign(forced_direction_x), 0)
	elif dir_x != 0:
		return Vector2(dir_x, 0)
		
	if forced_direction_y != 0:
		return Vector2(0, sign(forced_direction_y))
	elif dir_y != 0:
		return Vector2(0, dir_y)
		
	return Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_x = Input.get_axis("ui_left", "ui_right")
	var input_y = Input.get_axis("ui_up", "ui_down")
	
	var move_dir = get_move_direction(input_x, input_y)
	
	if move_dir != Vector2.ZERO:
		var move = move_dir * tile_size * delta
		var is_colliding = test_move(global_transform, move)
		
		if not is_colliding:
			global_position += move
			if animated_sprite:
				animated_sprite.play("walk")
				if move_dir.x != 0:
					animated_sprite.flip_h = move_dir.x < 0
		else:
			if animated_sprite:
				animated_sprite.play("idle")
	else:
		if animated_sprite:
			animated_sprite.play("idle")
