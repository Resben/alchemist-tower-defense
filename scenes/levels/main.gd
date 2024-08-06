extends Node2D

var CAMERA_SPEED = 10
var HALF_WIDTH = 320

@onready var navRegion : NavigationRegion2D = $NavigationRegion2D

@export var player : Node2D
@export var cpu : Node2D

func _physics_process(_delta):
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
	player.update_hostile_state(Global.ATTACK)

func on_defend():
	if Global.player_state == Global.DEFEND:
		return
	
	Global.player_state = Global.DEFEND
	player.update_hostile_state(Global.DEFEND)
	player.set_defense_positions()

func on_mine():
	player.update_passive_state(Global.MINE)

func off_mine():
	player.update_passive_state(Global.RETREAT)

func force_update():
	player.force_update_items()
	$HUD.update_items()

func end_game():
	queue_free()
