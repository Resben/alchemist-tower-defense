extends CanvasLayer

func _ready():
	update_items()

func _on_attack_pressed():
	get_parent().on_attack()

func _on_defend_pressed():
	get_parent().on_defend()

func update_items():
	$Control/HBoxContainer/Material.set_count(Global.team["player"]["raw_material"])
	$Control/HBoxContainer/Soul.set_count(Global.team["player"]["soul"])
	$Control/HBoxContainer/Rune.set_count(Global.team["player"]["rune"])
	$Control/HBoxContainer/Phantom.set_count(Global.team["player"]["phantom_weave"])
	$Control/HBoxContainer/Bloodvine.set_count(Global.team["player"]["bloodvine"])
	$Control/HBoxContainer/Wyrm.set_count(Global.team["player"]["wyrm_bone"])
