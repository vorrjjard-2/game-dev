extends Node

var players = []
var enemies = []
var turn_order = []
var turn = 0
var current

func _ready():
	$"../UI/CommandMenu".hide()
	await get_tree().process_frame
	players = $"../PlayerParty".get_children()
	enemies = $"../EnemyParty".get_children()
	roll_initiative()
	start_turn()


func roll_initiative():
	for c in players:
		turn_order.append(c)
	for c in enemies:
		turn_order.append(c)

	for c in turn_order:
		c.initiative = randi_range(1, 20) + c.dex_mod
		add_log(c.char_name + " rolled " + str(c.initiative) + " for initiative")

	turn_order.sort_custom(sort_by_initiative)

	var text = "Initiative: "
	for c in turn_order:
		text = text + c.char_name + "  "
	$"../UI/InitiativeLabel".text = text


func sort_by_initiative(a, b):
	return a.initiative > b.initiative


func start_turn():
	current = turn_order[turn]
	current.get_node("TurnMarker").visible = true

	if current.is_player:
		add_log(current.char_name + "'s turn")
		$"../UI/CommandMenu".show()
	else:
		await get_tree().create_timer(0.7).timeout
		var alive_players = get_alive(players)
		var target = alive_players[randi() % alive_players.size()]
		await attack(current, target)
		next_turn()


func next_turn():
	current.get_node("TurnMarker").visible = false
	await get_tree().create_timer(0.7).timeout

	if check_game_over():
		return

	turn = turn + 1
	if turn >= turn_order.size():
		turn = 0
	while turn_order[turn].is_alive() == false:
		turn = turn + 1
		if turn >= turn_order.size():
			turn = 0

	start_turn()


# Make attack an async function using -> void, and add 'await' calls
func attack(attacker, target) -> void:
	# 1. Play attacker's attack animation
	await attacker.play_animation("attack")
	await attacker.play_animation("idle")

	var roll = randi_range(1, 20)
	var total = roll + attacker.attack_bonus

	if roll == 1 or (roll != 20 and total < target.armor_class):
		add_log(attacker.char_name + " attacks " + target.char_name + " and misses! (" + str(total) + " vs AC " + str(target.armor_class) + ")")
		return

	# 2. Play target's hurt animation on hit
	await target.play_animation("hurt")
	await target.play_animation("idle")
	var dice = attacker.damage_dice
	if roll == 20:
		dice = dice * 2

	var damage = attacker.damage_bonus
	for i in range(dice):
		damage = damage + randi_range(1, attacker.damage_sides)
	
	target.take_damage(damage)

	if roll == 20:
		add_log("CRITICAL HIT! " + attacker.char_name + " hits " + target.char_name + " for " + str(damage) + " damage!")
	else:
		add_log(attacker.char_name + " hits " + target.char_name + " for " + str(damage) + " damage (" + str(total) + " vs AC " + str(target.armor_class) + ")")

	if target.is_alive() == false:
		add_log(target.char_name + " is down!")
		await target.play_animation("die") # Optional death animation



func get_alive(list):
	var alive = []
	for c in list:
		if c.is_alive():
			alive.append(c)
	return alive


func check_game_over():
	if get_alive(enemies).size() == 0:
		show_result("Victory!")
		return true
	if get_alive(players).size() == 0:
		show_result("Defeat...")
		return true
	return false


func show_result(text):
	$"../UI/CommandMenu".hide()
	$"../UI/TargetMenu".hide()
	$"../UI/ResultPanel/VBox/ResultLabel".text = text
	$"../UI/ResultPanel".show()
	add_log(text)


func add_log(text):
	$"../UI/BattleLog".add_text(text + "\n")


func _on_attack_button_pressed():
	$"../UI/CommandMenu".hide()

	for child in $"../UI/TargetMenu".get_children():
		if child.name != "TargetTitle" and child.name != "BackButton":
			child.queue_free()

	for enemy in get_alive(enemies):
		var button = Button.new()
		button.text = enemy.char_name
		button.pressed.connect(_on_target_pressed.bind(enemy))
		$"../UI/TargetMenu".add_child(button)

	$"../UI/TargetMenu".move_child($"../UI/TargetMenu/BackButton", -1)
	$"../UI/TargetMenu".show()


func _on_target_pressed(enemy):
	$"../UI/TargetMenu".hide()
	await attack(current, enemy)
	next_turn()


func _on_back_button_pressed():
	$"../UI/TargetMenu".hide()
	$"../UI/CommandMenu".show()


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
