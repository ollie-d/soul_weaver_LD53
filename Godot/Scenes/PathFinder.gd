tool
extends Node2D

# Traverse all of the paths in the level by checking which areas collide.
# I believe we can accomplish this by first identifying colliding hexes,
# then traversing the colliding hexes, keeping track of where we've been.
# The keeping track is to prevent loops, which are not dissallowed.
# If multiple paths make it to an end, take the shortest path.
# In cases of ties, shortest path goes towards player.
# If there are no paths that go to the end, pick the path that goes deepest
# with least resistance. In cases of ties, move towards player.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal next_turn
signal victory
signal defeat


# Called when the node enters the scene tree for the first time.
func _ready():
	$Soul.position = $Start.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass

func path_find():
	global_astar.astar = AStar2D.new()
	global_astar.astar_dict = {}
	global_astar.astar_rev_dict = {}
	
	# Turn off all hexes first and add points to astar
	var i := 0
	for child in self.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.turn_off()
			child.optimal_tile = false
			global_astar.astar.add_point(i, child.position, child.astar_weight)
			global_astar.astar_dict[id] = i # map id to name in a dict
			global_astar.astar_rev_dict[i] = id # map reverse of name to id
			child.tile_name = id # set tile name for connecting
			i += 1
	
	# Find tile where the soul is and highlihg it
	var curr_tile = $Soul/Area.get_overlapping_areas()[0].get_parent().get_parent()
	curr_tile.is_tile_on = true
	# Set lowest point to current tile (not sure if this will fix my issue)
	global_astar.end_point = curr_tile.tile_name
	#curr_tile.modulate = Color(0.5, 0.3, 0.1)
	
	# Determine which tiles are "on" versus "off" by checking path connections
	# Note that global_astar is used to add and connect points here
	for path in curr_tile.get_child(0).get_children():
		if path.state == "connected":
			path.propagate()
			
	# Get best AStar paths
	var _path_player = global_astar.astar.get_id_path(global_astar.astar_dict[curr_tile.tile_name], global_astar.astar_dict["Player_Win"])
	var _path_enemy = global_astar.astar.get_id_path(global_astar.astar_dict[curr_tile.tile_name], global_astar.astar_dict["Enemy_Win"])
	
	# Store tile names in a path list
	var path_player = []
	for _i in _path_player:
		path_player.append(_i)
		
	var path_enemy = []
	for _i in _path_enemy:
		path_enemy.append(_i)
		
	# Check if either path goes to the end
	var path = path_player
	var player_win_connected = global_astar.astar_dict["Player_Win"] in path_player
	var enemy_win_connected = global_astar.astar_dict["Enemy_Win"] in path_enemy
	
	# Variable to tell things what kind of path we have
	var path_type = "Player"
	
	if player_win_connected and enemy_win_connected:
		# If enemy path is shorter, set path to that
		if len(path_enemy) < len(path_player):
			path = path_enemy
			path_type = "Enemy"
	elif enemy_win_connected and not player_win_connected:
		# If player win is not connected, choose enemy path if it is
		path = path_enemy
		path_type = "Enemy"
	elif len(path_enemy) + len(path_player) == 0:
		# If neither enemy nor player win connected, path to lowest point.
		# This should be done for each layer
		path_type = "Normal"
		for child in self.get_children():
			var id = child.get_name()
			if ("_" in id) or ("Start" in id):
				var connections = global_astar.astar.get_point_connections(global_astar.astar_dict[id])
				if len(connections) > 0:
					for c in connections:
						var new_id = global_astar.astar_rev_dict[c]
						if self.find_node(new_id).layer == self.find_node(global_astar.end_point).layer:
							# If layers are equal, see which path is shorter
							var start_point = global_astar.astar_dict[curr_tile.tile_name]
							var path_current = global_astar.astar.get_id_path(start_point, global_astar.astar_dict[global_astar.end_point])
							var path_new = global_astar.astar.get_id_path(start_point, global_astar.astar_dict[new_id])
							if len(path_new) < len(path_current):
								path = path_new
								global_astar.end_point = new_id
							else:
								path = path_current
						elif self.find_node(new_id).layer > self.find_node(global_astar.end_point).layer:
							# If layer is deeper, set new path
							var start_point = global_astar.astar_dict[curr_tile.tile_name]
							path = global_astar.astar.get_id_path(start_point, global_astar.astar_dict[new_id])
							global_astar.end_point = new_id
				#else:
				#	path = []
	
	for item in global_astar.astar_dict.keys():
		if len(path) > 0:
			if global_astar.astar_dict[item] in path:
				self.get_node(item).optimal_tile = true
	
	return [path, path_type]

func next_round():
	var path = path_find()[0]
	
	# Move soul to the next cell (if not trapped)
	if len(path) > 1:
		$Soul.position = get_node(global_astar.astar_dict.keys()[path[1]]).position
		
		# Check if the end cell is an end condition
		if global_astar.astar_dict.keys()[path[1]] == "Player_Win":
			# Call next level OR game win function
			print("Gz you win")
			global_astar.player_won = true
			emit_signal("victory")
		elif global_astar.astar_dict.keys()[path[1]] == "Enemy_Win":
			# Call defeat
			print("Oof, you lose")
			emit_signal("defeat")
			
	# Clear all hex's rotations
	for child in self.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.clear_rotations()


func _on_Button_pressed():
	emit_signal("next_turn")


func _on_Level_next_round():
	next_round()
