extends Area3D

const explosion = preload("res://scenes/bullet_explosion.tscn")

const SPEED := 25.0
const damage := 10

var direction := Vector3.UP
var shooter: Node = null

func _ready() -> void:
	add_to_group("ally_projectile")
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(10).timeout.connect(queue_free) 

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return
	elif body.is_in_group("enemy"):
		body.take_damage(damage)
	explode()
	queue_free()
	
func explode() -> void:
	var sphere = explosion.instantiate()
	get_tree().current_scene.add_child(sphere)
	sphere.global_position = global_position
