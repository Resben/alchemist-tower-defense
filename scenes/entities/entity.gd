extends CharacterBody2D
class_name Entity

var MOVEMENT_SPEED = 30
var direction = 0
var enemy_in_view = false
var enemies_in_range = []
var group : String
var defend_location : Vector2
var attack_direction : int

func _ready():
	collision_layer = 2
	collision_mask = 2

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
	
	if direction == 1:
		$Sprite2D.flip_h = false
	elif direction == -1:
		$Sprite2D.flip_h = true
	
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

func attack():
	pass

func defend():
	pass
