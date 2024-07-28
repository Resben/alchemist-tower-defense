extends Entity

func _ready():
	super._ready()
	
	stats = {
		"hp" : 5,
		"max_hp" : 5,
		"damage" : 1,
		"has_range" : false,
		"effects" : {}
	}

func enter_attack_state():
	targeted_enemy = get_closet_enemy()

func exit_attack_state():
	pass

func run_attack_state(delta):
	var enemy = get_closet_enemy()
	if !is_instance_valid(targeted_enemy):
		targeted_enemy = enemy
	elif targeted_enemy != enemy:
		# If there is a sizable difference between the two then switch target
		var target_distance_to_opposition = targeted_enemy.global_position.distance_to(global_position)
		var new_enemy_distance_to_opposition = enemy.global_position.distance_to(global_position)
		if new_enemy_distance_to_opposition - target_distance_to_opposition < 75:
			targeted_enemy = enemy
	
	nav.target_position = targeted_enemy.global_position
	
	if targeted_enemy.global_position.distance_to(global_position) < 25:
		$AnimationPlayer.play("attack")
