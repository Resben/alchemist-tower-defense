extends Control
class_name Hint

@export_multiline var text : String
@export var camera : Camera2D
@export var associated_hints : Array[SubHint]

func _ready():
	$RichTextLabel.text = text
	visible = false

func display_hint():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", Vector2(self.global_position.x, camera.global_position.y), 2)
	tween.tween_callback(start_hint)

func start_hint():
	for sh in associated_hints:
		sh.show_subhint()
	
	visible = true
