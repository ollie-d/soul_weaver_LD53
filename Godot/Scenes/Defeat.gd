extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	globals.update_vars()
	var level
	if globals.current_layer == 1:
		 level = load("res://Scenes/Levels/BaseLevel.tscn")
	elif globals.current_layer == 2:
		level = load("res://Scenes/Levels/Level02.tscn")
	elif globals.current_layer == 3:
		level = load("res://Scenes/Levels/Level03.tscn")
	elif globals.current_layer == 4:
		level = load("res://Scenes/Levels/Level04.tscn")
	elif globals.current_layer == 5:
		level = load("res://Scenes/Levels/Level05.tscn")
	get_parent().add_child(level.instance())
	queue_free()
	
