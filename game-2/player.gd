extends CharacterBody2D

# Arrow keys to move, SPACE to jump.

const SPEED := 300.0
const JUMP_VELOCITY := -800.0
# The multiplier for cutting jump height (0.3 means they keep 30% of their momentum)
const JUMP_STOP_MULTIPLIER := 0.2


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_STOP_MULTIPLIER
<<<<<<< HEAD
<<<<<<< HEAD
		
=======
	
>>>>>>> parent of e565262 (Merge branch 'main' of https://github.com/vorrjjard-2/game-dev)
=======
	
>>>>>>> parent of e565262 (Merge branch 'main' of https://github.com/vorrjjard-2/game-dev)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
<<<<<<< HEAD
<<<<<<< HEAD

<<<<<<< HEAD
=======
=======
		animated_sprite.play("idle")
		
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		if direction != 0:
			animated_sprite.play("move")
		else:
			animated_sprite.play("idle")
			
	move_and_slide()
	
	if is_on_wall() and is_on_floor():
>>>>>>> parent of e565262 (Merge branch 'main' of https://github.com/vorrjjard-2/game-dev)
		animated_sprite.play("idle")
		
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		if direction != 0:
			animated_sprite.play("move")
		else:
			animated_sprite.play("idle")
			
>>>>>>> parent of e565262 (Merge branch 'main' of https://github.com/vorrjjard-2/game-dev)
=======
>>>>>>> parent of 938e5f8 (Merge branch 'main' into alexys-proj2)
	move_and_slide()
