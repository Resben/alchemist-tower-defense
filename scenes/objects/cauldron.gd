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
var is_entity_caged = false

var raw_mat_item = preload("res://resources/items/raw_material.tres") as Item

var result = {
	"no_material" : {
		"raw_material" : "soul_minion",
		"bloodvine" : "soul_minion"
		},
	"raw_material" : {
		"no_material" : "soul_minion",
		"raw_material" : "soul_minion",
		"bloodvine" : "soul_minion"
	},
	"bloodvine" : {
		"no_material" : "soul_minion",
		"raw_material" : "soul_minion",
		"bloodvine" : "soul_minion",
	}
}

var enemies = {
	"soul_minion" : load("res://scenes/entities/soul_minionv2.tscn"),
	"miner" : load("res://scenes/entities/miner.tscn")
}

func _ready():
	health = max_health
	
	toggle_ingredients(true)
	$EntityCaged.visible = false
	
	if !is_players_cauldron:
		$Control/Accept.visible = false
		$Control/Decline.visible = false
		$Control/VBoxContainer1.visible = false
		$Control/TextureProgressBar.visible = true
	else:
		$Control/Accept.visible = true
		$Control/Decline.visible = true
		$Control/VBoxContainer1.visible = true
		$Control/TextureProgressBar.visible = true
	
	$Control/TextureProgressBar.value = max_health
	$Control/TextureProgressBar.max_value = max_health
	
	$Control/Accept.disabled = true
	$Control/Decline.disabled = true
	
	if team == "cpu":
		var rand_next_spawn = randi_range(3, 5)
		$CPUSpawnTimer.start(rand_next_spawn)

func _on_button_drop(pos : Vector2, node : Moveable):
	if pos.distance_to(global_position) <= 36:
		add_ingredient(node.data)

func take_damage(dmg : int):
	health -= dmg
	$Control/TextureProgressBar.value = health
	if health <= 0:
		pass # Game over

func store_ingredient(data : Item):
	Global.team[team][data.id] += 1
	for c in $Control/VBoxContainer1.get_children():
		c.update_button()
	get_node("/root/Main/HUD").update_items()

func add_ingredient(data : Item):
	if num == 0:
		ingredient_one = data
		num += 1
	elif num == 1:
		ingredient_two = data
	
	Global.team[team][data.id] -= 1
	for c in $Control/VBoxContainer1.get_children():
		c.update_button()
	get_node("/root/Main/HUD").update_items()
	
	if ingredient_one != null || ingredient_two != null || num_raw_mat != 0:
		$Control/Decline.disabled = false
	else:
		$Control/Decline.disabled = true
	
	if ingredient_one != null || ingredient_two != null:
		$Control/Accept.disabled = false
	
	if ingredient_one != null && ingredient_two != null:
		toggle_ingredients(true)

func toggle_ingredients(boo : bool):
	for c in $Control/VBoxContainer1.get_children():
		c.toggle_disable(boo)

func _on_accept_pressed():
	var entity_id
	
	if ingredient_one == null && ingredient_two != null:
		entity_id = result["no_material"][ingredient_two.id]
	elif ingredient_two == null && ingredient_one != null:
		entity_id = result[ingredient_one.id]["no_material"]
	else:
		entity_id = result[ingredient_one.id][ingredient_two.id]
	
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
	num_raw_mat = 0
	toggle_ingredients(true)
	is_entity_caged = false
	$EntityCaged.visible = false

func spawn_entity(id : String, new_spawn : Vector2 = Vector2.ZERO):
	var entity = enemies[id].instantiate() as Entity
	var loc
	if team == "player":
		loc = "left"
	else:
		loc = "right"
	if new_spawn == Vector2.ZERO:
		entity.global_position = spawn.global_position
	else:
		entity.global_position = new_spawn
	entity.set_team(team, loc, enemy_cauldron, global_position)
	on_new_entity(entity)
	get_parent().add_child(entity)
	army_reference.push_back(entity)

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

func _on_soul_timer_timeout():
	$SoulTimer.start()
	Global.team[team]["soul"] += 1
	get_node("/root/Main/HUD").update_items()

##################### CPU SPAWN LOGIC #####################

	## RULE 1
	# First check how many collectors we have
	# CPU will try to always have 3 at once
	# CPU must have at least 1 collector
	# For every collector there is at least 1 enemy
	
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
	
	var current_state
	var num_collectors = 0
	var enemy_might = 0
	var cpu_might = 0
	for e in army_reference:
		if is_instance_valid(e) && is_instance_of(e, Miner):
			num_collectors += 1
		elif is_instance_valid(e):
			cpu_might += 1
			current_state = e.state
	
	if num_collectors < 2:
		if Global.team[team]["soul"] >= 1:
			rule_one = true
	
	if num_collectors >= 2 && num_collectors < 4:
		if Global.team[team]["soul"] >= 3 && cpu_might > num_collectors:
			rule_two = true
	
	if !rule_one && !rule_two:
		if Global.team[team]["raw_material"] >= 1: 
			rule_three = true
	
	var sampled_enemy_entity
	for enemy in get_tree().get_nodes_in_group(get_opposite_group()):
		if is_instance_valid(enemy) && !is_instance_of(enemy, Miner):
			sampled_enemy_entity = enemy
			enemy_might += 1
	
	if sampled_enemy_entity != null:
		if sampled_enemy_entity.state == Entity.DEFEND:
			for miner in get_tree().get_nodes_in_group(get_opposite_group()):
				if is_instance_valid(miner) && is_instance_of(miner, Miner):
					if miner.global_position.distance_to(enemy_cauldron.global_position) > 1000:
						rule_four = true
	
	if cpu_might > enemy_might && current_state != Entity.ATTACK:
		rule_five = true
	
	if rule_one:
		$ToolRack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), "na")
		Global.team[team]["soul"] -= 1
		#print("enemy summoned a miner")
	elif rule_five:
		get_tree().call_group(team, "update_state", Global.ATTACK)
		#print("enemy went on the offensive")
	elif rule_two:
		$ToolRack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), "na")
		Global.team[team]["soul"] -= 1
		#print("enemy summoned a extra miner")
	elif rule_three:
		spawn_entity("soul_minion")
		Global.team[team]["raw_material"] -= 1
		#print("enemy summoned a combatant")
	elif rule_four:
		var rand = randi_range(1, 100)
		if rand < 51:
			get_tree().call_group(team, "update_state", Global.ATTACK)
			#print("enemy noticed you are mining too far in")
	
	var rand_next_spawn = randi_range(3, 5)
	$CPUSpawnTimer.start(rand_next_spawn)

##################### CPU BASIC LOGIC #####################

## Rule 1
# If CPU has less than 3 collectors they will retreat instantly if an enemy gets close
# Requires a signal
# Cauldron should update miner

## Rule 2
# Else they will retreat if one of them dies
# CPU will retaliate with an attack
# Requires a signal

## Rule 3
# CPU will only send collectors if it is safe to do so


##################### HELPERS #####################

func get_opposite_group() -> String:
	match team:
		"player":
			return "cpu"
		"cpu":
			return "player"
	
	return "na"

func _on_summoning_shadow_drop(pos, id):
	if !is_entity_caged:
		if pos.distance_to(global_position) <= 36:
			$Summoning.moveable_used(id)
			$EntityCaged.visible = true
			is_entity_caged = true
			toggle_ingredients(false)
