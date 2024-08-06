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
	pass # Replace with function body.

func _ready():
	match has_condition:
		"win":
			$Control/Win.visible = true
			$Control/Loss.visible = false
		"lost":
			$Control/Win.visible = false
			$Control/Loss.visible = true
		"none":
			$Control/Win.visible = false
			$Control/Loss.visible = false
