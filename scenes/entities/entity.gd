extends CharacterBody2D
class_name Entity

var MOVEMENT_SPEED = 30
var direction = 0
var enemy_in_view = false
var enemies_in_range = []
var group : String
var defend_location : Vector2
var attack_direction : int

func set_team(team : String, defend_location : Vector2):
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
	
	velocity.x = direction * MOVEMENT_SPEED
	move_and_slide()

func get_closet_enemy() -> Node2D:
	var closet : Node2D
	var length = 99999
	for e in enemies_in_range:
		var next_length = global_position.distance_to(e.global_position)
		if next_length < length:
			length = next_length
			closet = e
	
	return closet

func _on_view_circle_body_entered(body):
	#if body.group != group:
		#enemies_in_range.push_back(body)
	pass

func _on_view_circle_body_exited(body):
	#if body.group != group:
		#enemies_in_range.erase(body)
	pass
