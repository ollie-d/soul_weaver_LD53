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

# Called when the node enters the scene tree for the first time.
func _ready():
	$Soul.position = $Start.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass


func _on_Button_pressed():
	global_astar.astar = AStar2D.new()
	global_astar.astar_dict = {}
	# Turn off all hexes first and add points to astar
	var i := 0
	for child in self.get_children():
		var id = child.get_name()
		if ("_" in id) or ("Start" in id):
			child.turn_off()
			child.optimal_tile = false
			global_astar.astar.add_point(i, child.position, child.astar_weight)
			global_astar.astar_dict[id] = i # map id to name in a dict
			child.tile_name = id # set tile name for connecting
			i += 1
	
	# Find tile where the soul is and highlihg it
	var curr_tile = $Soul/Area.get_overlapping_areas()[0].get_parent().get_parent()
	curr_tile.is_tile_on = true
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
	print("Player path goes  to win:" + str(global_astar.astar_dict["Player_Win"] in path_player))
	print("Enemy path goes  to win:" + str(global_astar.astar_dict["Enemy_Win"] in path_enemy))
	
	var path = path_player
	var player_win_connected = global_astar.astar_dict["Player_Win"] in path_player
	var enemy_win_connected = global_astar.astar_dict["Enemy_Win"] in path_enemy
	
	if player_win_connected and enemy_win_connected:
		# If enemy path is shorter, set path to that
		if len(path_enemy) < len(path_player):
			path = path_enemy
	elif enemy_win_connected and not player_win_connected:
		# If player win is not connected, choose enemy path if it is
		path = path_enemy
	else:
		# If neither goes to the end, choose the shortest path
		if len(path_enemy) < len(path_player):
			path = path_enemy
	
	for item in global_astar.astar_dict.keys():
		if global_astar.astar_dict[item] in path:
			self.get_node(item).optimal_tile = true
	
	pass # Replace with function body.
