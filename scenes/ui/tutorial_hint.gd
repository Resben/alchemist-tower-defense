extends Control
class_name Hint

@export_multiline var text : String
@export var camera : Camera2D
@export var associated_hints : Array[SubHint]
@export var controller : TutorialController
@export var is_last : bool

func _ready():
	$RichTextLabel.text = text
	visible = false

func display_hint():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", Vector2(self.global_position.x, camera.global_position.y), 1)
	tween.tween_callback(start_hint)

func start_hint():
	if is_last:
		return
	
	for sh in associated_hints:
		sh.show_subhint()
	
	visible = true

func _on_button_up():
	controller.play_next()
	visible = false
