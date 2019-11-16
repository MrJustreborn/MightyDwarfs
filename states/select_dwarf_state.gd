extends AbstractState

func _init(_ctrl) -> void:
	ctrl = _ctrl;
	name = "SelectDwarfs"

func setup_state() -> void:
	.setup_state()

func teardown_state() -> void:
	.teardown_state()
	#ctrl.get_tree().call_group(GroupNames.SELECTED_DWARFS, "_remove_active");
	ctrl.get_tree().call_group(GroupNames.SELECTED_DWARFS, "remove_from_group", GroupNames.SELECTED_DWARFS);

func dwarf_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, dwarf: Dwarf):
	#print(camera, "\t", event, "\t", click_position, "\n\t", click_normal, "\t", shape_idx, "\t", dwarf)
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.button_mask == 0:
			if Input.is_key_pressed(KEY_SHIFT):
				dwarf.add_to_group(GroupNames.SELECTED_DWARFS);
			else:
				ctrl.get_tree().call_group(GroupNames.SELECTED_DWARFS, "remove_from_group", GroupNames.SELECTED_DWARFS);
				dwarf.add_to_group(GroupNames.SELECTED_DWARFS);

func map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar):
	#print(camera, "\t", event, "\t", position, "\n\t", normal, "\t", shape_idx, "\t", chunk, "\t", navigation)
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.button_mask == 0:
			var dwarfs = ctrl.get_tree().get_nodes_in_group(GroupNames.SELECTED_DWARFS)
			for d in dwarfs:
				var job: AbstractJob = preload("res://jobs/walk_job.gd").new(navigation, position);
				job.personal = true;
				job.owner = d;
				ctrl.get_job_system().submit_jobs([job], job.owner);
			ctrl.request_new_state(StateNames.NONE);