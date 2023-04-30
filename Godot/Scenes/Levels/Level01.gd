extends Node2D

# Called when the node enters the scene tree for the first time.
var line_offset = Vector2(-104, -50)

func _ready():
	for child in $Board.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.connect("rotated", self, "track_rotations")


func track_rotations(undo):
	var value = -1
	if undo:
		value = 1
	if globals.turn == "Player":
		globals.player_rotations_remaining += value
		var text = "Rotations left\n{curr}/{max}"
		$PlayerRotations.text =  text.format({"curr":globals.player_rotations_remaining, "max": globals.max_player_rotations})
	elif globals.turn == "Enemy":
		globals.enemy_rotations_remaining += value
		
	# After rotation, execute path finding after a brief delay
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var temp = $Board.path_find()
	var path = temp[0]
	var path_type = temp[1]
	$Line2D.clear_points()
	
	if path_type == "Normal":
		$Line2D.modulate = Color(1.0, 1.0, 0.0)
	elif path_type == "Enemy":
		$Line2D.modulate = Color(1.0, 0.0, 1.0)
	elif path_type == "Player":
		$Line2D.modulate = Color(0.0, 0.0, 1.0)

	# Draw a line_2D following path
	for point in path:
		$Line2D.add_point(self.find_node(global_astar.astar_rev_dict[point]).global_position + line_offset)
