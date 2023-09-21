extends Node2D
var speed = 5
var attack = 5
var bullet : PackedScene
var enemy_attack : PackedScene
onready var hp = 200
export var max_hp = 200
var SpellTime = 1
var player_vol = Vector2(1,1)
var old_player_pos
var spell = true # можно активировать мощное закляниние
var spell_count = 3
var	dead = false
var heal_hp = 3
var Damage = 50
var Scale_Damage = Vector2(1,1)
var time_elapsed = 0

func start(pos, dir):
#	rotation = 0
	position = pos
func _ready():
#	rotation = 0	
	$DieTimer.start(GlobalData.player_level + 1)
#	spawn_enemy()	
#	$SpawnEnemyTimer.start(1)		
#	GlobalData.main_player_id = $Hurtbox #self
	old_player_pos = global_position
	$Spell_Timer.start(SpellTime)
	update_hp()
	add_to_group(GlobalData.entity_group)

	bullet = ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/DamageAreaTree.tscn")		
func _process(delta): 
	attack = GlobalData.player_level * 10
	time_elapsed += delta
	var color = Color(1,1,1,1)
	if time_elapsed >= 5:
		var darken_amount = (time_elapsed - 5)/5
		color = Color(1 - darken_amount,1 - darken_amount,1 - darken_amount, 1)
		$Sprite.modulate = color	
	return
func shoot(): 
	if dead == false:
		spell = true

func spawn():
	pass
func spawn_enemy():
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()	
	var a = load("res://Location_Astral_Dungeon/scenes7/EnemyMob.tscn").instance()	
	a.start($Puzzle.global_position, 0)
	
	var b = $'/root/Main/YSort'.add_child(a)
	return		
	if GlobalData.player_level > 4 and GlobalData.count_enemy < 150: 
		get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy.tscn").instance())
	if GlobalData.player_level > 12 and  GlobalData.count_enemy0 < 50: 
		get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy0.tscn").instance())
			
func enemyContact(enemyHitbox): 

	var scene_id = enemyHitbox # получаем id сцены

	if dead == false:
#		if  scene_id .is_in_group("enemy_group"):
			scene_id.reduce_hp(GlobalData.player_level * Damage)					

func decrease_hp(val):
	return
	self.hp -= val
	update_hp()
	if self.hp <= 0:
		die()
		return false
	return true
func update_hp():
	$HP.text = str(hp)
func increase_hp(val):
	self.hp = min(self.hp + val, self.max_hp)
	update_hp()
	
func die():	
	dead = true
#	get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")
func Spell_Action():
	var bull = bullet.instance()
	bull.global_position = global_position
	get_parent().add_child(bull)

func _on_Spell_Timer_timeout():
	Scale_Damage = Scale_Damage - .05 * Scale_Damage 	
#	if Scale_Damage  >= Vector2(0.05,0.05):	
#		Spell_Action()
#		$Sprite.scale	= Scale_Damage
#		$DamageArea.set_scale	= Scale_Damage
	Spell_Action()		



func _on_DieTimer_timeout():
	die()
	get_parent().remove_child(self)
	queue_free()


func _on_SpawnEnemyTimer_timeout():
	spawn_enemy()
