extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D

const SPEED := 300.0
const JUMP_VELOCITY := -800.0
const JUMP_STOP_MULTIPLIER := 0.2

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_STOP_MULTIPLIER
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("move")
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
		animated_sprite.play("idle")
	
