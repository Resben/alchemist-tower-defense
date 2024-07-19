extends TextureButton

signal _on_button_drop

var held = false
var startpos : Vector2
var num_mats : int = 1

@export var availble_texture : Texture2D
@export var non_available_texture : Texture2D
@export var selected_texture : Texture2D

func _ready():
	startpos = global_position
	self.texture_normal = availble_texture
	self.texture_disabled = non_available_texture
	self.texture_focused = selected_texture
	$moveable.texture = availble_texture
	$moveable.visible = false

func _on_button_down():
	if num_mats > 0:
		held = true
		$moveable.visible = true

func _process(delta):
	if held:
		$moveable.global_position = get_global_mouse_position()

func _on_button_up():
	_on_button_drop.emit($moveable.global_position, self)
	$moveable.global_position = startpos
	$moveable.visible = false
	held = false
	self_modulate = Color(1, 1, 1, 1)

func set_number(num : int):
	num_mats = num
	
	if num_mats <= 0:
		disabled = true
	else:
		disabled = false
