extends Node2D

var state = "unconnected"
var connected_color = Color(1, 0, 0)
var unconnected_color = Color(1, 1, 1)
var optimal_color = Color(1, 0, 1)

var parent_hex_on := false

signal turn_on

# Called when the node enters the scene tree for the first time.
func _ready():
	state = "unconnected"
	

func unconnect():
	state = "unconnected"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == "unconnected":
		pass
		#$Path.modulate = unconnected_color
	elif state == "connected":
		pass
		#$Path.modulate = connected_color
	elif state == "optimal":
		pass
		#$Path.modulate = optimal_color


func propagate():
	# Turn connected tiles on
	parent_hex_on = true
	for area in $Path/Area.get_overlapping_areas():
		if "Path" in area.get_parent().get_name():
			var path = area.get_parent().get_parent()
			if not path.parent_hex_on:
				var hex = path.get_parent()
				# Connect hexes using AStar
				var name0 = self.get_parent().get_parent().tile_name
				var name1 = hex.get_parent().tile_name
				global_astar.astar.connect_points(global_astar.astar_dict[name0],
												  global_astar.astar_dict[name1], false)
				
				for path_ in hex.get_children():
					path_.propagate()
	emit_signal("turn_on")
