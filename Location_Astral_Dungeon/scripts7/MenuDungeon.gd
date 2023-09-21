extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	if GlobalData.continue_game == true:
#		$Music.stream_paused = false
#	else:
	$Music.play()			
	$Monstr.text = "LIVE MONSTER:" + str(GlobalData.count_enemy)	
	$EliteMonstr.text = "LIVE ELITE:" + str(GlobalData.count_enemy0)	
	$SOULS.text = "SOULS:" + str(GlobalData.dead_enemy)
	$BOSS.text = "BOSS:" + str(GlobalData.count_boss)			
	$Level.text = "YOUR LEVEL:" + str(GlobalData.player_level)	
func _on_Quit_pressed():
	get_tree().quit()

#Normal Mode
func _on_Play_pressed():
	GlobalData.hard_mode = false	
	$Music.stream_paused = true
	GlobalData.continue_game = true			
	get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/Main.tscn")

#Hard Mode
func _on_Button_pressed():
	GlobalData.hard_mode = true	
	load_dungeon()
func load_dungeon():		
	$Music.stream_paused = true	
	GlobalData.continue_game = true	
	get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/Main.tscn")


func _on_Button_QUIT_pressed():
	get_tree().quit()
