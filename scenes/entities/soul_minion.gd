extends Hostile
class_name SoulMinion

var should_chase = false
var slash = preload("res://scenes/entities/slash.tscn")


func _ready():
	super._ready()
	
	stats = {
		"hp" : 5,
		"max_hp" : 5,
		"damage" : 1,
		"base_speed" : 45,
		"speed" : 45,
		"has_range" : false,
		"effects" : {}
	}

func enter_attack_state():
	targeted_enemy = get_closet_enemy()

func exit_attack_state():
	pass

func run_attack_state(_delta):
	var enemy = get_closet_enemy()
	if !is_instance_valid(targeted_enemy):
		targeted_enemy = enemy
		if !is_instance_valid(enemy):
			return
	elif targeted_enemy != enemy:
		# If there is a sizable difference between the two then switch target
		var target_distance_to_opposition = targeted_enemy.global_position.distance_to(global_position)
		var new_enemy_distance_to_opposition = enemy.global_position.distance_to(global_position)
		if new_enemy_distance_to_opposition - target_distance_to_opposition < 75:
			targeted_enemy = enemy
	
	nav.target_position = targeted_enemy.global_position
	
	if !is_attacking && targeted_enemy.global_position.distance_to(global_position) < 40:
		nav.target_position = global_position
		is_attacking = true
		var rand = randf_range(0.3, 1.0)
		$AttackTimer.start(rand)
		
	if is_attacking:
		nav.target_position = global_position

func run_defend_state(_delta):
	var enemy = get_closet_enemy()
	if is_instance_valid(enemy) && !is_instance_of(enemy, Cauldron):
		if enemy_cauldron.hostile_state == Global.ATTACK:
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
		if !is_attacking && targeted_enemy.global_position.distance_to(global_position) < 40:
			nav.target_position = global_position
			is_attacking = true
			var rand = randf_range(0.3, 1.0)
			$AttackTimer.start(rand)
			
		if is_attacking:
			nav.target_position = global_position
	else:
		nav.target_position = defense_position
		
		if nav.is_navigation_finished():
			if attack_direction > 0:
				$Sprite2D.flip_h = false
			elif attack_direction < 0:
				$Sprite2D.flip_h = true

func fire_projectile():
	var proj = slash.instantiate() as Slash
	proj.set_target($ProjectileSpawn.global_position, targeted_enemy, self)
	get_node("/root/Main").add_child(proj)

func _on_attack_timer_timeout():
	if !is_instance_valid(self) || !is_instance_valid(targeted_enemy):
		return
	
	if is_dead:
		return
	
	$AnimationPlayer.play("attack")
