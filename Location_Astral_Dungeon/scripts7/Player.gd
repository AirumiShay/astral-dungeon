extends Node2D


var velocity = Vector2()
var time_enemy = 10
var speed = 5
var speed2 = 20
var attack = 1
var bullet : PackedScene
var enemy_attack : PackedScene
onready var hp = 100
export var max_hp = 100
onready var mob_scene =  ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/Enemy.tscn") 
var SpellTime = 4 # кулдаун заклинания фейерверк, зеркалный двойник и огненная стена(с коэффициентами)
var Spell1_Time = 1 #время между файерболлами
var SpawnEnemy_Time = 3
var player_vol = Vector2(1,1)
var old_player_pos
var spell = true # можно активировать мощное заклинание  и ставить тотем
var spell2 = true # можно активировать заклинание стена огня
var spell_count = 4
var	dead = false
var heal_hp = 3
func _ready():
	$Spell_Timer.start(Spell1_Time)
	GlobalData.dead_player = false	
	GlobalData.main_player_id = $Hurtbox #self
	old_player_pos = global_position
#	$Spell_Timer.start(SpellTime)
	update_hp()
	add_to_group(GlobalData.entity_group)
	bullet = ResourceLoader.load("res://Location_Astral_Dungeon/spells7/bullet2.tscn")
	enemy_attack = ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/DamageArea.tscn")	
	var Enemy_Time = SpawnEnemy_Time - int(GlobalData.player_level/2.5)
	$FireBall_Timer.start(Enemy_Time)		
func _physics_process(delta): 
	
	attack = GlobalData.player_level * 2
	if dead == false:
		position += Vector2(int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)), int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))) * speed #$AnimatedSprite.speed_scale
		look_at(get_global_mouse_position())
#		handle_movement()
func exit_process(delta): 
	if Input.is_action_pressed("ui_cancel"):
		dead = false
		get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/MenuDungeon.tscn")	
func shoot(): 
	if dead == false:
		spell = true
#	add_child(load("res://Bullet.tscn").instance())
func spawn_totem():
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()	
	var a = load("res://Location_Astral_Dungeon/scenes7/Player_Totem.tscn").instance()	
	a.start($Muzzle.global_position, rotation)
	var b = $'/root/Main/YSort'.add_child(a)
func spawn_totem2():
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()	
	var a = load("res://Location_Astral_Dungeon/scenes7/Enemy_Totem.tscn").instance()	
	a.start($Muzzle.global_position, 0)
	var b = $'/root/Main/YSort'.add_child(a)

func spawn_wall():
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()	
	var a = load("res://Location_Astral_Dungeon/scenes7/Player_Wall.tscn").instance()	
	a.start($Muzzle.global_position, rotation)
	
	var b = $'/root/Main/YSort'.add_child(a)

	a.start($Muzzle.global_position, rotation)
	
func spawn():
		pass

func enemyContact(enemyHitbox): 

	var scene_id = enemyHitbox # получаем id сцены

	if dead == false:
		if scene_id.has_method("reduce_hp"):
			var bull = enemy_attack.instance()

			get_parent().add_child(bull)
			bull.set_damage(attack)

func decrease_hp(val):

	self.hp -= val
	update_hp()
	if self.hp <= 0:
		die()
		return false
	return true
func update_hp():
	$HP.text = str(hp)
	$HP_bar.value = hp
	$HP_bar.max_value = hp		
func increase_hp(val):
	self.hp = min(self.hp + val, self.max_hp)
	update_hp()
	
func die():	
	dead = true
	GlobalData.dead_player = true
#	get_tree().reload_current_scene() #
#	$DeathAnimationPlayer.play("Death")
func Spell_Action():
	var bull = bullet.instance()
	bull.dir = rotation
	bull.rotation = rotation
	bull.global_position = global_position
	get_parent().add_child(bull)
	$Level.text = str(GlobalData.player_level)
	$EnemyCount.text = str(GlobalData.dead_enemy)

	$Atack.text = str(GlobalData.player_attack2)
func _on_Spell_Timer_timeout():
	if dead == false:	
		Spell_Action()
func _input(event):
	exit_process(0.1)	
	if dead == false:
			handle_movement()
#			if event is InputEventKey:
#				if Input.is_key_pressed(KEY_D): #is_action_pressed('ui_right'):
#					velocity.x += 1
#				if Input.is_key_pressed(KEY_A): #is_action_pressed('ui_left'):
#					velocity.x -= 1
#				if Input.is_key_pressed(KEY_S): #Input.is_action_pressed('ui_down'):
#					velocity.y += 1
#				if Input.is_key_pressed(KEY_W): #is_action_pressed('ui_up'):
#					velocity.y -= 1
#				position += velocity * speed2
			if event is InputEventKey and event.scancode == KEY_BACKSPACE and event.pressed:
				get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/MenuDungeon.tscn")		

			if event is InputEventScreenTouch:
				if event.is_pressed():
					velocity = get_local_mouse_position().normalized()
					position += velocity * speed2
				else:
					velocity = Vector2(0.0, 0.0)
					position += velocity * speed2					
			elif event is InputEventScreenDrag:
				velocity = get_local_mouse_position().normalized()
				position += velocity * speed2
						

			velocity = velocity.normalized()
																
func handle_movement():
	if Input.is_action_pressed("Spell"):
		Acion_Spell()		
	if Input.is_action_pressed("Spell1"):
		if spell == true:
			spell = false
			spawn_totem()			

			decrease_hp(10*GlobalData.player_level)
			$Spell_Timer2.start(SpellTime)
	if Input.is_action_pressed("Spell2"):
		if spell == true:
			spell = false
			spawn_totem2()			
			$Spell_Timer2.start(SpellTime)
	if Input.is_action_pressed("Spell3"):
		if spell2 == true:
			spell2 = false
			spawn_wall()
			$Spell_Timer2.start(SpellTime*5)

func Acion_Spell():		
		if spell == true:
			var lighting = add_child(load("res://Location_Astral_Dungeon/spells7/Bullet.tscn").instance())

			if GlobalData.player_level < 5:
				increase_hp(heal_hp)
			elif GlobalData.player_level < 10:
				max_hp = 150
				increase_hp(heal_hp)
			elif GlobalData.player_level < 15:
				max_hp = 220
				increase_hp(heal_hp*2)
			elif GlobalData.player_level < 20:
				max_hp = 300
				increase_hp(heal_hp*2)
			elif GlobalData.player_level < 25:
				max_hp = 450
				increase_hp(heal_hp*3)
			elif GlobalData.player_level < 30:
				max_hp = 675
				increase_hp(heal_hp*4)
			elif GlobalData.player_level < 35:
				max_hp = 950
				increase_hp(heal_hp*4)
			elif GlobalData.player_level < 40:
				max_hp = 1450
				increase_hp(heal_hp*5)
			elif GlobalData.player_level < 45:
				max_hp = 2500
				increase_hp(heal_hp*5)
			elif GlobalData.player_level < 50:
				max_hp = 3750
				increase_hp(heal_hp*6)
			else:
				max_hp = 5000
				increase_hp(heal_hp*6)
			spell_count -= 1
			if spell_count < 0:
				if GlobalData.player_level < 5:
					spell_count = 2
				elif GlobalData.player_level < 10:
					spell_count = 3
				elif GlobalData.player_level < 15:
					spell_count = 4
				elif GlobalData.player_level < 20:
					spell_count = 5
				elif GlobalData.player_level < 25:
					spell_count = 6
				elif GlobalData.player_level < 30:
					spell_count = 7
				elif GlobalData.player_level < 35:
					spell_count = 8
				else:
					spell_count = 9	
				spell = false
				$Spell_Timer2.start(SpellTime)


func _on_Spell_Timer2_timeout():
	spell2 = true


func _on_FireBall_Timer_timeout():
	spawn_enemy()
func spawn_one_enemy_mob():
	var mob = mob_scene.instance()
	get_parent().add_child(mob)
	mob.connect("died", self, "on_mob_death")
		
func spawn_enemy():	
	if spell == true: 
		if GlobalData.count_enemy < 200:
			spawn_one_enemy_mob()			
			var lvl = GlobalData.player_level

		if GlobalData.player_level > 4 and time_enemy > 0 and GlobalData.count_enemy0 < 75:
			time_enemy -= 1
			if time_enemy <=0:
				time_enemy = 10 #- (GlobalData.player_level/10)
				
				if time_enemy <=0:
					time_enemy = 1
					get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy0.tscn").instance())
	var Enemy_Time = SpawnEnemy_Time - int(GlobalData.player_level/2.5)
	if Enemy_Time <= 0.25: Enemy_Time = 0.25
	$FireBall_Timer.start(Enemy_Time)

func on_mob_death(mob, level):
	if level > 0:
		level = int(level/10)
		GlobalData.player_level += level
		get_tree().change_scene("res://Location_Astral_Dungeon/scenes7/MenuDungeon.tscn")	


func _on_Spell_pressed():
		Acion_Spell()


func _on_Spell2_pressed():
		if spell == true:
			spell = false
			spawn_totem()			
			var dmg = 10*GlobalData.player_level
			if dmg > max_hp:
				dmg = 0.8 * max_hp			
			decrease_hp(dmg)
			$Spell_Timer2.start(SpellTime)


func _on_Spell3_pressed():
		if spell == true:
			spell = false
			spawn_totem2()			
			$Spell_Timer2.start(SpellTime)
func _on_Spell4_pressed():
		if spell2 == true:
			spell2 = false
			spawn_wall()
			$Spell_Timer2.start(SpellTime*5)
