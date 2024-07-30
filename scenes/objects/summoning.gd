extends Sprite2D

@export var team : String

func _on_button_pressed():
	pass # Summon + animate to move to "med bay"

func _physics_process(delta):
	if Global.team[team]["soul"] < 1:
		$Control/TextureButton.disabled = true
	else:
		$Control/TextureButton.disabled = false
