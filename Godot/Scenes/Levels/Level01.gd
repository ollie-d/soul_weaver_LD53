extends Node2D

# Called when the node enters the scene tree for the first time.
onready var line_offset = $Line2D.position#Vector2(-104, -50)
onready var rng = RandomNumberGenerator.new()

signal next_round

func _ready():
	# Make sure soul is at the top
	$Board/Soul.z_index = 100
	for child in $Board.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.connect("rotated", self, "track_rotations")
	
	globals.current_round = 0
	globals.turn = "Player"
	$Board/Button.disabled = false
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
		
		# Harold will pick a random tile and rotate it then end his turn
		for turn in range(globals.max_enemy_rotations):
			print(turn)
			var hexes = []
			for child in $Board.get_children():
				var id = child.get_name()
				if ("_" in id) and (not "_Win" in id):
					hexes.append(child)
			var hex = hexes[rng.randi_range(0, len(hexes))]
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
	text = "Round {round}/{max}"
	$Label.text = text.format({"round":globals.current_round, "max":globals.max_rounds})
	globals.turn = "Player"
	

func finish_turn():
	# Check what player can do based on turn
	if globals.turn == "Player":
		globals.turn = "Enemy"
		$Board/Button.disabled = true
		$PlayerName.modulate = Color(0.5, 0.5, 0.5)
		$PlayerRotations.modulate = Color(0.5, 0.5, 0.5)
		$EnemyName.modulate = Color(1, 1, 1)
		$EnemyRotations.modulate = Color(1, 1, 1)
		globals.player_rotations_remaining = globals.max_player_rotations
		enemy_turn()
	elif globals.turn == "Enemy":
		globals.turn = "Player"
		$Board/Button.disabled = false
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
