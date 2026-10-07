extends CharacterBody2D

@onready var body = self
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_collision: Area2D = $Area2D
var player: Node2D
const SPEED = 50.0

func _ready() -> void:
	animated_sprite.play("idle")
	if not is_instance_valid(player):
		_find_player()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		_find_player()
		return
	var is_hurting := hurt_collision.get_overlapping_bodies().has(player)

	if is_hurting:
		velocity = Vector2.ZERO
		animated_sprite.play("hurt")
	else:
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		animated_sprite.play("walk")
		
		if velocity.x != 0:
			animated_sprite.flip_h = velocity.x < 0

	move_and_slide()
	if is_on_wall() and not is_hurting:
		animated_sprite.play("idle")
		
func _find_player() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player or body.is_in_group("player"):
		pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player or body.is_in_group("player"):
		pass
