extends TextureButton

class_name Moveable

signal _on_button_drop

var held = false
var startpos : Vector2

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
		

func _process(delta):
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

func reduce_number():
	Global.team[cauldron.team][data.id] = Global.team[cauldron.team][data.id] - 1
	update_button()

func add_number():
	Global.team[cauldron.team][data.id] = Global.team[cauldron.team][data.id] + 1
	update_button()

func set_number(num : int):
	Global.team[cauldron.team][data.id] = num
	update_button()

func update_button():
	get_node("/root/Main/HUD").update_items()
	$Label.text = str(Global.team[cauldron.team][data.id])
	
	if Global.team[cauldron.team][data.id] <= 0:
		disabled = true
	else:
		disabled = false
