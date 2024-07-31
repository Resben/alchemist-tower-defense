extends Sprite2D

signal _on_shadow_drop

@export var team : String

var spot_one = false
var spot_two = false
var spot_three = false

func _ready():
	$Animated.visible = false

func _on_button_pressed():
	if $AnimationPlayer.is_playing():
		return
	
	if !spot_one:
		$AnimationPlayer.play("one")
		get_node("/root/Main/HUD").update_items()
	elif !spot_two:
		$AnimationPlayer.play("two")
		get_node("/root/Main/HUD").update_items()
	elif !spot_three:
		$AnimationPlayer.play("three")
		get_node("/root/Main/HUD").update_items()

func _physics_process(delta):
	if Global.team[team]["soul"] < 1:
		$Control/TextureButton.disabled = true
	else:
		$Control/TextureButton.disabled = false

func _on_animation_player_finished(anim_name):
	match anim_name:
		"one":
			Global.team[team]["soul"] -= 1
			$Bay/B1.set_moveable()
			spot_one = true
		"two":
			Global.team[team]["soul"] -= 1
			$Bay/B2.set_moveable()
			spot_two = true
		"three":
			Global.team[team]["soul"] -= 1
			$Bay/B3.set_moveable()
			spot_three = true

func moveable_used(id):
	match id:
		"one":
			$Bay/B1.unset_moveable()
			spot_one = false
		"two":
			$Bay/B2.unset_moveable()
			spot_two = false
		"three":
			$Bay/B3.unset_moveable()
			spot_three = false

func _on_moveable_dropped(pos, id):
	_on_shadow_drop.emit(pos, id)
