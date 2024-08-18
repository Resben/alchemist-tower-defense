extends Sprite2D

signal _on_shadow_drop

@export var team : String

var num_available = 0

var value = 10
var spot_one = false
var spot_two = false
var spot_three = false

func _ready():
	$Animated.visible = false
	if team == "cpu":
		$Control/ProgressCircle.visible = false

func _physics_process(delta):
	if value >= 10:
		value = 10
	else:
		value += delta
	
	$Control/ProgressCircle.set_value(value * 10)

func _on_animation_player_finished(anim_name):
	match anim_name:
		"one":
			$Bay/B1.set_moveable()
			spot_one = true
		"two":
			$Bay/B2.set_moveable()
			spot_two = true
		"three":
			$Bay/B3.set_moveable()
			spot_three = true

func get_moveables() -> Array[String]:
	var arr : Array[String]
	
	if spot_one:
		arr.push_back("one")
	if spot_two:
		arr.push_back("two")
	if spot_three:
		arr.push_back("three")
	
	return arr

func moveable_used(id):
	match id:
		"one":
			$Bay/B1.unset_moveable()
			spot_one = false
			num_available -= 1
		"two":
			$Bay/B2.unset_moveable()
			spot_two = false
			num_available -= 1
		"three":
			$Bay/B3.unset_moveable()
			spot_three = false
			num_available -= 1

func _on_moveable_dropped(pos, id):
	_on_shadow_drop.emit(pos, id)

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if get_global_mouse_position().distance_to($Control/ProgressCircle.global_position) < 10:
			if value == 10:
				summon()

func summon():
	if $AnimationPlayer.is_playing():
		return
	
	if !spot_one:
		$AnimationPlayer.play("one")
		num_available += 1
		value = 0
	elif !spot_two:
		$AnimationPlayer.play("two")
		num_available += 1
		value = 0
	elif !spot_three:
		$AnimationPlayer.play("three")
		num_available += 1
		value = 0
