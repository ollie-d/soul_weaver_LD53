tool
extends Node2D

export var path_30  := true setget disable_enable_30
export var path_90  := true setget disable_enable_90
export var path_150 := true setget disable_enable_150
export var path_210 := true setget disable_enable_210
export var path_270 := true setget disable_enable_270
export var path_330 := true setget disable_enable_330

export(String, "Neutral", "Player", "Enemy", "Start", "Enemy_End", "Player_End") var tile_type = "Neutral" setget change_tile_type

export(int, "0", "1", "2", "3", "4", "5", "6", "7", "8") var layer = 0 setget change_layer

export var astar_weight := 1.0 setget set_astar_weight

var is_connected := false # if any paths connect to hexes this is set to true
var is_tile_on := false
var tile_name = ""
var optimal_tile := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_astar_weight(weight):
	astar_weight = weight


func change_layer(layer_):
	layer = layer_


func change_tile_type(type):
	tile_type = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delt1a):
	if optimal_tile:
		$Hex.modulate = Color(1, 1, 1)
	else:
		if is_tile_on:
			$Hex.modulate = Color(0.6, 0.6, 0.6)
		else:
			$Hex.modulate = Color(0.2, 0.2, 0.2)
	for path in $Hex.get_children():
		for area in path.get_child(0).get_child(0).get_overlapping_areas():
			if "Path" in str(area.get_parent()):
				is_connected = true
				if path.state != "optimal":
					path.state = "connected"
			else:
				path.state = "unconnected"
				is_connected = false


func disable_enable(angle, b):
	var path = ("Hex/Path_%s")
	var node = get_node(path % str(angle))
	
	if b:
		node.visible = true
		node.set_process(true)
		node.set_physics_process(true)
		node.set_process_input(true)
		node.get_child(0).get_child(0).get_child(0).disabled = false
		node.get_child(0).set_process(true)
		node.get_child(0).set_physics_process(true)
		node.get_child(0).set_process_input(true)
	else:
		node.visible = false
		node.set_process(false)
		node.set_physics_process(false)
		node.set_process_input(false)
		node.get_child(0).get_child(0).get_child(0).disabled = true
		node.get_child(0).set_process(false)
		node.get_child(0).set_physics_process(false)
		node.get_child(0).set_process_input(false)


func disable_enable_30(b):
	path_30 = b
	disable_enable(30, b)
	
func disable_enable_90(b):
	path_90 = b
	disable_enable(90, b)
	
func disable_enable_150(b):
	path_150 = b
	disable_enable(150, b)
	
func disable_enable_210(b):
	path_210 = b
	disable_enable(210, b)
	
func disable_enable_270(b):
	path_270 = b
	disable_enable(270, b)
	
func disable_enable_330(b):
	path_330 = b
	disable_enable(330, b)


func turn_on():
	is_tile_on = true
	for child in $Hex.get_children():
		child.parent_hex_on = true


func turn_off():
	is_tile_on = false
	for child in $Hex.get_children():
		child.parent_hex_on = false
