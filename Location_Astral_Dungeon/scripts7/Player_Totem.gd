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
var damage = 1000
func start(pos, dir):
#	rotation = dir
	position = pos
func _ready():
	$DieTimer.start(100)
	$SpawnEnemyTimer.start(1)		
#	GlobalData.main_player_id = $Hurtbox #self
	old_player_pos = global_position
#	$Spell_Timer.start(SpellTime)
	update_hp()
	add_to_group(GlobalData.entity_group)
	add_to_group(GlobalData.trap_group)	
	bullet = ResourceLoader.load("res://Location_Astral_Dungeon/spells7/bullet2.tscn")
	enemy_attack = ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/DamageArea.tscn")		
func _process(delta): 
	attack = GlobalData.player_level * 10
	if dead == false and GlobalData.player_level > 6:
		position += Vector2(int(Input.is_key_pressed(KEY_A)) - int(Input.is_key_pressed(KEY_D)), int(Input.is_key_pressed(KEY_W)) - int(Input.is_key_pressed(KEY_S))) * speed #$AnimatedSprite.speed_scale
		look_at(get_global_mouse_position())
	if dead == false and GlobalData.player_level > 3:
		handle_movement()
func shoot(): 
	if dead == false:
		spell = true
#	add_child(load("res://spells7/bullet2.tscn").instance())
func spawn():
	pass
func spawn_enemy():	
	if GlobalData.player_level > 4 and GlobalData.count_enemy < 150: 
		get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy.tscn").instance())
	if GlobalData.player_level > 12 and  GlobalData.count_enemy0 < 50: 
		get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy0.tscn").instance())		
func enemyContact(enemyHitbox): 

		var scene_id = enemyHitbox # получаем id сцены

		if dead == false and scene_id.is_in_group("enemy_group"):

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
#	get_tree().reload_current_scene() #$DeathAnimationPlayer.play("Death")
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
	
func handle_movement():
	if Input.is_action_pressed("Spell"):
		if spell == true:
			add_child(load("res://Location_Astral_Dungeon/spells7/Bullet.tscn").instance())

			spell = false
			$Spell_Timer.start(SpellTime*2)




func _on_DieTimer_timeout():
	die()
	get_parent().remove_child(self)
	queue_free()


func _on_SpawnEnemyTimer_timeout():
	spawn_enemy()
