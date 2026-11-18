extends Node2D

@export var char_name = "Name"
@export var is_player = true
@export var is_guarding = false
@export var max_hp = 20
@export var armor_class = 12
@export var dex_mod = 0
@export var attack_bonus = 4
@export var damage_dice = 1
@export var damage_sides = 6
@export var damage_bonus = 2
@onready var animated_sprite = $AnimatedSprite2D

var hp = 0
var initiative = 0

func _ready():
	hp = max_hp
	$NameLabel.text = char_name
	$HPBar.max_value = max_hp
	update_hp()
	animated_sprite.play("idle")

func take_damage(amount):
	hp = hp - amount
	if hp < 0:
		hp = 0
	update_hp()
	if hp == 0:
		modulate = Color(1, 1, 1, 0.3)

func is_alive():
	return hp > 0

func update_hp():
	$HPBar.value = hp
	$HPLabel.text = str(hp) + "/" + str(max_hp)

func play_animation(anim_name: String):
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
		await animated_sprite.animation_finished
	else:
		print("Sprite animation not found: ", anim_name)
		await get_tree().create_timer(0.3).timeout
