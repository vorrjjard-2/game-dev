extends Node

var players = []
var enemies = []
var turn_order = []
var turn = 0
var current
var bloodrage = false
var multistrike = false
var devotion = false

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
	if current.is_guarding:
		current.is_guarding = false
	
	if current.is_player:
		add_log(current.char_name + "'s turn")
		$"../UI/CommandMenu".show()
		$"../UI/CommandMenu/BloodrageButton".hide()
		$"../UI/CommandMenu/MultiStrikeButton".hide()
		$"../UI/CommandMenu/DevotionButton".hide()
		if current.char_name == "Fighter":
			$"../UI/CommandMenu/BloodrageButton".show()
		elif current.char_name == "Mage":
			$"../UI/CommandMenu/MultiStrikeButton".show()
		elif current.char_name == "Cleric":
			$"../UI/CommandMenu/DevotionButton".show()
	else:
		await get_tree().create_timer(0.7).timeout
		var alive_players = get_alive(players)
		var target = alive_players[randi() % alive_players.size()]
		var action = randi_range(1,2)
		if action == 1:
			await attack(current, target)
		else:
			await guard()
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

func attack(attacker, target) -> void:
	if bloodrage == true:
		await attacker.play_animation("bloodrage")
	else:
		await attacker.play_animation("attack")
	attacker.play_animation("idle")

	var roll = randi_range(1, 20)
	var total = roll + attacker.attack_bonus

	var dice = attacker.damage_dice
	if roll == 20:
		dice = dice * 2

	var damage = attacker.damage_bonus
	var target_damage = damage
	for i in range(dice):
		damage = damage + randi_range(1, attacker.damage_sides)

	if roll == 1 or (roll != 20 and total < target.armor_class):
		if attacker.char_name == "Fighter" and bloodrage == true:
			attacker.take_damage(target_damage)
			add_log(attacker.char_name + " BLOODRAGES " + target.char_name + " and misses! (" + str(total) + " vs AC " + str(target.armor_class) + ")")
			add_log(attacker.char_name + "'s BLOODRAGE deals " + str(target_damage) + " to himself.")
			if attacker.is_alive() == false:
				bloodrage_die(attacker)
			bloodrage = false
		else:
			add_log(attacker.char_name + " attacks " + target.char_name + " and misses! (" + str(total) + " vs AC " + str(target.armor_class) + ")")
		return
	
	if bloodrage == true:
		target_damage = damage * 2
	if target.is_guarding:
		target_damage = damage * 0.5
	target.take_damage(target_damage)

	if roll == 20:
		if attacker.char_name == "Fighter" and bloodrage == true:
			attacker.take_damage(target_damage)
			add_log("CRITICAL HIT! " + attacker.char_name + " BLOODRAGES " + target.char_name + " for " + str(target_damage) + " damage!")
			add_log(attacker.char_name + "'s BLOODRAGE deals " + str(target_damage) + " to himself.")
			if attacker.is_alive() == false:
				bloodrage_die(attacker)
			bloodrage = false
		else:
			add_log("CRITICAL HIT! " + attacker.char_name + " hits " + target.char_name + " for " + str(target_damage) + " damage!")
	else:
		if attacker.char_name == "Fighter" and bloodrage == true:
			attacker.take_damage(target_damage)
			add_log(attacker.char_name + " BLOODRAGES " + target.char_name + " for " + str(target_damage) + " damage (" + str(total) + " vs AC " + str(target.armor_class) + ")")
			add_log(attacker.char_name + "'s BLOODRAGE deals " + str(target_damage) + " to himself.")
			if attacker.is_alive() == false:
				bloodrage_die(attacker)
			bloodrage = false
		else:
			add_log(attacker.char_name + " hits " + target.char_name + " for " + str(target_damage) + " damage (" + str(total) + " vs AC " + str(target.armor_class) + ")")

	if target.is_alive() == false:
		add_log(target.char_name + " is down!")
		await target.play_animation("die") # Optional death animation

func bloodrage_die(attacker) -> void:
	add_log(attacker.char_name + " is down!")
	await attacker.play_animation("die") # Optional death animation

func devote(attacker, target) -> void:
	if devotion == true:
		await attacker.play_animation("devotion")
		attacker.play_animation("idle")
		attacker.take_damage(5)
		target.take_damage(-5)
		add_log(attacker.char_name + "'s DEVOTION devotes 5 health to " + target.char_name)
	devotion = false
	add_log(attacker.char_name + "'s DEVOTION wears out")

func multi(attacker) -> void:
	if multistrike == true:
		await attacker.play_animation("multistrike")
		attacker.play_animation("idle")
		add_log(attacker.char_name + " MULTISTRIKES the enemies for 5 damage")
		for enemy in get_alive(enemies):
			enemy.take_damage(5)
	multistrike = false

func guard() -> void:
	current.is_guarding = true
	add_log(current.char_name + " guards and takes reduced damage until their next turn!")

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


func _on_target_pressed(target):
	$"../UI/TargetMenu".hide()
	if current.char_name == "Cleric" and devotion == true:
		await devote(current, target)
	else:
		await attack(current, target)
	next_turn()


func _on_back_button_pressed():
	$"../UI/TargetMenu".hide()
	if devotion == true:
		devotion = false
	$"../UI/CommandMenu".show()


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_guard_button_pressed():
	$"../UI/CommandMenu".hide()
	guard()
	next_turn()


func _on_bloodrage_button_pressed() -> void:
	if bloodrage == false:
		bloodrage = true
		add_log("Fighter's BLOODRAGE enabled")
	else:
		bloodrage = false
		add_log("Fighter's BLOODRAGE disabled")

func _on_devotion_button_pressed() -> void:
	if current.char_name == "Cleric":
		devotion = true
		$"../UI/CommandMenu".hide()

		for child in $"../UI/TargetMenu".get_children():
			if child.name != "TargetTitle" and child.name != "BackButton":
				child.queue_free()

		for ally in get_alive(players):
			if ally.hp < ally.max_hp:
				var button = Button.new()
				button.text = ally.char_name
				button.pressed.connect(_on_target_pressed.bind(ally))
				$"../UI/TargetMenu".add_child(button)

		$"../UI/TargetMenu".move_child($"../UI/TargetMenu/BackButton", -1)
		$"../UI/TargetMenu".show()

func _on_multi_strike_button_pressed() -> void:
	if current.char_name == "Mage":
		multistrike = true
		$"../UI/CommandMenu".hide()
		await multi(current)
	next_turn()
