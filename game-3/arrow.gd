extends Area2D

const SPEED := 600.0
const WALL_EXPLOSION_SCENE := preload("res://wall_explosion.tscn")

var direction := Vector2.RIGHT
var shooter: Node = null

func _ready() -> void:
	add_to_group("ally_projectile")
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(2.0).timeout.connect(queue_free) 

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return
	if body is TileMapLayer:
		explode()
	queue_free()

func explode() -> void:
	var explosion := WALL_EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
