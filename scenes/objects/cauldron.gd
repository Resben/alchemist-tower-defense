extends Area2D

var ingredient_one : Item = null
var ingredient_two : Item = null
var num = 0
var num_raw_mat = 0

var result = {
	"soul" : {
		"soul" : "soul_minion",
		"rune" : "entity_2",
		"phantom_weave" : "entity_3",
		"bloodvine" : "entity_4",
		"wyrm_bones" : "entity_5"
		},
	"rune" : {
		"soul" : "soul_minion",
		"rune" : "entity_2",
		"phantom_weave" : "entity_3",
		"bloodvine" : "entity_4",
		"wyrm_bones" : "entity_5"
	},
	"phantom_weave" : {
		"soul" : "soul_minion",
		"rune" : "entity_2",
		"phantom_weave" : "entity_3",
		"bloodvine" : "entity_4",
		"wyrm_bones" : "entity_5"
	},
	"bloodvine" : {
		"soul" : "soul_minion",
		"rune" : "entity_2",
		"phantom_weave" : "entity_3",
		"bloodvine" : "entity_4",
		"wyrm_bones" : "entity_5"
	},
	"wyrm_bones" : {
		"soul" : "soul_minion",
		"rune" : "entity_2",
		"phantom_weave" : "entity_3",
		"bloodvine" : "entity_4",
		"wyrm_bones" : "entity_5"
	}
}

var enemies = {
	"soul_minion" : preload("res://scenes/entities/soul_minion.tscn")
}

func _ready():
	$Control/Accept.disabled = true
	$Control/Decline.disabled = true
	input_pickable = true

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int):
	if Input.is_action_just_pressed("interact"):
		print("interacted with cauldron")

func _on_button_drop(pos : Vector2, node : Moveable):
	if pos.distance_to(global_position) <= 14:
		node.reduce_number()
		add_ingredient(node.data)

func add_ingredient(data : Item):
	if data.id == "raw_material":
		num_raw_mat += 1
		return
	
	if num == 0:
		ingredient_one = data
		num += 1
	elif num == 1:
		ingredient_two = data
	
	if ingredient_one != null || ingredient_two != null:
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
	ingredient_one = null
	ingredient_two = null
	num = 0
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true
	toggle_ingredients(false)
	num_raw_mat = 0

func _on_decline_pressed():
	ingredient_one = null
	ingredient_two = null
	num = 0
	$Control/Decline.disabled = true
	$Control/Accept.disabled = true
	toggle_ingredients(false)
	num_raw_mat = 0
