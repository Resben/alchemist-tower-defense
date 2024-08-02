extends Passive
class_name Miner

func _ready():
	super._ready()
	
	stats = {
		"hp" : 5,
		"max_hp" : 5,
		"damage" : 1,
		"speed" : 50,
		"has_range" : false,
		"effects" : {}
	}

func _physics_process(delta):
	super._physics_process(delta)
	
	if friendly_cauldron.passive_state == Global.RETREAT:
		nav.target_position = spawn_pos
	else:
		var next_mineable = get_closet_minable()
		if next_mineable != null:
			nav.target_position = next_mineable.global_position
			targeted_enemy = next_mineable
		
		if is_instance_valid(targeted_enemy):
			if global_position.distance_to(targeted_enemy.global_position) < 30:
				$AnimationPlayer.play("mine")
