extends Entity

enum { ATTACKING, DEFENDING, CHASE }

var state = ATTACKING
var last_state = DEFENDING

var enemy_to_chase : Node2D

var stats = {
	"hp" : 5,
	"max_hp" : 5,
	"damage" : 1,
	"has_range" : false,
	"effects" : {}
}

func set_state(state_str : String):
	match state_str:
		"attack":
			state == ATTACKING
		"defend":
			state == DEFENDING

func _physics_process(delta):
	super._physics_process(delta)
	
	if state == ATTACKING:
		if !enemies_in_range:
			direction = attack_direction
	elif state == DEFENDING:
		if enemy_in_view:
			state == CHASE
	elif state == CHASE:
		if enemy_to_chase == null:
			enemy_to_chase = get_closet_enemy()
			if enemy_to_chase == null:
				state == DEFENDING
		else:
			direction = global_position.direction_to(enemy_to_chase.global_position).x
