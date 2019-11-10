extends Node

signal state_changed(newState)

enum STATE {
	NONE,
	SELECT,
	BUILD
}

var CURRENT_STATE = STATE.BUILD;

var STATE_NONE: AbstractState = preload("res://states/none_state.gd").new();

var state: AbstractState = load("res://states/abstract_state.gd").new();

func _ready():
	pass

func _on_dwarf_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, dwarf: Dwarf):
	state.dwarf_input_event(camera, event, click_position, click_normal, shape_idx, dwarf)

func _on_map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar):
	state.map_input_event(camera, event, position, normal, shape_idx, chunk, navigation)

func request_new_state(newState):
	if CURRENT_STATE != newState:
		state.teardown_state();
		match(newState):
			STATE.NONE:
				state = STATE_NONE;
			_:
				printerr("Unknown state!")
		state.setup_state()
		CURRENT_STATE = newState;
	print(newState)
	pass
