extends CharacterBody2D
class_name Entity

enum { RETREAT, DEFEND, DEFEND_OFFENSE, ATTACK }


var navRegion : NavigationRegion2D
@onready var nav : NavigationAgent2D = $NavigationAgent2D

var state = DEFEND
var last_state = DEFEND

var MOVEMENT_SPEED = 300
var direction : Vector2
var group : String
var attack_direction : int

var current_lane : String
var defense_position : Vector2
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
	#collision_layer = 2
	#collision_mask = 2
	is_ready = true
	navRegion = get_parent().navRegion
	
	if group == "player":
		nav.avoidance_layers = 1
		nav.avoidance_mask = 1
		
	else:
		nav.avoidance_layers = 2
		nav.avoidance_mask = 2
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	
	if state == DEFEND:
		nav.target_position = defense_position
	else:
		targeted_enemy = get_closet_enemy()
		nav.target_position = targeted_enemy.global_position

func _physics_process(delta):
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	run_state(delta, state)
	
	if nav.is_navigation_finished():
		return
	
	var next_path_position = nav.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * MOVEMENT_SPEED
	direction = new_velocity
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()
	
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func set_team(team : String, defend_location : String, cauldron_to_attack : Node2D, cauldron_pos : Vector2):
	enemy_cauldron = cauldron_to_attack
	defense_position = cauldron_pos
	
	if defend_location == "left":
		attack_direction = 1
	else:
		attack_direction = -1
	group = team
	add_to_group(team)

func get_closet_enemy() -> Node2D:
	var closet : Node2D = enemy_cauldron
	var length = global_position.distance_to(enemy_cauldron.global_position)
	for e in get_tree().get_nodes_in_group(get_opposite_group()):
		if is_instance_valid(e):
			var next_length = global_position.distance_to(e.global_position)
			if next_length < length:
				length = next_length
				closet = e
	
	return closet

func set_defense_position(r : int, c : int, d_pos : Vector2):
	var y_value = 0
	match r:
		0:
			y_value = 0 + d_pos.y
		1:
			y_value = 8 + d_pos.y
		2:
			y_value = 16 + d_pos.y
		3:
			y_value = 24 + d_pos.y
	
	defense_position = Vector2(d_pos.x - (c * 36), y_value)

func take_damage(dmg : int):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.CRIMSON, 0.5)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.5)
	
	stats["hp"] -= dmg
	
	if stats["hp"] <= 0:
		queue_free()

####################### SIGNALS #######################

func _on_animation_finished(anim_name):
	if anim_name == "attack":
		targeted_enemy.take_damage(stats["damage"])

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

## ATTACK

func enter_attack_state():
	pass

func exit_attack_state():
	pass

func run_attack_state(delta):
	pass

## DEFEND

func enter_defend_state():
	nav.target_position = defense_position

func exit_defend_state():
	pass

func run_defend_state(delta):
	pass

## RETREAT

func enter_retreat_state():
	pass

func exit_retreat_state():
	pass

func run_retreat_state(delta):
	pass

## DEFEND OFFENSE

func enter_d_offense_state():
	pass

func exit_d_offense_state():
	pass

func run_d_offense_state(delta):
	pass

####################### HELPERS #######################

func get_opposite_group() -> String:
	match group:
		"player":
			return "cpu"
		"cpu":
			return "player"
	
	return "na"
