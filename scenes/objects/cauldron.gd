extends Area2D

class_name Cauldron

@export var starting_defense_pos : Node2D
@export var spawn : Node2D
@export var team : String
@export var is_players_cauldron : bool
@export var enemy_cauldron : Cauldron

var health : int
var max_health : int = 100
var ingredient_one : Item = null
var ingredient_two : Item = null
var num = 0
var num_raw_mat = 0

var army_reference = []

var raw_mat_item = preload("res://resources/items/raw_material.tres") as Item

var result = {
	"soul" : {
		"soul" : "soul_minion",
		"rune" : "miner",
		"phantom_weave" : "soul_minion",
		"bloodvine" : "soul_minion",
		"wyrm_bone" : "soul_minion"
		},
	"rune" : {
		"soul" : "soul_minion",
		"rune" : "soul_minion",
		"phantom_weave" : "soul_minion",
		"bloodvine" : "soul_minion",
		"wyrm_bone" : "soul_minion"
	},
	"phantom_weave" : {
		"soul" : "soul_minion",
		"rune" : "soul_minion",
		"phantom_weave" : "soul_minion",
		"bloodvine" : "soul_minion",
		"wyrm_bone" : "soul_minion"
	},
	"bloodvine" : {
		"soul" : "soul_minion",
		"rune" : "soul_minion",
		"phantom_weave" : "soul_minion",
		"bloodvine" : "soul_minion",
		"wyrm_bone" : "soul_minion"
	},
	"wyrm_bone" : {
		"soul" : "soul_minion",
		"rune" : "soul_minion",
		"phantom_weave" : "soul_minion",
		"bloodvine" : "soul_minion",
		"wyrm_bone" : "soul_minion"
	}
}

var enemies = {
	"soul_minion" : preload("res://scenes/entities/soul_minion.tscn"),
	"miner" : preload("res://scenes/entities/miner.tscn")
}

func _ready():
	health = max_health
	
	if !is_players_cauldron:
		$Control/Accept.visible = false
		$Control/Decline.visible = false
		$Control/RawMaterialButton.visible = false
		$Control/VBoxContainer1.visible = false
		$Control/TextureProgressBar.visible = true
	else:
		$Control/Accept.visible = true
		$Control/Decline.visible = true
		$Control/RawMaterialButton.visible = true
		$Control/VBoxContainer1.visible = true
		$Control/TextureProgressBar.visible = true
	
	$Control/TextureProgressBar.value = max_health
	$Control/TextureProgressBar.max_value = max_health
	
	$Control/Accept.disabled = true
	$Control/Decline.disabled = true
	
	if team == "cpu":
		var rand_next_spawn = randi_range(15, 20)
		$CPUSpawnTimer.start(rand_next_spawn)

func _on_button_drop(pos : Vector2, node : Moveable):
	if pos.distance_to(global_position) <= 14:
		node.reduce_number()
		add_ingredient(node.data)

func take_damage(dmg : int):
	health -= dmg
	$Control/TextureProgressBar.value = health
	if health <= 0:
		pass # Game over

func store_ingredient(data : Item):
	if data.id == "raw_material":
		$Control/RawMaterialButton.add_number()
		return
	
	for c in $Control/VBoxContainer1.get_children():
		if c.data.id == data.id:
			c.add_number()

func add_ingredient(data : Item):
	if data.id == "raw_material":
		num_raw_mat += 1
	else:
		if num == 0:
			ingredient_one = data
			num += 1
		elif num == 1:
			ingredient_two = data
	
	if ingredient_one != null || ingredient_two != null || num_raw_mat != 0:
		$Control/Decline.disabled = false
	else:
		$Control/Decline.disabled = true
	
	if ingredient_one != null && ingredient_two != null:
		$Control/Accept.disabled = false
		toggle_ingredients(true)

func toggle_ingredients(boo : bool):
	for c in $Control/VBoxContainer1.get_children():
		c.toggle_disable(boo)

func _on_accept_pressed():
	var entity_id = result[ingredient_one.id][ingredient_two.id]
	var entity = enemies[entity_id].instantiate() as Entity
	var loc
	if team == "player":
		loc = "left"
	else:
		loc = "right"
	entity.global_position = spawn.global_position
	entity.set_team(team, loc, enemy_cauldron, global_position)
	on_new_entity(entity)
	get_parent().add_child(entity)
	army_reference.push_back(entity)
	ingredient_one = null
	ingredient_two = null
	num = 0
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true
	toggle_ingredients(false)
	num_raw_mat = 0

func _on_decline_pressed():
	if ingredient_one != null:
		store_ingredient(ingredient_one)
	if ingredient_two != null:
		store_ingredient(ingredient_two)
	for n in num_raw_mat:
		store_ingredient(raw_mat_item)
	ingredient_one = null
	ingredient_two = null
	num = 0
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true
	toggle_ingredients(false)
	num_raw_mat = 0

func set_defense_positions():
	var row = 0
	var column = 0 
	for e in get_tree().get_nodes_in_group(team):
		e.set_defense_position(row, column, starting_defense_pos.global_position)
		row += 1
		if row == 4:
			row = 0
			column += 1

func on_new_entity(entity : Entity):
	var row = 0
	var column = 0
	for e in get_tree().get_nodes_in_group(team):
		row += 1
		if row == 4:
			row = 0
			column += 1
	
	entity.set_defense_position(row, column, starting_defense_pos.global_position)

##################### CPU LOGIC #####################

	## RULE 1
	# First check how many collectors we have
	# CPU will try to always have 3 at once
	
	## RULE 2
	# If CPU has significant resources they will get 2 more collectors
	
	## RULE 3
	# CPU will spawn any random enemy if rule 2 and 1 are maxed out or not met
	
	## RULE 4
	# If player is defending and has collectors far away from defense 
	# CPU has a 50% chance of attacking on timeout
	
	## RULE 5
	# If CPU has greater numbers CPU will attack if non of the other conditions are met

func _on_cpu_spawn_timer_timeout():
	
	var rule_one = false
	var rule_two = false
	var rule_three = false
	var rule_four = false
	var rule_five = false
	
	var num_collectors = 0
	for e in army_reference:
		if is_instance_of(e, Miner) && is_instance_valid(e):
			num_collectors += 1
	
	if num_collectors < 3:
		rule_one = true
	
	if num_collectors >= 3 && num_collectors < 5:
		if Global.team[team]["raw_material"] > 5:
			rule_two = true
	
	if !rule_one && !rule_two:
		rule_three = true
	
	var sampled_enemy_entity
	for enemy in get_tree().get_nodes_in_group(get_opposite_group()):
		if is_instance_valid(enemy) && !is_instance_of(enemy, Miner):
			sampled_enemy_entity = enemy
	
	if sampled_enemy_entity.state == Entity.DEFEND:
		for miner in get_tree().get_nodes_in_group(get_opposite_group()):
			if is_instance_valid(miner) && is_instance_of(miner, Miner):
				if miner.global_position.distance_to(enemy_cauldron.global_position) > 1000:
					rule_four = true
		
	
	if rule_one:
		pass
	elif rule_two:
		pass
	elif rule_three:
		pass
	elif rule_four:
		pass
	elif rule_five:
		pass
	
	var rand_next_spawn = randi_range(15, 20)
	$CPUSpawnTimer.start(rand_next_spawn)

func _on_cpu_resource_timer_timeout():
	var rand = randi_range(0, 100)
	
	if rand < 46:
		add_ingredient(Global.item["soul"])
	elif rand < 71:
		add_ingredient(Global.item["rune"])
	elif rand < 86:
		add_ingredient(Global.item["phantom_weave"])
	elif rand < 96:
		add_ingredient(Global.item["bloodvine"])
	elif rand < 101:
		add_ingredient(Global.item["wyrm_bone"])

func get_opposite_group() -> String:
	match team:
		"player":
			return "cpu"
		"cpu":
			return "player"
	
	return "na"
