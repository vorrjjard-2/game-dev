extends CharacterBody3D

const explosion = preload("res://scenes/enemy_explosion.tscn")

@onready var nav = $NavigationAgent3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var hp = 30


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity,0.25)

	move_and_slide()

func target_position(target):
	nav.target_position = target
	
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		explode()
		queue_free()

func explode() -> void:
	var sphere = explosion.instantiate()
	get_tree().current_scene.add_child(sphere)
	sphere.global_position = global_position
