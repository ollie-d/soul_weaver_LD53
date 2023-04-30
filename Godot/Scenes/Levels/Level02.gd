extends Node2D

# LEVEL 2

# Called when the node enters the scene tree for the first time.
onready var line_offset = $Line2D.position
onready var rng = RandomNumberGenerator.new()

const defeat_scene = preload("res://Scenes/Defeat.tscn")
const victory_scene = preload("res://Scenes/Victory.tscn")

signal next_round

func _ready():
	# Make sure soul is at the top
	$Board/Soul.z_index = 100
	for child in $Board.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.connect("rotated", self, "track_rotations")
	
	# Update enemy name and counters
	$EnemyName.text = globals.enemy_name
	var text = "Rotations left\n{curr}/{max}"
	$EnemyRotations.text =  text.format({"curr":globals.enemy_rotations_remaining, "max": globals.max_enemy_rotations})
	text = "Rotations left\n{curr}/{max}"
	$PlayerRotations.text =  text.format({"curr":globals.player_rotations_remaining, "max": globals.max_player_rotations})
	
	
	globals.current_round = 0
	globals.turn = "Player"
	#$Board/Button.disabled = false
	$Board/WeirdButton.disabled = false
	$PlayerName.modulate = Color(1, 1, 1)
	$PlayerRotations.modulate = Color(1, 1, 1)
	$EnemyName.modulate = Color(0.5, 0.5, 0.5)
	$EnemyRotations.modulate = Color(0.5, 0.5, 0.5)
	
	next_round()
	$Timer.start()


func _physics_process(delta):
	pass

func enemy_turn():
	if globals.turn == "Enemy":
		# This is the enemy's AI
		
		# Ta will pick a random tile and rotate it then end his turn
		for turn in range(globals.max_enemy_rotations):
			print(turn)
			var hexes = []
			for child in $Board.get_children():
				var id = child.get_name()
				if ("_" in id) and (not "_Win" in id):
					hexes.append(child)
			var hex = hexes[rng.randi_range(0, len(hexes)-1)]
			var direction = "left"
			if rng.randi_range(0, 1) == 1:
				direction = "right"
				
			# Wait some random amount of time
			$TurnTimer.wait_time = rng.randf_range(0.5, 1.5)
			$TurnTimer.start()
			yield($TurnTimer, "timeout")
			if direction == "left":
				hex.rotate_left(true)
			elif direction == "right":
				hex.rotate_right(true)
			else:
				pass # do nothing
			$Timer.start()
			
			globals.enemy_rotations_remaining -= 1
			var text = "Rotations left\n{curr}/{max}"
			$EnemyRotations.text =  text.format({"curr":globals.enemy_rotations_remaining, "max": globals.max_enemy_rotations})
		
		$TurnTimer.wait_time = 1.5
		$TurnTimer.start()
		yield($TurnTimer, "timeout")
		finish_turn()


func next_round():
	var text = "Rotations left\n{curr}/{max}"
	$EnemyRotations.text =  text.format({"curr":globals.enemy_rotations_remaining, "max": globals.max_enemy_rotations})
	$PlayerRotations.text =  text.format({"curr":globals.player_rotations_remaining, "max": globals.max_player_rotations})
	globals.current_round += 1
	if globals.current_round > globals.max_rounds:
		# Trigger defeat if victory condition isn't triggered on next propagate
		$Timer.start()
		
		if global_astar.player_won:
			victory()
		else:
			defeat()
		
	else:
		text = "Round {round}/{max}"
		$Label.text = text.format({"round":globals.current_round, "max":globals.max_rounds})
		globals.turn = "Player"
	

func finish_turn():
	# Check what player can do based on turn
	if globals.turn == "Player":
		globals.turn = "Enemy"
		#$Board/Button.disabled = true
		$Board/WeirdButton.disabled = true
		$PlayerName.modulate = Color(0.5, 0.5, 0.5)
		$PlayerRotations.modulate = Color(0.5, 0.5, 0.5)
		$EnemyName.modulate = Color(1, 1, 1)
		$EnemyRotations.modulate = Color(1, 1, 1)
		globals.player_rotations_remaining = globals.max_player_rotations
		enemy_turn()
	elif globals.turn == "Enemy":
		globals.turn = "Player"
		#$Board/Button.disabled = false
		$Board/WeirdButton.disabled = false
		$PlayerName.modulate = Color(1, 1, 1)
		$PlayerRotations.modulate = Color(1, 1, 1)
		$EnemyName.modulate = Color(0.5, 0.5, 0.5)
		$EnemyRotations.modulate = Color(0.5, 0.5, 0.5)
		globals.enemy_rotations_remaining = globals.max_enemy_rotations
		next_round()
		emit_signal("next_round")
	$Timer.start()


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
		var text = "Rotations left\n{curr}/{max}"
		$PlayerRotations.text =  text.format({"curr":globals.enemy_rotations_remaining, "max": globals.max_enemy_rotations})
		
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
		pass
		#$Line2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
	elif path_type == "Enemy":
		pass
		#$Line2D.modulate = Color(1.0, 0.0, 0.0, 0.5)
	elif path_type == "Player":
		pass
		#$Line2D.modulate = Color(0.0, 1.0, 1.0, 0.5)

	# Draw a line_2D following path
	var i = 0
	for point in path:
		$Line2D.add_point(self.find_node(global_astar.astar_rev_dict[point]).global_position - line_offset)


func _on_Board_next_turn():
	finish_turn()
	$Timer.start()


func victory():
	globals.current_layer += 1
	if globals.current_layer <= 5:
		get_parent().add_child(victory_scene.instance())
		queue_free()
	else:
		# Do something special for a full completion
		pass


func defeat():
	get_parent().add_child(defeat_scene.instance())
	queue_free()





func _on_CheckConnect_pressed():
	print("pressed")
	var point0 = global_astar.astar_dict[$Board/Node1.text]
	var point1 = global_astar.astar_dict[$Board/Node2.text]
	print(global_astar.astar.are_points_connected(point0, point1, false))


func _on_Button_pressed():
	victory()
