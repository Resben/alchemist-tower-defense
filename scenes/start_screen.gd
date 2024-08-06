extends CanvasLayer

@export var MainScene : PackedScene

var has_condition = "none"

func set_as_end_screen(condition : String):
	has_condition = condition

func _on_start_button_up():
	get_parent().add_child(MainScene.instantiate())
	AudioHandler.start_game()
	queue_free()

func _on_options_button_up():
	$Control/Main.visible = false
	$Control/Options.visible = true

func _ready():
	$Control/Options.visible = false
	
	match has_condition:
		"win":
			$Control/Main/Win.visible = true
			$Control/Main/Loss.visible = false
		"lost":
			$Control/Main/Win.visible = false
			$Control/Main/Loss.visible = true
		"none":
			$Control/Main/Win.visible = false
			$Control/Main/Loss.visible = false


func _on_options_close():
	$Control/Main.visible = true
	$Control/Options.visible = false
