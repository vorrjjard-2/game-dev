extends Area2D

const SPEED := 100.0

var direction := Vector2.RIGHT
var shooter: Node = null

func _ready() -> void:
	add_to_group("enemy_projectile")
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(2.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return
	queue_free()
