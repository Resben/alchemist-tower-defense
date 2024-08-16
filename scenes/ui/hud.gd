extends CanvasLayer

var mine_active : Texture2D = preload("res://assets/ui/miner_button_active.png")
var mine_inactive : Texture2D = preload("res://assets/ui/miner_button_inactive.png")
var attack_active : Texture2D = preload("res://assets/ui/sword.png")
var attack_inactive : Texture2D = preload("res://assets/ui/sword_inactive.png")
var defense_active : Texture2D = preload("res://assets/ui/shield-active.png")
var defense_inactive : Texture2D = preload("res://assets/ui/shield-inactive.png")

var is_mine_active = true

func _ready():
	$Options.visible = false
	$Control/HBoxContainer2/Mine.texture_normal = mine_active
	$Control/HBoxContainer2/Attack.texture_normal = attack_inactive
	$Control/HBoxContainer2/Defend.texture_normal = defense_active

func _on_attack_pressed():
	$Control/HBoxContainer2/Attack.texture_normal = attack_active
	$Control/HBoxContainer2/Defend.texture_normal = defense_inactive
	get_parent().on_attack()

func _on_defend_pressed():
	$Control/HBoxContainer2/Attack.texture_normal = attack_inactive
	$Control/HBoxContainer2/Defend.texture_normal = defense_active
	get_parent().on_defend()

func _on_mine_pressed():
	is_mine_active = !is_mine_active
	
	if is_mine_active:
		$Control/HBoxContainer2/Mine.texture_normal = mine_active
		get_parent().on_mine()
	else:
		$Control/HBoxContainer2/Mine.texture_normal = mine_inactive
		get_parent().off_mine()

func _on_settings_pressed():
	$Control.visible = false
	get_tree().paused = true
	$Options.visible = true

func _on_options_on_close():
	$Control.visible = true
	get_tree().paused = false
	$Options.visible = false
