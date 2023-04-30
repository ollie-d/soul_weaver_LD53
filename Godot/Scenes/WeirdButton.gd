extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var disabled := false setget on_disabled


func on_disabled(b):
	disabled = b
	if disabled:
		$Button.disabled = true
		self.set_process(false)
		self.set_physics_process(false)
		self.set_process_input(false)
		self.get_child(0).set_process(false)
		self.get_child(0).set_physics_process(false)
		self.get_child(0).set_process_input(false)
	else:
		$Button.disabled = false
		self.set_process(true)
		self.set_physics_process(true)
		self.set_process_input(true)
		self.get_child(0).set_process(true)
		self.get_child(0).set_physics_process(true)
		self.get_child(0).set_process_input(true)
