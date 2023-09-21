extends Area2D

var damaged = false
var damage = 11
var target = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
#	$Timer.start(0.1)
	pass # Replace with function body.

func set_damage(dmg):
	damage = dmg

func radar_process(_delta):
	if not damaged and get_overlapping_bodies() != []:
		for i in get_overlapping_bodies():
			if i in get_tree().get_nodes_in_group(GlobalData.enemy_group):
				if i != GlobalData.main_player_id:				
					i.reduce_hp(damage)
					$Sprite.visible = true
					var target_old = target
					target = i.global_position
					if target_old != target:
						return target
#		damaged = true
	$Sprite.visible = false
	return target
func _on_Timer_timeout():
#	get_parent().remove_child(self)
#	queue_free()
	pass # Replace with function body.
func reduce_hp(val):
	return 0
