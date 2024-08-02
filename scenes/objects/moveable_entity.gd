extends TextureButton

signal _moveable_dropped

@export var id : String
@export var texture : Texture2D
var held = false
var can_be_held = false

func _ready():
	visible = false
	texture_normal = texture
	$moveable.texture = texture
	$moveable.visible = false

func set_moveable():
	visible = true
	can_be_held = true

func unset_moveable():
	visible = false
	can_be_held = false

func _on_button_down():
	if can_be_held:
		held = true
		$moveable.visible = true
		texture_normal = null

func _on_button_up():
	if can_be_held:
		held = false
		$moveable.visible = false
		_moveable_dropped.emit($moveable.global_position, id)
		texture_normal = texture

func _process(_delta):
	if held:
		$moveable.global_position = get_global_mouse_position()
