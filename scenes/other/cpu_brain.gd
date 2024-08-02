extends Node
class_name CPU

@export var data : Difficulty
var cauldron : Cauldron

func _ready():
	var rand_next_decision = randi_range(data.range_time_to_decide.x, data.range_time_to_decide.y)
	$DecisionTimer.start(rand_next_decision)

func setup(controllable : Cauldron, difficulty : Difficulty = Global.difficulty_presets[Global.NORMAL]):
	cauldron = controllable
	data = difficulty

func set_difficulty(diff : Difficulty):
	data = diff

##################### CPU SPAWN LOGIC #####################

	## RULE 1
	# First check how many collectors we have
	# CPU will try to always have 3 at once
	# CPU must have at least 1 collector
	# For every collector there is at least 1 enemy
	
	## RULE 2
	# If CPU has significant resources they will get 2 more collectors
	
	## RULE 3
	# CPU will spawn any random enemy if rule 2 and 1 are maxed out or not met
	
	## RULE 4
	# If player is defending and has collectors far away from defense 
	# CPU has a 50% chance of attacking on timeout
	
	## RULE 5
	# If CPU has greater numbers CPU will attack if non of the other conditions are met

func _on_decision_timeout():
	
	var rule_one = false
	var rule_two = false
	var rule_three = false
	var rule_four = false
	var rule_five = false
	
	var team = cauldron.team
	var num_collectors = cauldron.passive_reference.size()
	var enemy_might = cauldron.enemy_cauldron.hostile_references.size()
	var cpu_might = cauldron.hostile_references.size()
	
	if num_collectors < 2:
		if Global.team[team]["soul"] >= 1:
			rule_one = true
	
	if num_collectors >= 2 && num_collectors < 4:
		if Global.team[team]["soul"] >= 3 && cpu_might > num_collectors:
			rule_two = true
	
	if !rule_one && !rule_two:
		if Global.team[team]["raw_material"] >= 1: 
			rule_three = true
	
	if cauldron.enemy_cauldron.hostile_state == Global.DEFEND:
		for miner in cauldron.enemy_cauldron.passive_reference:
			if is_instance_valid(miner):
				if miner.global_position.distance_to(cauldron.enemy_cauldron.global_position) > 1000:
					rule_four = true
	
	if cpu_might > enemy_might && cauldron.hostile_state != Global.ATTACK:
		rule_five = true
	
	if rule_one:
		cauldron._toolrack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), "na")
		Global.team[team]["soul"] -= 1
		#print("enemy summoned a miner")
	elif rule_five:
		cauldron.update_hostile_state(Global.ATTACK)
		#print("enemy went on the offensive")
	elif rule_two:
		cauldron._toolrack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), "na")
		Global.team[team]["soul"] -= 1
		#print("enemy summoned a extra miner")
	elif rule_three:
		cauldron.spawn_entity("soul_minion")
		Global.team[cauldron.team]["raw_material"] -= 1
		#print("enemy summoned a combatant")
	elif rule_four:
		var rand = randi_range(1, 100)
		if rand < 51:
			cauldron.update_hostile_state(Global.ATTACK)
			#print("enemy noticed you are mining too far in")
	
	var rand_next_decision = randi_range(data.range_time_to_decide.x, data.range_time_to_decide.y)
	$DecisionTimer.start(rand_next_decision)


##################### CPU BASIC LOGIC #####################

## Rule 1
# If CPU has less than 3 collectors they will retreat instantly if an enemy gets close
# Requires a signal
# Cauldron should update miner

## Rule 2
# Else they will retreat if one of them dies
# CPU will retaliate with an attack
# Requires a signal

## Rule 3
# CPU will only send collectors if it is safe to do so
