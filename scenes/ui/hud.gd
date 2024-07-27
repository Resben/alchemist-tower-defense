extends CanvasLayer

var attack_active : Texture2D = preload("res://assets/ui/sword.png")
var attack_inactive : Texture2D = preload("res://assets/ui/sword_inactive.png")
var defense_active : Texture2D = preload("res://assets/ui/shield-active.png")
var defense_inactive : Texture2D = preload("res://assets/ui/shield-inactive.png")

func _ready():
	$Control/HBoxContainer2/Attack.texture_normal = attack_inactive
	$Control/HBoxContainer2/Defend.texture_normal = defense_active
	update_items()

func _on_attack_pressed():
	$Control/HBoxContainer2/Attack.texture_normal = attack_active
	$Control/HBoxContainer2/Defend.texture_normal = defense_inactive
	get_parent().on_attack()

func _on_defend_pressed():
	$Control/HBoxContainer2/Attack.texture_normal = attack_inactive
	$Control/HBoxContainer2/Defend.texture_normal = defense_active
	get_parent().on_defend()

func update_items():
	$Control/HBoxContainer/Material.set_count(Global.team["player"]["raw_material"])
	$Control/HBoxContainer/Soul.set_count(Global.team["player"]["soul"])
	$Control/HBoxContainer/Rune.set_count(Global.team["player"]["rune"])
	$Control/HBoxContainer/Phantom.set_count(Global.team["player"]["phantom_weave"])
	$Control/HBoxContainer/Bloodvine.set_count(Global.team["player"]["bloodvine"])
	$Control/HBoxContainer/Wyrm.set_count(Global.team["player"]["wyrm_bone"])
