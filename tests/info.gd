extends Spatial

var mouse_cell_pos: Vector2 setget set_mouse_pos;

var start_pos = null
var end_pos = null
var lastPoints = []
var curPoints = []

func _ready():
	$"/root/in_game_state".connect("state_changed", self, "_on_state_changed")
	$"/root/in_game_jobs".connect("job_added", self, "_on_job_added");
	$"/root/in_game_jobs".connect("job_removed", self, "_on_job_added");

func _on_state_changed(newState):
	$mouse_preview.visible = newState == StateNames.BUILD_TUNNEL

func _on_job_added(newJob):
	if newJob.get_job_name() == JobNames.BUILD_TUNNEL:
		var jobs = $"/root/in_game_jobs".get_copy_of_all_jobs();
		var positions = []
		for j in jobs:
			if j.get_job_name() == JobNames.BUILD_TUNNEL:
				positions.append(j.position);
		generate_ui_mesh(positions);
	else:
		print("ERROR")

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
		# prevent diagonal
		generate_mesh()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) && !start_pos && x % 2 == 0 && y % 2 == 0:
		#print("HERE ", pos)
		$mouse_draw_preview.visible = true;
		start_pos = pos
	elif !Input.is_mouse_button_pressed(BUTTON_LEFT) && start_pos:
		#print("COMPLETE:", start_pos, end_pos)
		lastPoints = curPoints.duplicate(true);
		curPoints = [];
		start_pos = null;
		end_pos = null;
		print(lastPoints)
		$mouse_draw_preview.visible = false;

func get_last_points() -> Array:
	return _filter_mineable(lastPoints.duplicate(true));

func _filter_mineable(points: Array) -> Array:
	var newArr = [];
	for p in points:
		if get_parent().is_mineable(p.x, p.y):
			newArr.append(p);
	return newArr;

func get_color(x, y):
	print(Vector2(x,y), " is_mineable: ",get_parent().is_mineable(x, y))
	if get_parent().is_mineable(x, y):# || get_parent()._is_fog(x, y):
		return Color(1, 0, 0)
	return Color(0, 0, 0)

func generate_mesh():
	print("Update info mesh")
	curPoints = [];
	
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var _test = start_pos - end_pos
	if abs(_test.x) > abs(_test.y):
		_test.y = 0;
	else:
		_test.x = 0;
	
	var size = _test.length()
	
	if _test.x != 0 && _test.y == 0:
		print("X")
		for s in range(size + 1):
			if _test.x < 0:
				_plane(st, start_pos.x + s, start_pos.y)
				curPoints.append(start_pos + Vector2(s, 0))
			else:
				_plane(st, start_pos.x -s, start_pos.y)
				curPoints.append(start_pos + Vector2(-s, 0))
	elif _test.y != 0 && _test.x == 0:
		print("Y")
		for s in range(size + 1):
			if _test.y < 0:
				_plane(st, start_pos.x, start_pos.y + s)
				curPoints.append(start_pos + Vector2(0, s))
			else:
				_plane(st, start_pos.x, start_pos.y -s)
				curPoints.append(start_pos + Vector2(0, -s))
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	var mesh: ArrayMesh = st.commit();
	mesh.surface_set_material(0, $mouse_preview.get_surface_material(0));
	
	$mouse_draw_preview.mesh = mesh;
	#$mouse_draw_preview.transform.origin = Vector3(start_pos.x * 2, start_pos.y * 2, 0)
	
	print(_test, size)

func generate_ui_mesh(positions: Array):
	print("Generate new UI mesh", positions)
	
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for p in positions:
		print(p)
		_plane(st, p.x, p.y);
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	var mesh: ArrayMesh = st.commit();
	mesh.surface_set_material(0, $mouse_preview.get_surface_material(0));
	
	$MeshInstance3.mesh = mesh;

func _plane(st: SurfaceTool, posX = 0, posY = 0):
	var xOffset = posX;
	var yOffset = posY;
	var z = 0;
	print(posX, " ", posY)
	st.add_color(get_color(posX, posY));
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










