extends Node
class_name Mineable

@export var data : Item
@export var hits : int
@export var hits_till_resource : int

var hits_taken = 0

func _ready():
	add_to_group("resource")
	$Control/TextureProgressBar.max_value = hits
	$Control/TextureProgressBar.value = hits

func on_hit(team : String):
	hits -= 1
	hits_taken += 1
	
	if hits_taken % hits_till_resource == 0:
		Global.team[team][data.id] += 1
		get_node("/root/Main/HUD").update_items()
	
	$Control/TextureProgressBar.value = hits
	$CPUParticles2D.emitting = true
	
	if hits == 0:
		Global.team[team][data.id] += 1
		get_node("/root/Main/HUD").update_items()
		queue_free()
