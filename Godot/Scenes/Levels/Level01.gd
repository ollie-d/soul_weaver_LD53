extends Node2D


onready var enemy_name := "Harold"
onready var max_enemy_rotations := 1
onready var max_player_rotations := 3
onready var enemy_rotations_remaining = max_enemy_rotations
onready var player_rotations_remaining = max_player_rotations
onready var turn := "Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $Board.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.connect("rotated", self, "track_rotations")


func track_rotations(undo):
	var value = -1
	if undo:
		value = 1
	if turn == "Player":
		player_rotations_remaining += value
		var text = "Rotations left\n{curr}/{max}"
		$PlayerRotations.text =  text.format({"curr":player_rotations_remaining, "max": max_player_rotations})
	elif turn == "Enemy":
		enemy_rotations_remaining += value
		
	# After rotation, execute path finding after a brief delay
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$Board.path_find()
