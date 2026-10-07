extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D


var health = 100
const SPEED := 300.0

func _ready() -> void:
	animated_sprite.play("idle")
	

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		animated_sprite.play("walk")
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)	
		animated_sprite.play("idle")
			
	move_and_slide()
	
	if is_on_wall():
		animated_sprite.play("idle")
	
