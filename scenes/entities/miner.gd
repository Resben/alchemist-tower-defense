extends Entity
class_name Miner

func _ready():
	state = MINE
	last_state = MINE
	super._ready()
	
	stats = {
		"hp" : 5,
		"max_hp" : 5,
		"damage" : 1,
		"has_range" : false,
		"effects" : {}
	}

func _physics_process(delta):
	super._physics_process(delta)
	
	if state == RETREAT:
		nav.target_position = spawn_pos
	else:
		var next_mineable = get_closet_minable()
		if next_mineable != null:
			nav.target_position = next_mineable.global_position
			targeted_enemy = next_mineable
		
		if global_position.distance_to(targeted_enemy.global_position) < 25:
			$AnimationPlayer.play("mine")

func get_closet_minable() -> Node2D:
	var closet : Node2D = null
	var length = 99999
	for r in get_tree().get_nodes_in_group("resource"):
		if is_instance_valid(r):
			var next_length = global_position.distance_to(r.global_position)
			if next_length < length:
				length = next_length
				closet = r
	
	return closet
