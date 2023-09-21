extends Node2D

onready var mob_scene =  ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/Enemy.tscn") 
onready var mob_scene2 =  ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/Enemy0.tscn") 
onready var mob_scene3 =  ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/EnemyMob.tscn") 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	pass	
	$Music_game.play()
func create_mob(mob_scene):
	var mob = mob_scene.instance()
	$YSort.add_child(mob)
#	mob.connect("died",get_node("root/Main/YSort/Player"), "on_mob_death")
	mob.connect("died",self, "on_mob_death")


func _input(event):
	if event is InputEventKey and event.scancode == KEY_BACKSPACE and event.pressed:
		get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/MenuDungeon.tscn")		


func _on_SpawnMob_timeout():
	if GlobalData.count_enemy <  50:
		create_mob(mob_scene)
	if GlobalData.count_enemy0 <  15 and GlobalData.player_level > 5:
		create_mob(mob_scene2)
	if GlobalData.count_enemy0 <  50 and GlobalData.player_level > 15:
		create_mob(mob_scene3)				
func on_mob_death(mob, level):
	if level > 0:
		level = int(level/10)
		GlobalData.player_level += level
#		get_tree().change_scene("res://scenes7/MenuDungeon.tscn")	
		$ui/UI/Panel/CountMutants.text = "Collected Souls: " + str(GlobalData.count_enemy)


func _on_Button_pressed():
		$YSort/Player.dead = false	
		get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/MenuDungeon.tscn")		

