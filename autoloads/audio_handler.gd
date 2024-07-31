extends Node2D

var fight_volume = -20

func _ready():
	$FightingBGM.volume_db = fight_volume

func _on_timer_timeout():
	fight_volume += 1
	$FightingBGM.volume_db = fight_volume
	print(fight_volume)
	$Timer.start()

func start_game():
	$Timer2.start()

func _on_timer_2_timeout():
	$Timer.start()

func _on_main_bgm_finished():
	$MainBGM.play()

func _on_fighting_bgm_finished():
	$FightingBGM.play()
