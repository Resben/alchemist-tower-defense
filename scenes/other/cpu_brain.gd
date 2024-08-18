extends Node
class_name CPU

@export var data : Difficulty
var cauldron : Cauldron

var team
var num_collectors = 0
var enemy_might = 0
var cpu_might = 0
	
func _ready():
	team = cauldron.team
	var rand_next_decision = randf_range(data.range_time_to_decide.x, data.range_time_to_decide.y)
	$DecisionTimer.start(rand_next_decision)
	cauldron._summoning.summon()

func setup(controllable : Cauldron, difficulty : Difficulty = Global.difficulty_presets[Global.NORMAL]):
	cauldron = controllable
	data = difficulty

func set_difficulty(diff : Difficulty):
	data = diff

##################### CPU SPAWN LOGIC #####################

func _on_decision_timeout():
	num_collectors = cauldron.passive_reference.size()
	enemy_might = cauldron.enemy_cauldron.hostile_references.size()
	cpu_might = cauldron.hostile_references.size()
	
	if rule_one():
		print("")
		pass
	elif rule_two():
		print("")
		pass
	elif rule_three():
		print("")
		pass
	elif rule_four():
		print("")
		pass
	elif rule_five():
		print("")
		pass
	
	var rand_next_decision = randf_range(data.range_time_to_decide.x, data.range_time_to_decide.y)
	$DecisionTimer.start(rand_next_decision)

## RULE 1
# If the computer has less than two collectors then try summon another
func rule_one() -> bool:
	if num_collectors < 2:
		if cauldron._summoning.num_available >= 1:
			cauldron._toolrack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), cauldron._summoning.get_moveables()[0])
			return true
	return false

## RULE 2
# If the computer has 2 more military might than the player then attack
func rule_two() -> bool:
	if cpu_might > enemy_might + 2 && cauldron.hostile_state != Global.ATTACK:
		cauldron.update_hostile_state(Global.ATTACK)
		return true
	return false

## RULE 3
# If the computer has more 2 more military might than the number of collectors then get another collector
func rule_three() -> bool:
	if num_collectors >= 2 && num_collectors < 4:
		if cauldron._summoning.num_available >= 1 && cpu_might + 1 > num_collectors:
			cauldron._toolrack._on_summoning_toolrack_shadow_drop(Vector2(-999, -999), cauldron._summoning.get_moveables()[0])
			return true
	return false

## RULE 4
# If the player is defending and the collectors have ventured too far then the computer will attack
func rule_four() -> bool:
	if cauldron.enemy_cauldron.hostile_state == Global.DEFEND:
		for miner in cauldron.enemy_cauldron.passive_reference:
			if is_instance_valid(miner):
				if miner.global_position.distance_to(cauldron.enemy_cauldron.global_position) > 1000:
					cauldron.update_hostile_state(Global.ATTACK)
					return true
	return false

## RULE 5
# If nothing else then the computer will spawn an enemy
# TODO What enemy should they prioritise??
func rule_five() -> bool:
	if Global.team[team]["raw_material"] >= 1 && cauldron.is_entity_caged: 
		cauldron.ingredients_added.push_back(Global.item["raw_material"])
		cauldron._on_accept_pressed()
		return true
	return false


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

func _on_spawn_timer_timeout():
	if cauldron._summoning.num_available < 3:
		cauldron._summoning.summon()
	if !cauldron.is_entity_caged && cauldron._summoning.num_available >= 1 && num_collectors >= 2:
		cauldron._on_summoning_shadow_drop(Vector2(-999, -999), cauldron._summoning.get_moveables()[0])
	
	$SpawnTimer.start()
