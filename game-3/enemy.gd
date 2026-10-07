extends CharacterBody2D

@onready var body = self
@onready var animated_sprite = $AnimatedSprite2D
@onready var player: Node2D

const SPEED = 50.0

func _ready() -> void:
	animated_sprite.play("idle")
	player = get_tree().get_first_node_in_group("player") as Node2D
	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
	if is_instance_valid(player):
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		animated_sprite.play("walk")			
		move_and_slide()

	if is_on_wall():
		animated_sprite.play("idle")
	
