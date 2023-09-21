extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(GlobalData.entity_group)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func reduce_hp(val):
	get_parent().decrease_hp(val)
