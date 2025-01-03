extends CanvasLayer

@export var MainScene : PackedScene

var has_condition = "none"
var difficulty_selected = Global.NORMAL

func set_as_end_screen(condition : String):
	has_condition = condition

func _on_start_button_up():
	$Control/Main/Start.visible = false
	$Control/Main/NoTutorial.visible = true
	$Control/Main/Tutorial.visible = true

func _on_options_button_up():
	$Control/Main.visible = false
	$Control/Options.visible = true

func _ready():
	get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	$Control/Options.visible = false
	$Control/Main/Start.visible = true
	$Control/Main/NoTutorial.visible = false
	$Control/Main/Tutorial.visible = false
	
	$Control/Main/OptionButton.select(1)
	
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

func _on_tutorial_button_up():
	var main = MainScene.instantiate()
	main.is_tutorial = true
	main.difficulty = difficulty_selected
	get_parent().add_child(main)
	AudioHandler.start_game()
	queue_free()

func _on_no_tutorial_button_up():
	var main = MainScene.instantiate()
	main.is_tutorial = false
	main.difficulty = difficulty_selected
	get_parent().add_child(main)
	AudioHandler.start_game()
	queue_free()

func _on_option_button_item_selected(index):
	match index:
		0:
			difficulty_selected = Global.EASY
		1:
			difficulty_selected = Global.NORMAL
		2:
			difficulty_selected = Global.HARD
