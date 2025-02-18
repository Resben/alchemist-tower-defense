extends Passive
class_name Miner

var is_mining : bool

func _ready():
	super._ready()
	
	stats = {
		"hp" : 5,
		"max_hp" : 5,
		"damage" : 1,
		"base_speed" : 25,
		"speed" : 25,
		"has_range" : false,
		"effects" : {}
	}

func _physics_process(delta):
	if is_dead:
		return
	super._physics_process(delta)
	
	is_mining = false
	
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
				is_mining = true
	
	if !is_mining:
		if nav.is_navigation_finished():
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("run")

func _on_take_damage(_dmg : int):
	stats["speed"] = stats["speed"] * 0.5
	$SlowTick.start()

func _on_slow_tick_timeout():
	stats["speed"] = stats["base_speed"]
