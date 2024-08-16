extends Node2D
class_name TutorialController

@export var hints : Array[Hint]
var current = 0

func play():
	hints[0].display_hint()

func play_next():
	current += 1
	if hints.size() > current:
		hints[current].display_hint()
