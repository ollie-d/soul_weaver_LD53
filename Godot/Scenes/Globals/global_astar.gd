extends Node

onready var astar = AStar2D.new()
var astar_dict = {}
var astar_rev_dict = {}
var end_point = "Start"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
