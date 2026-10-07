extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D

const ARROW_SCENE := preload("res://arrow.tscn")
var facing := Vector2.RIGHT
const SPEED := 200.0
var is_hurting: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_hurting:
			animated_sprite.play("hurt")
			facing = direction.normalized()
			velocity = direction * SPEED
			move_and_slide()
	else: 
		if direction:
			facing = direction.normalized()
			velocity = direction * SPEED
			animated_sprite.play("walk")
			if velocity.x != 0:
				animated_sprite.flip_h = velocity.x < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)	
			animated_sprite.play("idle")
		move_and_slide()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if is_on_wall() and not is_hurting:
		animated_sprite.play("idle")
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		is_hurting = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		is_hurting = false

	
func shoot() -> void:
	var arrow := ARROW_SCENE.instantiate()
	arrow.direction = facing
	arrow.shooter = self
	arrow.global_position = global_position + facing * 20
	get_parent().add_child(arrow)
