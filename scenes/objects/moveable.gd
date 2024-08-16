extends TextureButton

class_name Moveable

signal _on_button_drop

var held = false
var startpos : Vector2
var force_disable = false

@export var cauldron : Cauldron
@export var data : Item
@export var availble_texture : Texture2D
@export var non_available_texture : Texture2D
@export var selected_texture : Texture2D

func _ready():
	if Global.team[cauldron.team][data.id] <= 0:
		disabled = true
	
	$Label.text = str(Global.team[cauldron.team][data.id])
	
	startpos = global_position
	self.texture_normal = availble_texture
	self.texture_disabled = non_available_texture
	$moveable.texture = availble_texture
	$moveable.visible = false

func _on_button_down():
	if Global.team[cauldron.team][data.id] > 0:
		held = true
		$moveable.visible = true
		self.texture_normal = selected_texture

func _process(_delta):
	if held:
		$moveable.global_position = get_global_mouse_position()

func _on_button_up():
	_on_button_drop.emit($moveable.global_position, self)
	$moveable.global_position = startpos
	$moveable.visible = false
	held = false
	self_modulate = Color(1, 1, 1, 1)
	self.texture_normal = availble_texture

func toggle_disable(boo : bool):
	disabled = boo
	force_disable = boo

func update_button():
	$Label.text = str(Global.team[cauldron.team][data.id])
	
	if Global.team[cauldron.team][data.id] <= 0:
		disabled = true
	else:
		if !force_disable:
			disabled = false
