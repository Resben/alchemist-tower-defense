extends Entity
class_name Hostile

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	nav.avoidance_layers = 1
	nav.avoidance_mask = 1

func _physics_process(delta):
	if is_dead:
		return
	super._physics_process(delta)
	
	if !is_attacking:
		if nav.is_navigation_finished():
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("run")
	
	var state = friendly_cauldron.hostile_state
	var last_state = friendly_cauldron.last_hostile_state
	
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	run_state(delta, state)

func setup():
	await get_tree().physics_frame
	
	if friendly_cauldron.hostile_state == Global.DEFEND:
		nav.target_position = defense_position
	else:
		targeted_enemy = get_closet_enemy()
		nav.target_position = targeted_enemy.global_position

func get_closet_enemy() -> Node2D:
	if !is_instance_valid(enemy_cauldron):
		return
	
	var closet : Node2D = enemy_cauldron
	var length = global_position.distance_to(enemy_cauldron.global_position)
	for e in enemy_cauldron.hostile_references:
		if is_instance_valid(e):
			var next_length = global_position.distance_to(e.global_position)
			if next_length < length:
				length = next_length
				closet = e
	for p in enemy_cauldron.passive_reference:
		if is_instance_valid(p):
			var next_length = global_position.distance_to(p.global_position)
			if next_length < length:
				length = next_length
				closet = p
	
	return closet

func exit_state(state):
	match state:
		Global.ATTACK:
			exit_attack_state()
		Global.DEFEND:
			exit_defend_state()

func enter_state(state):
	match state:
		Global.ATTACK:
			enter_attack_state()
		Global.DEFEND:
			enter_defend_state()

func run_state(delta, state):
	match state:
		Global.ATTACK:
			run_attack_state(delta)
		Global.DEFEND:
			run_defend_state(delta)

func enter_attack_state():
	pass

func exit_attack_state():
	pass

func run_attack_state(_delta):
	pass

## DEFEND

func enter_defend_state():
	nav.target_position = defense_position

func exit_defend_state():
	pass

func run_defend_state(_delta):
	pass
