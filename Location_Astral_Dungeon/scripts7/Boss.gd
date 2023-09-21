extends KinematicBody2D

onready var magic_scene =  ResourceLoader.load("res://Location_Astral_Dungeon/scenes7/bullet3.tscn") 
var attack = 100
var	dead = false
onready var hp = 20000
export var max_hp = 20000
var speed = 1
var undead = true
func _ready():
	GlobalData.count_enemy0 += 1
	$Attack_Timer.start(4)		
	update_hp() 
	add_to_group(GlobalData.enemy_group)
#	var player = get_parent().get_node("Player") 
#	var player_position= player.position 		
#	position = player_position + Vector2(1000, 0).rotated(rand_range(0, 2*PI))
	attack = attack * int(rand_range(1, 5))
	speed = speed * int(rand_range(1, 5))
	hp = hp * int(rand_range(1, 5))
	$HP_bar.value = hp
	$HP_bar.max_value = hp	
	max_hp = hp	
	$Attack.text = str(attack)	
#func _physics_process(delta): 

#	move_and_slide((get_parent().get_node("Player").position - position).normalized() * speed / delta)#$AnimatedSprite.speed_scale / delta)

func reduce_hp(val):
#	if	undead != true:
		self.hp -= val

		update_hp()
		if self.hp <= 0:
			die()
			get_parent().remove_child(self)
			queue_free()
		
			return attack
		return 0
func update_hp():
	$HP.text = str(hp)
	$HP_bar.value = hp
func increase_hp(val):
	self.hp = min(self.hp + val, self.max_hp)
	update_hp()
	
func die():	
	dead = true
	GlobalData.count_boss += 1
#	GlobalData.dead_enemy += 1
	if GlobalData.dead_enemy > 10:
		GlobalData.player_level += attack 
		GlobalData.dead_enemy += 10*attack		




func _on_Area2D_area_entered(area):
#			$AnimatedSprite.visible = false
#			$AnimatedSprite2.visible = true	
			var scene_id = area # получаем id сцены

			if scene_id == GlobalData.main_player_id:
				scene_id.reduce_hp(attack)
			elif scene_id != self:
				scene_id.reduce_hp(attack)
#				increase_hp(int(attack))	   	


func _on_Attack_Timer_timeout():
	undead = true
#	$AnimatedSprite2.visible = false
#	$AnimatedSprite.visible = true
	Spell_Action()	
func Spell_Action():
	var bull = magic_scene.instance()
#	bull.dir = rotation
	bull.rotation = rotation
	bull.global_position = global_position
	bull.start(attack) 
	get_parent().add_child(bull)
#	add_child(bull)	
func Spell_Action2():
	var bull = magic_scene.instance()
#	bull.dir = rotation
#	bull.rotation = rotation
	bull.global_position = get_parent().get_node("Player").position 
	get_parent().add_child(bull)
