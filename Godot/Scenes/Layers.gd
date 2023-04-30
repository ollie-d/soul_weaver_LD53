extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active_color = Color(1, 0, 0)
var alive_color = Color(0.3, 0, 0)
var line_color = Color(0.67, 0, 0)
var dead_color = Color(0.5, 0.5, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if globals.current_layer == 1:
		$Layer1.modulate = active_color
		$Layer2.modulate = alive_color
		$Layer3.modulate = alive_color
		$Layer4.modulate = alive_color
		$Layer5.modulate = alive_color
		
		$Line1.modulate = line_color
		$Line2.modulate = line_color
		$Line3.modulate = line_color
		$Line4.modulate = line_color
	if globals.current_layer == 2:
		$Layer1.modulate = dead_color
		$Layer2.modulate = active_color
		$Layer3.modulate = alive_color
		$Layer4.modulate = alive_color
		$Layer5.modulate = alive_color
		
		$Line1.modulate = dead_color
		$Line2.modulate = line_color
		$Line3.modulate = line_color
		$Line4.modulate = line_color
	if globals.current_layer == 3:
		$Layer1.modulate = dead_color
		$Layer2.modulate = dead_color
		$Layer3.modulate = active_color
		$Layer4.modulate = alive_color
		$Layer5.modulate = alive_color
		
		$Line1.modulate = dead_color
		$Line2.modulate = dead_color
		$Line3.modulate = line_color
		$Line4.modulate = line_color
	if globals.current_layer == 4:
		$Layer1.modulate = dead_color
		$Layer2.modulate = dead_color
		$Layer3.modulate = dead_color
		$Layer4.modulate = active_color
		$Layer5.modulate = alive_color
		
		$Line1.modulate = dead_color
		$Line2.modulate = dead_color
		$Line3.modulate = dead_color
		$Line4.modulate = line_color
	if globals.current_layer == 5:
		$Layer1.modulate = dead_color
		$Layer2.modulate = dead_color
		$Layer3.modulate = dead_color
		$Layer4.modulate = dead_color
		$Layer5.modulate = active_color
		
		$Line1.modulate = dead_color
		$Line2.modulate = dead_color
		$Line3.modulate = dead_color
		$Line4.modulate = dead_color
