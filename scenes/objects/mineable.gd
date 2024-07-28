extends Node
class_name Mineable

@export var data : Item
@export var hits : int

func _ready():
	add_to_group("resource")
	$Control/TextureProgressBar.max_value = hits

func on_hit(team : String):
	hits -= 1
	
	$Control/TextureProgressBar.value = hits
	
	if hits == 0:
		Global.team[team][data.id] += 1
		queue_free()
