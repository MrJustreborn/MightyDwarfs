extends Node

signal state_changed(newState)


var CURRENT_STATE = ""#StateNames.NONE;

var STATE_NONE: AbstractState = preload("res://states/none_state.gd").new(self);
var STATE_SELECT_DWARF: AbstractState = preload("res://states/select_dwarf_state.gd").new(self);
var STATE_BUILD_TUNNEL: AbstractState = preload("res://states/build_tunnel_state.gd").new(self);

var state: AbstractState = load("res://states/abstract_state.gd").new();

func _ready():
	request_new_state(StateNames.NONE)
	pass

func _on_building_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, building: Node) -> void:
	state.building_input_event(camera, event, click_position, click_normal, shape_idx, building);

func _on_dwarf_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, dwarf: Dwarf) -> void:
	state.dwarf_input_event(camera, event, click_position, click_normal, shape_idx, dwarf)
#TODO: rename info
func _on_map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar, info: Node) -> void:
	state.map_input_event(camera, event, position, normal, shape_idx, chunk, navigation, info)

func get_job_system():
	return get_node("/root/in_game_jobs");

func request_new_state(newState):
	if CURRENT_STATE != newState:
		state.teardown_state();
		match(newState):
			StateNames.NONE:
				state = STATE_NONE;
			StateNames.SELECT_DWARF:
				state = STATE_SELECT_DWARF;
			StateNames.BUILD_TUNNEL:
				state = STATE_BUILD_TUNNEL;
			_:
				printerr("Unknown state!")
				state.setup_state()
				return
		state.setup_state()
		CURRENT_STATE = newState;
		emit_signal("state_changed", CURRENT_STATE)
	print(newState)
	pass
