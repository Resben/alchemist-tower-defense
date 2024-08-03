extends Area2D

class_name Cauldron

@export var starting_defense_pos : Node2D
@export var spawn : Node2D
@export var team : String
@export var is_players_cauldron : bool
@export var enemy_cauldron : Cauldron

var hostile_state = Global.DEFEND
var last_hostile_state = Global.DEFEND
var passive_state = Global.MINE
var last_passive_state = Global.MINE

var cpu : CPU
@onready var _toolrack = $ToolRack
@onready var _summoning = $Summoning

var health : int
var max_health : int = 75

var ingredients_added : Array[Item]
var is_entity_caged = false

var hostile_references = []
var passive_reference = []

var menu = load("res://scenes/start_screen.tscn")

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
		cpu = load("res://scenes/other/cpu.tscn").instantiate() as CPU
		cpu.setup(self)
		add_child(cpu)

func _on_button_drop(pos : Vector2, node : Moveable):
	if pos.distance_to(global_position) <= 36:
		add_ingredient(node.data)

func take_damage(dmg : int):
	health -= dmg
	$Control/TextureProgressBar.value = health
	if health <= 0:
		var menu_insta = menu.instantiate()
		if team == "player":
			menu_insta.set_as_end_screen("lost")
			get_node("/root/").add_child(menu_insta)
			get_tree().paused = true
			queue_free()
		elif team == "cpu":
			menu_insta.set_as_end_screen("win")
			get_node("/root/").add_child(menu_insta)
			get_tree().paused = true
			queue_free()

func store_ingredient(data : Item):
	Global.team[team][data.id] += 1
	get_node("/root/Main").force_update()

func force_update_items():
	for c in $Control/VBoxContainer1.get_children():
		c.update_button()

func add_ingredient(data : Item):
	ingredients_added.push_back(data)
	Global.team[team][data.id] -= 1
	
	get_node("/root/Main").force_update()
	
	if ingredients_added.size() >= 1:
		$Control/Decline.disabled = false
		$Control/Accept.disabled = false

func toggle_ingredients(boo : bool):
	for c in $Control/VBoxContainer1.get_children():
		c.toggle_disable(boo)

func _on_accept_pressed():
	var entity_id = Global.get_result(ingredients_added)
	print(entity_id)
	spawn_entity(entity_id)
	ingredients_added.clear()
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true
	toggle_ingredients(true)
	is_entity_caged = false
	$EntityCaged.visible = false

func spawn_entity(id : String, new_spawn : Vector2 = Vector2.ZERO):
	var entity = Global.enemies[id].instantiate() as Entity
	if new_spawn == Vector2.ZERO:
		entity.global_position = spawn.global_position
	else:
		entity.global_position = new_spawn
	entity.set_team(self, enemy_cauldron)
	get_parent().add_child(entity)
	
	if is_instance_of(entity, Passive):
		passive_reference.push_back(entity)
		on_new_passive(entity)
	else:
		hostile_references.push_back(entity)
		on_new_hostile(entity)

func _on_decline_pressed():
	for i in ingredients_added:
		store_ingredient(i)
	
	ingredients_added.clear()
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true

func set_defense_positions():
	var row = 0
	var column = 0 
	for e in hostile_references:
		e.set_defense_position(row, column, starting_defense_pos.global_position)
		row += 1
		if row == 4:
			row = 0
			column += 1

func on_new_passive(entity : Passive):
	var row = 0
	var column = 0
	for e in passive_reference:
		row += 1
		if row == 4:
			row = 0
			column += 1
	
	entity._on_death.connect(_on_passive_death)
	entity.set_defense_position(row, column, starting_defense_pos.global_position)

func on_new_hostile(entity : Hostile):
	var row = 0
	var column = 0
	for e in hostile_references:
		row += 1
		if row == 4:
			row = 0
			column += 1
	
	entity._on_death.connect(_on_hostile_death)
	entity.set_defense_position(row, column, starting_defense_pos.global_position)

func _on_soul_timer_timeout():
	$SoulTimer.start()
	Global.team[team]["soul"] += 1
	get_node("/root/Main/HUD").update_items()

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
		if pos.distance_to(global_position) <= 36 || pos == Vector2(-999, -999):
			$Summoning.moveable_used(id)
			$EntityCaged.visible = true
			is_entity_caged = true
			toggle_ingredients(false)

func _on_game_timeout_timeout():
	queue_free()

func _on_passive_death(entity):
	update_passive_state(Global.RETREAT)
	$ReturnMine.start()

func _on_hostile_death(entity):
	pass

func _on_return_mine_timeout():
	update_passive_state(Global.MINE)

func update_hostile_state(new_state):
	if hostile_state != new_state:
		last_hostile_state = hostile_state
		hostile_state = new_state

func update_passive_state(new_state):
	if passive_state != new_state:
		last_passive_state = passive_state
		passive_state = new_state
