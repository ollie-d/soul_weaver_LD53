extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rng = RandomNumberGenerator.new()
onready var line_offset = $Line2D.position
	

func _on_RotateTimer_timeout():
	var hexes = []
	for child in $Board.get_children():
		var id = child.get_name()
		if ("_" in id) and (not "_Win" in id):
			hexes.append(child)
	var hex = hexes[rng.randi_range(0, len(hexes)-1)]
	var direction = "left"
	if rng.randi_range(0, 1) == 1:
		direction = "right"
	
	if direction == "left":
		hex.rotate_left(false)
	elif direction == "right":
		hex.rotate_right(false)
	else:
		pass # do nothing
	
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

