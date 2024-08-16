extends Node

enum { ATTACK, DEFEND, RETREAT, MINE }

enum { EASY, NORMAL, HARD, BROKEN }

var item = {
	"soul" : preload("res://resources/items/soul.tres") as Item,
	"rune" : preload("res://resources/items/rune.tres") as Item,
	"phantom_weave" : preload("res://resources/items/phantom_weave.tres") as Item,
	"bloodvine" : preload("res://resources/items/bloodvine.tres") as Item,
	"wyrm_bone" : preload("res://resources/items/wyrm_bone.tres") as Item,
	
	"raw_material" : preload("res://resources/items/raw_material.tres") as Item
}

var recipes = {
	"soul_minion" : ["raw_material"]
}

var enemies = {
	"soul_minion" : load("res://scenes/entities/soul_minionv2.tscn"),
	"miner" : load("res://scenes/entities/miner.tscn")
}

var difficulty_presets = {
	EASY : preload("res://resources/cpu_difficulties/easy.tres") as Difficulty,
	NORMAL : preload("res://resources/cpu_difficulties/easy.tres") as Difficulty,
	HARD : preload("res://resources/cpu_difficulties/easy.tres") as Difficulty,
	BROKEN : preload("res://resources/cpu_difficulties/easy.tres") as Difficulty
}

var player_state = DEFEND

var team = {
	"player" : {
		"rune" : 2,
		"phantom_weave" : 2,
		"bloodvine" : 2,
		"wyrm_bone" : 2,
		"raw_material" : 2
	},

	"cpu" : {
		"rune" : 0,
		"phantom_weave" : 0,
		"bloodvine" : 0,
		"wyrm_bone" : 0,
		"raw_material" : 0
	}
}

var difficulty = NORMAL

func get_result(array : Array[Item]):
	var num_matches = 0
	var num_none_matches = 0
	var best_match = "soul_minion"
	var best_non_matches = 9999
	
	for r in recipes:
		for a in array:
			if recipes[r].has(a.id):
				num_matches += 1
			else:
				num_none_matches += 1
		if num_matches == recipes[r].size():
			if num_none_matches < best_non_matches:
				best_match = r
				best_non_matches = num_none_matches
				num_matches = 0
				num_none_matches = 0
	
	return best_match
