extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D

const SPEED := 300.0
const JUMP_VELOCITY := -800.0
const JUMP_STOP_MULTIPLIER := 0.2
const MAX_JUMPS := 1
const WALL_JUMP_PUSH := 400.0
const WALL_JUMP_LOCK_TIME := 0.15

var jump_count = 0
var can_dash = true
var wall_jump_lock = 0.0

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	wall_jump_lock = maxf(wall_jump_lock - delta, 0.0)

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("left", "right")

	var on_wall_airborne := is_on_wall() and not is_on_floor()
	var wall_normal := get_wall_normal()
	var wall_dir := 0.0
	if on_wall_airborne:
		wall_dir = -wall_normal.x

	var wall_hugging := on_wall_airborne and wall_dir != 0.0 and signf(direction) == wall_dir

	if Input.is_action_just_pressed("jump"):
		if on_wall_airborne:
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_normal.x * WALL_JUMP_PUSH
			jump_count = MAX_JUMPS
			wall_jump_lock = WALL_JUMP_LOCK_TIME
			wall_hugging = false
		elif jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_STOP_MULTIPLIER

	if is_on_floor():
		can_dash = true
		jump_count = 0

	if wall_hugging:
		velocity.x = 0.0
		velocity.y = 0.0
		animated_sprite.flip_h = wall_normal.x < 0
		animated_sprite.play("fall")
	elif wall_jump_lock <= 0.0:
		if direction:
			velocity.x = direction * SPEED
			animated_sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_pressed("sprint") and is_on_floor():
			velocity.x = direction * SPEED * 1.75

	if Input.is_action_just_pressed("dash") and can_dash == true and direction != 0:
		velocity.x += direction * SPEED * 20
		can_dash = false

	if not wall_hugging:
		if not is_on_floor():
			if velocity.y < 0:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("fall")
		elif direction != 0:
			animated_sprite.play("move")
		else:
			animated_sprite.play("idle")

	move_and_slide()
