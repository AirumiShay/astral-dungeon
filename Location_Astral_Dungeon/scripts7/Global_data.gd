extends Node

onready var entity_group = "ENTITY" #not using now
onready var enemy_group = "enemy_group"
onready var trap_group = "trap_group"
onready var damage_group = "damage_group"
var main_player_id
var player_level = 1 
var dead_enemy = 0
var player_attack = 1
var player_attack2 = 1
var dead_player = false
var count_enemy = 0
var count_enemy0 = 0
var count_boss = 0
var continue_game = false
var hard_mode = false
