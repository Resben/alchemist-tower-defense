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
		$Control.visible = false
	else:
		$Control.visible = true
	
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

func _on_cpu_spawn_timer_timeout():
	var array = []
	
	for c in Global.team[team]:
		if c != "raw_material":
			for n in Global.team[team][c]:
				array.push_back(Global.item[c])
	
	if array.size() > 1:
		var index_one = randi_range(0, array.size() - 1)
		ingredient_one = array[index_one]
		array.remove_at(index_one)
		var index_two = randi_range(0, array.size() - 1)
		ingredient_two = array[index_two]
		_on_accept_pressed()
	else:
		var entity = enemies["soul_minion"].instantiate() as Entity
		var loc
		if team == "player":
			loc = "left"
		else:
			loc = "right"
		entity.global_position = spawn.global_position
		entity.set_team(team, loc, enemy_cauldron, global_position)
		on_new_entity(entity)
		get_parent().add_child(entity)
	
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
