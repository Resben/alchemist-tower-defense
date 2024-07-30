extends Entity
class_name SoulMinion

var should_chase = false

func _ready():
	state = DEFEND
	last_state = DEFEND
	MOVEMENT_SPEED = 40
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

func run_defend_state(delta):
	var enemy = get_closet_enemy()
	if is_instance_valid(enemy) && !is_instance_of(enemy, Cauldron):
		if enemy.state == ATTACK:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < 280:
				targeted_enemy = enemy
				should_chase = true
			else:
				should_chase = false
		else:
			should_chase = false
	else:
		should_chase = false
	
	if should_chase && is_instance_valid(targeted_enemy):
		nav.target_position = targeted_enemy.global_position
		if targeted_enemy.global_position.distance_to(global_position) < 25:
			$AnimationPlayer.play("attack")
	else:
		nav.target_position = defense_position
