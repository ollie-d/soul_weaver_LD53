extends Node

onready var enemy_name := "Harold"
onready var max_enemy_rotations := 1
onready var max_player_rotations := 3
onready var enemy_rotations_remaining = max_enemy_rotations
onready var player_rotations_remaining = max_player_rotations
onready var turn := "Player"
onready var max_rounds := 30
onready var current_round := 1
onready var current_layer := 0
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


func update_vars():
	if current_layer == 1:
		enemy_name = "Harold"
		max_enemy_rotations = 1
		enemy_rotations_remaining = max_enemy_rotations
		current_round = 1
	elif current_layer == 2:
		enemy_name = "Ta"
		max_enemy_rotations = 2
		enemy_rotations_remaining = max_enemy_rotations
		current_round = 1
	elif current_layer == 3:
		enemy_name = "Orlox"
		max_enemy_rotations = 2
		enemy_rotations_remaining = max_enemy_rotations
		current_round = 1
	elif current_layer == 4:
		enemy_name = "Wevja"
		max_enemy_rotations = 3
		enemy_rotations_remaining = max_enemy_rotations
		current_round = 1
	elif current_layer == 5:
		enemy_name = "Q'oz"
		max_enemy_rotations = 3
		enemy_rotations_remaining = max_enemy_rotations
		current_round = 1
		
