extends Node

onready var label = $CanvasLayer/HBoxContainer/Label

func _ready():
	pass


func _process(delta):
	var dwarfs = get_tree().get_nodes_in_group("DWARFS")
	label.text = "Dwarfs: ";
	for d in dwarfs:
		label.text += d.name + ", ";
	label.text += "\nActive: ";
	dwarfs = get_tree().get_nodes_in_group("ACTIVE_SELECTION")
	for d in dwarfs:
		label.text += d.name + ", ";


func _on_Button_pressed():
	get_tree().set_input_as_handled()
	print("asdfasd")
	pass # Replace with function body.
