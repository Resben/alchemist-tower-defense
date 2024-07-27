extends CharacterBody2D
class_name Entity

enum { RETREAT, DEFEND, ATTACK }

var state = DEFEND
var last_state = DEFEND

var MOVEMENT_SPEED = 30
var direction = 0
var enemy_in_view = false
var enemies_in_range = []
var group : String
var attack_direction : int

var current_lane : String
var defense_position : Vector2
var row : int
var column : int

var targeted_enemy : Node2D
var enemy_cauldron : Node2D

var is_ready = false

var stats = {
	"hp" : 5,
	"max_hp" : 5,
	"damage" : 1,
	"has_range" : false,
	"effects" : {}
}

func _ready():
	collision_layer = 2
	collision_mask = 2
	is_ready = true

func set_team(team : String, defend_location : String, cauldron_to_attack : Node2D, cauldron_pos : Vector2):
	enemy_cauldron = cauldron_to_attack
	defense_position = cauldron_pos
	
	if defend_location == "left":
		attack_direction = 1
	else:
		attack_direction = -1
	group = team
	add_to_group(team)

func _physics_process(delta):
	if enemies_in_range.size() != 0:
		enemy_in_view = true
	else:
		enemy_in_view = false
	
	if direction == 1:
		$Sprite2D.flip_h = false
	elif direction == -1:
		$Sprite2D.flip_h = true
	
	velocity.x = direction * MOVEMENT_SPEED
	move_and_slide()
	
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	print("current state:" + str(state))
	run_state(delta, state)

func get_closet_enemy() -> Node2D:
	var closet : Node2D = enemy_cauldron
	var length = global_position.distance_to(enemy_cauldron.global_position)
	for e in enemies_in_range:
		var next_length = global_position.distance_to(e.global_position)
		if next_length < length:
			length = next_length
			closet = e
	
	return closet

func _on_view_circle_body_entered(body):
	if body.is_in_group(get_opposite_group()):
		enemies_in_range.push_back(body)

func _on_view_circle_body_exited(body):
	if body.is_in_group(get_opposite_group()):
		enemies_in_range.erase(body)

func get_opposite_group() -> String:
	match group:
		"player":
			return "cpu"
		"cpu":
			return "player"
	
	return "na"

func _on_animation_finished(anim_name):
	if anim_name == "attack":
		targeted_enemy.take_damage(stats["damage"])

func switch_lane(lane : String):
	if lane == current_lane:
		return
	
	current_lane = lane
	
	if !is_ready:
		match lane:
			"one":
				$Sprite2D.position.y = 0
			"two":
				$Sprite2D.position.y = 8
			"three":
				$Sprite2D.position.y = 16
			"four":
				$Sprite2D.position.y = 24
	else:
		var tween = get_tree().create_tween()
		match lane:
			"one":
				tween.tween_property($Sprite2D, "position", Vector2(0, 0), 1)
			"two":
				tween.tween_property($Sprite2D, "position", Vector2(0, -8), 1)
			"three":
				tween.tween_property($Sprite2D, "position", Vector2(0, -16), 1)
			"four":
				tween.tween_property($Sprite2D, "position", Vector2(0, -24), 1)

func set_defense_position(r : int, c : int, d_pos : Vector2):
	defense_position = d_pos
	row = r
	column = c
	
	match row:
		0:
			switch_lane("one")
		1:
			switch_lane("two")
		2:
			switch_lane("three")
		3:
			switch_lane("four")

####################### STATES #######################

func update_state(new_state):
	if new_state == Global.ATTACK:
		if state != ATTACK:
			last_state = state
			state = ATTACK
	elif new_state == Global.DEFEND:
		if state != DEFEND:
			last_state = state
			state = DEFEND

func exit_state(state):
	match state:
		ATTACK:
			exit_attack_state()
		DEFEND:
			exit_defend_state()

func enter_state(state):
	match state:
		ATTACK:
			enter_attack_state()
		DEFEND:
			enter_defend_state()

func run_state(delta, state):
	match state:
		ATTACK:
			run_attack_state(delta)
		DEFEND:
			run_defend_state(delta)

func enter_attack_state():
	pass

func exit_attack_state():
	pass

func run_attack_state(delta):
	pass

func enter_defend_state():
	pass

func exit_defend_state():
	pass

func run_defend_state(delta):
	if global_position.x - defense_position.x < 1 && global_position.x - defense_position.x > -1:
		direction = 0
	else:
		direction = sign(global_position.direction_to(defense_position).x) * 1
