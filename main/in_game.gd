extends Node

onready var state = $"/root/in_game_state";

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


func _on_btn_none_pressed() -> void:
	state.request_new_state(state.STATE.NONE)
	pass # Replace with function body.


func _on_btn_tunnel_pressed() -> void:
	state.request_new_state(state.STATE.BUILD)
	pass # Replace with function body.
