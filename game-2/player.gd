extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D

const SPEED := 300.0
const JUMP_VELOCITY := -800.0
const JUMP_STOP_MULTIPLIER := 0.2

var jump_count = 0
var can_dash = true

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and jump_count < 1:
		velocity.y += JUMP_VELOCITY
		jump_count += 1
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_STOP_MULTIPLIER
		
	if is_on_floor():
		if jump_count == 1:
			can_dash = true
		jump_count = 0
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("move")
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")
	
	if Input.is_action_pressed("sprint") and is_on_floor():
		velocity.x = direction * SPEED * 1.75
		
	if Input.is_action_just_pressed("dash") and can_dash == true:
		velocity.x += direction * SPEED * 20
		can_dash = false
			
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
			
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.x = direction * 0
			velocity.y = 0
			
	move_and_slide()
	
	if is_on_wall() and is_on_floor():
		animated_sprite.play("idle")
	
