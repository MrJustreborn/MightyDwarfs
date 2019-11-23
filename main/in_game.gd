extends Node

onready var state = $"/root/in_game_state";

onready var label = $CanvasLayer/HBoxContainer/Label

func _ready():
	pass


func _process(delta):
	var dwarfs = get_tree().get_nodes_in_group(GroupNames.DWARFS)
	label.text = "Dwarfs: ";
	for d in dwarfs:
		label.text += d.name + ", ";
	label.text += "\nActive: ";
	dwarfs = get_tree().get_nodes_in_group(GroupNames.SELECTED_DWARFS)
	for d in dwarfs:
		label.text += d.name + ", ";


func _on_btn_none_pressed() -> void:
	state.request_new_state(StateNames.NONE)
	pass # Replace with function body.


func _on_btn_tunnel_pressed() -> void:
	state.request_new_state(StateNames.BUILD_TUNNEL)
	pass # Replace with function body.
