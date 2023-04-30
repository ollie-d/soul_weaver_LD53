extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const level_1 = preload("res://Scenes/Levels/BaseLevel.tscn")


func change_level():
	globals.current_layer = 1
	get_parent().add_child(level_1.instance())
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Skip.z_index = 100
	
	$Audio.play()
	$Timer.wait_time = 0.3
	$Timer.start()
	yield($Timer, "timeout")
	$Line1.visible = true
	
	$Timer.wait_time = 1.5
	$Timer.start()
	yield($Timer, "timeout")
	$Line2.visible = true
	
	$Timer.wait_time = 3.8
	$Timer.start()
	yield($Timer, "timeout")
	$Line3.visible = true
	
	$Timer.wait_time = 4
	$Timer.start()
	yield($Timer, "timeout")
	$Soul.visible = true
	$Skip_Label.visible = true
	
	$Timer.wait_time = 5.7
	$Timer.start()
	yield($Timer, "timeout")
	$Line1.visible = false
	$Line2.visible = false
	$Line3.visible = false
	$Soul.visible = false
	
	$Timer.wait_time = 1
	$Timer.start()
	yield($Timer, "timeout")
	$Line4.visible = true
	
	$Timer.wait_time = 2
	$Timer.start()
	yield($Timer, "timeout")
	$Line5.visible = true
	
	$Timer.wait_time = 4
	$Timer.start()
	yield($Timer, "timeout")
	$Line6.visible = true
	
	$Timer.wait_time = 2.3
	$Timer.start()
	yield($Timer, "timeout")
	$Line7.visible = true
	
	$Timer.wait_time = 4
	$Timer.start()
	yield($Timer, "timeout")
	$Line4.visible = false
	$Line5.visible = false
	$Line6.visible = false
	$Line7.visible = false
	
	$Timer.wait_time = 3.5
	$Timer.start()
	yield($Timer, "timeout")
	$Level.visible = true
	$Win.visible = true
	$Lose.visible = true
	
	$Timer.wait_time = 20
	$Timer.start()
	yield($Timer, "timeout")
	$Win.visible = false
	$Lose.visible = false
	$Level.visible = false
	$Level/RotateTimer.stop()
	
	$Timer.wait_time = 4
	$Timer.start()
	yield($Timer, "timeout")
	$Layers.visible = true
	$Layers/Name1.visible = false
	$Layers/Name2.visible = false
	$Layers/Name3.visible = false
	$Layers/Name4.visible = false
	$Layers/Name5.visible = false
	
	$Timer.wait_time = 5.5
	$Timer.start()
	yield($Timer, "timeout")
	$Layers/Name1.visible = true
	
	$Timer.wait_time = 10
	$Timer.start()
	yield($Timer, "timeout")
	$Layers.visible = false
	
	$Timer.wait_time = 4
	$Timer.start()
	yield($Timer, "timeout")
	$Audio.stop()
	global_music.play_music()
	change_level()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Skip_pressed():
	$Audio.stop()
	$Timer.paused = true
	global_music.play_music()
	change_level()
	
