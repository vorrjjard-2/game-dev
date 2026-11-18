extends Area3D

const SPEED := 25.0

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
	queue_free() 
