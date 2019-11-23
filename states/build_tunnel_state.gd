extends AbstractState

func _init(_ctrl) -> void:
	ctrl = _ctrl;
	name = "None"

func setup_state() -> void:
	.setup_state()

func teardown_state() -> void:
	.teardown_state()

func map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar, info: Node):
	if event is InputEventMouseMotion:
		if normal.z == 1:# && Input.is_mouse_button_pressed(BUTTON_LEFT):
			var x = round(position.x / 2)
			var y = round(position.y / 2)
			info.mouse_cell_pos = Vector2(x, y)
	pass