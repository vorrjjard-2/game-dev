extends CharacterBody2D

# Arrow keys to move, SPACE to jump.

const SPEED := 300.0
const JUMP_VELOCITY := -800.0
# The multiplier for cutting jump height (0.3 means they keep 30% of their momentum)
const JUMP_STOP_MULTIPLIER := 0.2


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y *= JUMP_STOP_MULTIPLIER
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_pressed("sprint"):
		velocity.x = direction * SPEED * 1.5

	move_and_slide()
