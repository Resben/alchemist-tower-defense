extends Node

enum { ATTACK, DEFEND, RETREAT, MINE }

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
		"soul" : 2,
		"rune" : 0,
		"phantom_weave" : 0,
		"bloodvine" : 0,
		"wyrm_bone" : 0,
		"raw_material" : 0
	},

	"cpu" : {
		"soul" : 2,
		"rune" : 0,
		"phantom_weave" : 0,
		"bloodvine" : 0,
		"wyrm_bone" : 0,
		"raw_material" : 0
	}
}
