extends KinematicBody2D

var	walk = true
var attack = 2
var	dead = false
onready var hp = 20
export var max_hp = 20
var speed = 1
var undead = true
func _ready():
	GlobalData.count_enemy += 1
	
	update_hp() 
	add_to_group(GlobalData.enemy_group)	
	position = get_parent().get_node("Player").position + Vector2(1000, 0).rotated(rand_range(0, 2*PI))
	attack = attack * int(rand_range(1, 8))
	speed = speed * int(rand_range(1, 8))
	hp = hp * int(rand_range(1, 8))	
	$Attack.text = str(attack)	
func _physics_process(delta): 
	if walk == true:
#		get_parent().remove_child(self)
#		queue_free()

		move_and_slide((get_parent().get_node("Player").position - position).normalized() * speed / delta)#$AnimatedSprite.speed_scale / delta)

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
func increase_hp(val):
	self.hp = min(self.hp + val, self.max_hp)
	update_hp()

func die():	
	dead = true
	$AnimationPlayer.play("Death")
	GlobalData.count_enemy -= 1
	GlobalData.dead_enemy += 1
	if GlobalData.dead_enemy > 10:
		GlobalData.player_level = int(GlobalData.dead_enemy/10)
		if GlobalData.player_level > 49:
			get_parent().add_child(load("res://Location_Astral_Dungeon/scenes7/Enemy0.tscn").instance())


func _on_Area2D_area_entered(area):
		walk = false
		$AnimatedSprite2.visible = false
		$AnimatedSprite.visible = true
		if  area.is_in_group("trap_group"):
			return		

		if  area.is_in_group("ENTITY"):
			area.reduce_hp(attack)	


		if  area.is_in_group("enemy_group"):

			var scene_id = area # получаем id сцены
			var old_enemy = GlobalData.dead_enemy
			scene_id.reduce_hp(attack)
			if GlobalData.dead_enemy > old_enemy:
				increase_hp(int(attack/2))

func _on_Attack_Timer_timeout():
	undead = true


func _on_Area2D_area_exited(_area):
		walk = true 
		$AnimatedSprite.visible = false
		$AnimatedSprite2.visible = true
