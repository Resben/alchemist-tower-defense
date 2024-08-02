extends Resource
class_name Difficulty

@export var identifier : String
@export var range_time_to_decide : Vector2
@export var should_retreat_passives : bool
@export var should_retreat_hostiles : bool

func get_id():
	match identifier:
		"easy":
			return Global.EASY
		"normal":
			return Global.NORMAL
		"hard":
			return Global.HARD
		"broken":
			return Global.BROKEN
