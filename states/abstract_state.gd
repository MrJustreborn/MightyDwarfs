class_name AbstractState

var name = "Abstract"
var ctrl: Node;

func setup_state() -> void:
	print("setup state ... ", name)

func teardown_state() -> void:
	print("teardown state ... ", name)

func building_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, building: Node) -> void:
	print("Nothing todo")
	#assert(false)

func dwarf_input_event(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int, dwarf: Dwarf) -> void:
	print("Nothing todo")
	#assert(false)

func map_input_event(camera: Camera, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, chunk: Vector2, navigation: AStar, meshMapCtrl: Node, info: Node) -> void:
	print("Nothing todo")
	#assert(false)