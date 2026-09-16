extends CharacterBody2D

# Arrow keys to move, SPACE to jump.

const SPEED := 300.0
const JUMP_VELOCITY := -800.0


func _physics_process(delta: float) -> void:
	# Fall.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move left and right.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
