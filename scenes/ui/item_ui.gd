extends TextureRect

@export var available : Texture2D
@export var unavailable : Texture2D

func set_count(num : int):
	$Label.text = str(num)
	
	if num == 0:
		texture = unavailable
	else:
		texture = available
