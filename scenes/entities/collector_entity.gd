extends Entity
class_name Passive

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	super._physics_process(delta)
	
	var state = friendly_cauldron.passive_state
	var last_state = friendly_cauldron.last_passive_state
	
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	run_state(delta, state)

func setup():
	await get_tree().physics_frame
	
	if friendly_cauldron.passive_state == Global.RETREAT:
		nav.target_position = defense_position
	else:
		targeted_enemy = get_closet_minable()
		nav.target_position = targeted_enemy.global_position

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

func exit_state(state):
	match state:
		Global.MINE:
			exit_mine_state()
		Global.RETREAT:
			exit_retreat_state()

func enter_state(state):
	match state:
		Global.MINE:
			enter_mine_state()
		Global.RETREAT:
			enter_retreat_state()

func run_state(delta, state):
	match state:
		Global.MINE:
			run_mine_state(delta)
		Global.RETREAT:
			run_retreat_state(delta)

func enter_mine_state():
	pass

func exit_mine_state():
	pass

func run_mine_state(delta):
	pass

## DEFEND

func enter_retreat_state():
	nav.target_position = defense_position

func exit_retreat_state():
	pass

func run_retreat_state(delta):
	pass
