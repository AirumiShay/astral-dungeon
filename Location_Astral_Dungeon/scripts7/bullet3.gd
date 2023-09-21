extends Node2D

var damaged = false
var damage = 10
var dir = 0
var bullet_speed = 500
var attack
var hp = 35
var time_elapsed = 0
func start(dmg):
	damage = dmg
func _process(delta):
	var player = get_parent().get_node("Player") 
	var player_position= player.position 
	var fireball_position = position
	var direction = player_position - fireball_position
	direction = direction.normalized()
	var new_position = fireball_position.move_toward(player_position, bullet_speed * delta )
	position = new_position
	
	time_elapsed += delta
	var color = Color(1,1,1,1)
#	return
	if time_elapsed >= 5:
		var darken_amount = (time_elapsed - 5)/5
		color = Color(1 - darken_amount,1 - darken_amount,1 - darken_amount, 1)
		$Sprite.modulate = color
#	var move_dir = (b - global_position).normalized() * bullet_speed / delta 
#	var move_dir = Vector2(1,0).rotated(dir)
#	global_position += (move_dir * bullet_speed)
	pass


func _on_VisibilityNotifier2D_screen_exited():
	self.remove_child($Area2D)
	queue_free()



func set_damage(dmg):
#	damage = dmg


	if GlobalData.player_level < 10:
		attack = 2 + GlobalData.player_level
	if GlobalData.player_level < 15:
		attack = 5 + 2*GlobalData.player_level
	if GlobalData.player_level < 20:
		attack = 10 + 3*GlobalData.player_level
	if GlobalData.player_level < 25:
		attack = 20 + 3*GlobalData.player_level
	if GlobalData.player_level >= 30:
		attack = 50 + 4*GlobalData.player_level
	GlobalData.player_attack = attack
func _ready():
#	set_damage(10)	
	add_to_group(GlobalData.damage_group)													
	set_damage(attack)
#func _on_bullet2_area_entered(area):
func _on_Area2D_area_entered(area):		
#func enemyHit(area: Area2D):
#	if not damaged and get_overlapping_bodies() != []:
#		for i in get_overlapping_bodies():
#			if i in get_tree().get_nodes_in_group(GlobalData.enemy_group):
#				i.reduce_hp(damage)
#		damaged = true
	if area.has_method("reduce_hp"):
#		if area != GlobalData.main_player_id:
			area.reduce_hp(damage)	 
#	area.get_parent().get_node("AnimationPlayer").play("Death")
func reduce_hp(_val):
	hp -= _val
	if hp < 0:
		_on_VisibilityNotifier2D_screen_exited()	
	return 0


func _on_Timer_timeout():
		_on_VisibilityNotifier2D_screen_exited()
