tool
extends Node2D

signal rotated(undo)

var rotated_tex = preload("res://Assets/Sprites/new_hex_rotated.png")
var normal_tex = preload("res://Assets/Sprites/new_hex_normal.png")

export var path_30  := true setget disable_enable_30
export var path_90  := true setget disable_enable_90
export var path_150 := true setget disable_enable_150
export var path_210 := true setget disable_enable_210
export var path_270 := true setget disable_enable_270
export var path_330 := true setget disable_enable_330

export(String, "Neutral", "Player", "Enemy", "Start", "Enemy_End", "Player_End") var tile_type = "Neutral" setget change_tile_type

export(int, "0", "1", "2", "3", "4", "5", "6", "7", "8") var layer = 0 setget change_layer

export var astar_weight := 1.0 setget set_astar_weight

export var can_rotate := true setget set_rotate

var is_connected := false # if any paths connect to hexes this is set to true
var is_tile_on := false
var tile_name = ""
var optimal_tile := false

# Use this to track undos
var last_rotations = [""]

# Called when the node enters the scene tree for the first time.
func _ready():
	if can_rotate == false:
		$Arrow_Left.disabled = true
		$Arrow_Right.disabled = true


func clear_rotations():
	last_rotations = [""]
	$Hex.set_texture(normal_tex)


func set_astar_weight(weight):
	astar_weight = weight


func change_layer(layer_):
	layer = layer_


func change_tile_type(type):
	tile_type = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delt1a):
	if optimal_tile:
		pass
		#$Hex.modulate = Color(1, 1, 1)
	else:
		if is_tile_on:
			pass
			#$Hex.modulate = Color(0.6, 0.6, 0.6)
		else:
			pass
			#$Hex.modulate = Color(0.2, 0.2, 0.2)
	
	for path in $Hex.get_children():
		var areas = path.get_child(0).get_child(0).get_overlapping_areas()
		if len(areas) > 0:
			for area in path.get_child(0).get_child(0).get_overlapping_areas():
				if "Path" in str(area.get_parent()):
					is_connected = true
					if path.state != "optimal":
						path.state = "connected"
		else:
			if "Path" in path.get_name():
				if not Engine.is_editor_hint():
					path.state = "unconnected"
					is_connected = false
					
	# Disable rotation on 6-path hexes
	if not Engine.is_editor_hint():
		if globals.turn == "Player":
			if path_30 and path_90 and path_150 and path_210 and path_270 and path_330:
				can_rotate = false
				$Arrow_Left.disabled = true
				$Arrow_Right.disabled = true
			else:
				can_rotate = true
				$Arrow_Left.disabled = false
				$Arrow_Right.disabled = false
		elif globals.turn == "Enemy":
			can_rotate = false
			$Arrow_Left.disabled = true
			$Arrow_Right.disabled = true


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


func set_rotate(status):
	can_rotate = status


func turn_on():
	is_tile_on = true
	for child in $Hex.get_children():
		child.parent_hex_on = true


func turn_off():
	is_tile_on = false
	for child in $Hex.get_children():
		child.parent_hex_on = false


func rotate_left(append):
	if globals.current_layer > 0:
		$Sound.play()
	$Hex.rotation_degrees -= 60
	if append:
		last_rotations.append("left")
	# If has been rotated, outline with shader
	if len(last_rotations) > 1:
		$Hex.set_texture(rotated_tex)
	elif len(last_rotations) == 1:
		$Hex.set_texture(normal_tex)


func _on_Arrow_Left_pressed():
	var undo = false
	if last_rotations[-1] == "right":
		undo = true
		last_rotations.pop_back()
	if globals.player_rotations_remaining > 0 or undo:
		emit_signal("rotated", undo)
		rotate_left(!undo)


func rotate_right(append):
	if globals.current_layer > 0:
		$Sound.play()
	$Hex.rotation_degrees += 60
	if append:
		last_rotations.append("right")
	# If has been rotated, outline with shader
	if len(last_rotations) > 1:
		$Hex.set_texture(rotated_tex)
	elif len(last_rotations) == 1:
		$Hex.set_texture(normal_tex)


func _on_Arrow_Right_pressed():
	var undo = false
	if last_rotations[-1] == "left":
		undo = true
		last_rotations.pop_back()
	if globals.player_rotations_remaining > 0 or undo:
		emit_signal("rotated", undo)
		rotate_right(!undo)
	
