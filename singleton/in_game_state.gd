class_name InGameStateController
extends Node

signal state_changed(newState)

enum STATE {
	NONE,
	SELECT,
	BUILD
}

var CURRENT_STATE = STATE.BUILD;

var STATE_NONE: AbstractState = preload("res://states/none_state.gd").new(self);
var STATE_SELECT_DWARF: AbstractState = preload("res://states/select_dwarf_state.gd").new(self);

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
			STATE.SELECT:
				state = STATE_SELECT_DWARF;
			_:
				printerr("Unknown state!")
				state.setup_state()
				return
		state.setup_state()
		CURRENT_STATE = newState;
		emit_signal("state_changed", CURRENT_STATE)
	print(newState)
	pass
