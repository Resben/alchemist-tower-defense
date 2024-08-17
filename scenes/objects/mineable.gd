extends Node
class_name Mineable

@export var data : Item
@export var hits : int
@export var hits_till_resource : int

var starting_hits
var hits_taken = 0
var is_collectable = true

func _ready():
	starting_hits = hits
	add_to_group("resource")
	$Control/TextureProgressBar.max_value = hits
	$Control/TextureProgressBar.value = hits

func on_hit(team : String):
	hits -= 1
	hits_taken += 1
	
	if hits_taken % hits_till_resource == 0:
		Global.team[team][data.id] += 1
		get_node("/root/Main").force_update()
	
	$Control/TextureProgressBar.value = hits
	$CPUParticles2D.emitting = true
	
	if hits == 0:
		Global.team[team][data.id] += 1
		get_node("/root/Main").force_update()
		is_collectable = false
		self.visible = false
		#$Sprite2D.texture = mined_texture
		$RespawnTimer.start()

func _on_respawn_timeout():
	is_collectable = true
	self.visible = true
	hits_taken = 0
	hits = starting_hits
	$Control/TextureProgressBar.value = hits
	
