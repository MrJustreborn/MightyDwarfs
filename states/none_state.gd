extends AbstractState

func _init(_ctrl) -> void:
	ctrl = _ctrl;
	name = "None"

func setup_state() -> void:
	.setup_state()

func teardown_state() -> void:
	.teardown_state()

func dwarf_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, dwarf: Dwarf):
	#print(camera, "\t", event, "\t", click_position, "\n\t", click_normal, "\t", shape_idx, "\t", dwarf)
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.button_mask == 0:
			dwarf.add_to_group(GroupNames.SELECTED_DWARFS);
			ctrl.request_new_state(StateNames.SELECT_DWARF);

func map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar):
	#print(camera, "\t", event, "\t", position, "\n\t", normal, "\t", shape_idx, "\t", chunk, "\t", navigation)
	pass