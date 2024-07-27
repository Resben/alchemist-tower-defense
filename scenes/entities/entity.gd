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
var defend_location : Vector2
var attack_direction : int

var targeted_enemy : Node2D
var enemy_cauldron : Cauldron

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

func set_team(team : String, defend_location : Vector2, cauldron_to_attack : Cauldron):
	enemy_cauldron = cauldron_to_attack
	
	if defend_location.x < 0:
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

####################### STATES #######################

func update_state(state):
	if state == Global.ATTACK:
		if state != ATTACK:
			last_state = state
			state = ATTACK
	elif state == Global.DEFEND:
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
	pass
