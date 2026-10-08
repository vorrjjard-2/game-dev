extends Area2D

const SPEED := 100.0
@onready var animated_sprite = $AnimatedSprite2D
var direction := Vector2.RIGHT
var shooter: Node = null

func _ready() -> void:
	add_to_group("enemy_projectile")
	rotation = direction.angle()
	animated_sprite.play("default")
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body == shooter or body.is_in_group("enemy"):
		return
	else:
		queue_free()
