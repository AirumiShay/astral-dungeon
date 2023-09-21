extends Node2D
var speed = 5
var attack = 100
var bullet : PackedScene
var enemy_attack : PackedScene
onready var hp = 1000
export var max_hp = 1000
var SpellTime = 1
var player_vol = Vector2(1,1)
var old_player_pos
var spell = true # можно активировать мощное закляниние
var spell_count = 2
var	dead = false
var heal_hp = 3
var damage = 100

func start(pos, dir):
#	rotation = dir
	position = pos
func _ready():
	var timelife = GlobalData.player_level
	if timelife > 50:
		timelife = 50
	$DieTimer.start(timelife)	
	damage = GlobalData.player_level * 15
	old_player_pos = global_position

	update_hp()
	add_to_group(GlobalData.entity_group)
	bullet = ResourceLoader.load("res://Location_Astral_Dungeon/spells7/bullet2.tscn")
	enemy_attack = ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/DamageArea.tscn")		

func shoot(): 
	if dead == false:
		spell = true

func spawn():
	pass
	
func enemyContact(enemyHitbox): 

	var scene_id = enemyHitbox # получаем id сцены

	if dead == false:
		if scene_id.has_method("reduce_hp"):

			scene_id.reduce_hp(damage)


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

func Spell_Action():
	var bull = bullet.instance()
	bull.dir = rotation
	bull.rotation = rotation
	bull.global_position = global_position
	get_parent().add_child(bull)
	$Level.text = str(GlobalData.player_level)
	$EnemyCount.text = str(GlobalData.dead_enemy)

func _on_Spell_Timer_timeout():
	if dead == false:	
		Spell_Action()

func _on_DieTimer_timeout():
	die()
	get_parent().remove_child(self)
	queue_free()
