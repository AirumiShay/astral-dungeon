extends Area2D



func _ready():
	pass 

func reduce_hp(val):
	get_parent().reduce_hp(val)
