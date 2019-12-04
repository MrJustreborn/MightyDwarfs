extends AbstractState

func _init(_ctrl) -> void:
	ctrl = _ctrl;
	name = "Build Tunnel"

func setup_state() -> void:
	.setup_state()

func teardown_state() -> void:
	.teardown_state()

var last_pts = []

func map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar, info: Node):
	if event is InputEventMouseMotion:
		if normal.z == 1:# && Input.is_mouse_button_pressed(BUTTON_LEFT):
			var x = round(position.x / 2)
			var y = round(position.y / 2)
			info.mouse_cell_pos = Vector2(x, y)
	var pts = info.get_last_points();
	if last_pts != pts:
		last_pts = pts;
		if !Input.is_mouse_button_pressed(BUTTON_LEFT) && pts && pts.size() > 0:
			print("New build tunnel jobs to add: ", pts)
			var jobs = []
			for p in pts:
				var job: AbstractJob = preload("res://jobs/build_tunnel_job.gd").new(p, navigation);
				jobs.append(job);
			
			ctrl.get_job_system().submit_jobs(jobs);
	
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT && event.button_mask == BUTTON_MASK_RIGHT:
			ctrl.request_new_state(StateNames.NONE);