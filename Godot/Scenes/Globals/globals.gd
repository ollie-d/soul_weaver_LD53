extends Node

onready var enemy_name := "Harold"
onready var max_enemy_rotations := 1
onready var max_player_rotations := 3
onready var enemy_rotations_remaining = max_enemy_rotations
onready var player_rotations_remaining = max_player_rotations
onready var turn := "Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.