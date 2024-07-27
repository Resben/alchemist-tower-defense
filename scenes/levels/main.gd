extends Node2D

var CAMERA_SPEED = 10
var HALF_WIDTH = 320

@export var player : Node2D
@export var cpu : Node2D

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		if $Camera2D.limit_left + HALF_WIDTH < $Camera2D.global_position.x:
			$Camera2D.global_position.x -= CAMERA_SPEED
	if Input.is_action_pressed("right"):
		if $Camera2D.limit_right - HALF_WIDTH > $Camera2D.global_position.x:
			$Camera2D.global_position.x += CAMERA_SPEED

func on_attack():
	if Global.player_state == Global.ATTACK:
		return
	
	Global.player_state = Global.ATTACK
	
	get_tree().call_group("player", "update_state", Global.player_state)

func on_defend():
	if Global.player_state == Global.DEFEND:
		return
	
	Global.player_state = Global.DEFEND
	get_tree().call_group("player", "update_state", Global.player_state)
	
	player.set_defense_positions()
