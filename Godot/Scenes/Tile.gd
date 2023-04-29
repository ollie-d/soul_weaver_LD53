tool
extends Node2D

export var path_30  := true setget disable_enable_30
export var path_90  := true setget disable_enable_90
export var path_150 := true setget disable_enable_150
export var path_210 := true setget disable_enable_210
export var path_270 := true setget disable_enable_270
export var path_330 := true setget disable_enable_330


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func disable_enable(angle, b):
	var path = ("Hex/Path_%s")
	var node = get_node(path % str(angle))
	
	if b:
		node.visible = true
		node.set_process(true)
		node.set_physics_process(true)
		node.set_process_input(true)
	else:
		node.visible = false
		node.set_process(false)
		node.set_physics_process(false)
		node.set_process_input(false)
		

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
