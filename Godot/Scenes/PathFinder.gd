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
