extends Spatial

var mouse_cell_pos: Vector2 setget set_mouse_pos;

var start_pos = null
var end_pos = null
var lastPoints = []
var curPoints = []

func _ready():
	$"/root/in_game_state".connect("state_changed", self, "_on_state_changed")

func _on_state_changed(newState):
	$mouse_preview.visible = newState == StateNames.BUILD_TUNNEL

func set_mouse_pos(pos: Vector2):
	if $"/root/in_game_state".CURRENT_STATE != StateNames.BUILD_TUNNEL:
		return
	mouse_cell_pos = pos;
	var x = int(pos.x)
	var y = int(pos.y)
	
	if x % 2 == 0 && y % 2 == 0 && !start_pos:
		$mouse_preview.translation.x = pos.x * 2;
		$mouse_preview.translation.y = pos.y * 2;
#		$MeshInstance.get_surface_material(0).set_shader_param("blue_tint", get_color(x, y))
	elif start_pos:#elif x % 2 == 0 && y % 2 == 0 && (start_pos.x == x || start_pos.y == y):
		$mouse_preview.translation.x = pos.x * 2;
		$mouse_preview.translation.y = pos.y * 2;
#		$MeshInstance.get_surface_material(0).set_shader_param("blue_tint", get_color(x, y))
	if start_pos && end_pos != pos:
		end_pos = pos;
		curPoints.append(Vector2(x, y))
		generate_mesh()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) && !start_pos:
		#print("HERE ", pos)
		start_pos = pos
	elif !Input.is_mouse_button_pressed(BUTTON_LEFT) && start_pos:
		#print("COMPLETE:", start_pos, end_pos)
		lastPoints = curPoints.duplicate(true);
		curPoints = [];
		start_pos = null;
		end_pos = null;
		print(lastPoints)

func get_last_points() -> Array:
	return lastPoints.duplicate(true);

func get_color(x, y):
	if get_parent()._is_wall(x, y):
		return Color(0, 1, 0)
	return Color(1, 0, 0)

func generate_mesh():
	print("Update info mesh")
	
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var _test = start_pos - end_pos
	var size = _test.length()
	
	if _test.x != 0 && _test.y == 0:
		print("X")
		for s in range(size + 1):
			if _test.x < 0:
				_plane(st, s)
			else:
				_plane(st, -s)
	elif _test.y != 0 && _test.x == 0:
		print("Y")
		for s in range(size + 1):
			if _test.y < 0:
				_plane(st, 0, s)
			else:
				_plane(st, 0, -s)
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	var mesh: ArrayMesh = st.commit();
	mesh.surface_set_material(0, $mouse_preview.get_surface_material(0));
	
	$MeshInstance2.mesh = mesh;
	$MeshInstance2.transform.origin = Vector3(start_pos.x * 2, start_pos.y * 2, 0)
	
	print(_test, size)


func _plane(st, posX = 0, posY = 0):
	var xOffset = posX;
	var yOffset = posY;
	var z = 0;
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
	
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
	
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
	
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
	
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
	
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))










