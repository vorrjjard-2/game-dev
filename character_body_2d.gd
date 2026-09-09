extends CharacterBody2D

# Set this to your desired walking speed
const SPEED = 150.0

@onready var body = $Body
@onready var animated_sprite = $Body/AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# 1. Get input direction (-1, 0, or 1) for X and Y axes
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	# 2. Apply movement velocity based on input direction
	if direction_x:
		velocity.x = direction_x * SPEED
		animated_sprite.play("walk")
		animated_sprite.flip_h = direction_x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_y:
		velocity.y = direction_y * SPEED
		animated_sprite.play("walk")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Play idle animation if the player is standing still
	if direction_x == 0 and direction_y == 0:
		animated_sprite.play("idle")

	# 3. Use Godot's native physics system! 
	# This automatically stops your character perfectly flush against your TileMap collisions.
	move_and_slide()
