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
	direction = attack_direction

func exit_attack_state():
	pass

func run_attack_state(delta):
	var enemy = get_closet_enemy()
	if targeted_enemy != enemy:
		# If there is a sizable difference between the two then switch target
		if targeted_enemy.global_position.distance_to(enemy.global_position) > 25:
			targeted_enemy = enemy
	
	if targeted_enemy.global_position.distance_to(global_position) < 15:
		direction = 0
		$AnimationPlayer.play("attack")

func enter_defend_state():
	pass

func exit_defend_state():
	pass

func run_defend_state(delta):
	pass

	#if state == ATTACKING:
		#if !enemies_in_range:
			#direction = attack_direction
		#else:
			#var enemy_to_chase = get_closet_enemy()
	#elif state == DEFENDING:
		#if enemy_in_view:
			#state == CHASE
	#elif state == CHASE:
		#if enemy_to_chase == null:
			#enemy_to_chase = get_closet_enemy()
			#if enemy_to_chase == null:
				#state == DEFENDING
		#else:
			#direction = global_position.direction_to(enemy_to_chase.global_position).x
