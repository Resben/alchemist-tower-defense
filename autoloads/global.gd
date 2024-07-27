extends Node

enum { ATTACK, DEFEND }

var item = {
	"soul" : preload("res://resources/items/soul.tres") as Item,
	"rune" : preload("res://resources/items/rune.tres") as Item,
	"phantom_weave" : preload("res://resources/items/phantom_weave.tres") as Item,
	"bloodvine" : preload("res://resources/items/bloodvine.tres") as Item,
	"wyrm_bone" : preload("res://resources/items/wyrm_bone.tres") as Item,
	
	"raw_material" : preload("res://resources/items/raw_material.tres") as Item
}

var player_state = DEFEND

var team = {
	"player" : {
		"soul" : 1,
		"rune" : 2,
		"phantom_weave" : 3,
		"bloodvine" : 4,
		"wyrm_bone" : 5,
		"raw_material" : 6
	},

	"cpu" : {
		"soul" : 0,
		"rune" : 0,
		"phantom_weave" : 0,
		"bloodvine" : 0,
		"wyrm_bone" : 0,
		"raw_material" : 0
	}
}
