extends Spatial

onready var chunks = $Chunks;
onready var chunks_cave = $Chunks/cave;
onready var chunks_fog = $Chunks/fog;
onready var chunks_fps = $Chunks/firstPerson;

# [visbile, depth, type]
# dark=0
# vis=1
# fog=2
var terrain = []

var terrain_next_frame;

var navigation: AStar = AStar.new();

var dirty_chunks = []
var check_chunks = []
var first_flag = true;
var discovered_flag = false;
func update(x, y, radius_fog = 5, radius_hidden = 2, newDepth = 1):
	# Make everything with fog
	if first_flag:
		first_flag = false;
		terrain_next_frame = terrain.duplicate(true);
		for y in range(terrain_next_frame.size()):
			for x in range(terrain_next_frame[0].size()):
				if terrain_next_frame[y][x][0] == 1:
					terrain_next_frame[y][x][0] = 2;
					#new fog
					_add_check_chunk(x, y)
	
	_mark_visible(x, y, radius_fog, true);
	_mark_visible(x, y, radius_hidden, false);
	_update_depth(x, y, newDepth)

func _mark_visible(x, y, radius, fogOnly):
	for xOff in range(radius):
		if _is_wall(x - xOff, y):
			break
		else:
			for yOff in range(radius):
				if _is_wall(x - xOff, y - yOff):
					break;
				else:
					_make_visible(x - xOff, y - yOff, fogOnly);
			for yOff in range(radius):
				if _is_wall(x - xOff, y + yOff):
					break;
				else:
					_make_visible(x - xOff, y + yOff, fogOnly);
	for xOff in range(radius):
		if _is_wall(x + xOff, y):
			break
		else:
			for yOff in range(radius):
				if _is_wall(x + xOff, y - yOff):
					break;
				else:
					_make_visible(x + xOff, y - yOff, fogOnly);
			for yOff in range(radius):
				if _is_wall(x + xOff, y + yOff):
					break;
				else:
					_make_visible(x + xOff, y + yOff, fogOnly);

func _make_visible(x, y, fogOnly):
	if !_is_wall(x, y) && _cell_exists(x, y):
		if fogOnly:
			if terrain_next_frame[y][x][0] == 2:
				terrain_next_frame[y][x][0] = 1;
			_add_check_chunk(x, y)
		else:
			if terrain_next_frame[y][x][0] == 0 || terrain_next_frame[y][x][0] == 2:
				terrain_next_frame[y][x][0] = 1;
				discovered_flag = true;
			_add_check_chunk(x, y)

func _update_depth(x, y, depth):
	if terrain_next_frame[y][x][1] >= 0 && terrain_next_frame[y][x][1] < depth:
		terrain_next_frame[y][x][1] = depth;
		_add_check_chunk(x, y)

func _add_check_chunk(x, y):
	var xCHUNK = floor(x / CHUNK_SIZE);
	var yCHUNK = floor(y / CHUNK_SIZE);
	var chunk = Vector2(xCHUNK, yCHUNK)
	if !check_chunks.has(chunk):
		check_chunks.append(chunk);

const CHUNK_SIZE = 5;
const CUBE_SIZE = 2;
func _ready():
	var f = File.new()
	f.open("res://maps/test.json", File.READ)
	var res = JSON.parse(f.get_as_text()).result
	#print(res['terrain'])
	terrain = res['terrain'].duplicate(true)
	_calculate_complete_mesh();

func _process(delta):
	for chunk in check_chunks:
		#print("Check: ", chunk)
		if _is_dirty(chunk) && !dirty_chunks.has(chunk):
			dirty_chunks.append(chunk);
	check_chunks = [];
	
	if !dirty_chunks.empty():
		terrain = terrain_next_frame.duplicate(true);
		for chunk in dirty_chunks:
			print("Dirty: ", chunk, " -> ", discovered_flag)
			var _name = str(chunk.x) + "-" + str(chunk.y);
			
			var mICave = chunks_cave.get_node(_name);
			var mIFog = chunks_fog.get_node(_name);
			var mIFps = chunks_fps.get_node(_name);
			
			var data = _generate_mesh(chunk.x, chunk.y, discovered_flag, true, discovered_flag);
			
			if data[0]:
				mICave.mesh = data[0]; # Cave_Mesh data
				mICave.get_child(0).get_child(0).shape = data[3];
			
			mIFog.mesh = data[1]; # Fog_Mesh data
			
			if data[2]:
				mIFps.mesh = data[2]; # Fps_Mesh data
				mIFps.get_child(0).get_child(0).shape = data[4];
		
		first_flag = true;
		dirty_chunks = [];
		discovered_flag = false;
		

func _is_dirty(chunk: Vector2):
	for y in range(CHUNK_SIZE):
		for x in range(CHUNK_SIZE):
			var yWorld = y + chunk.y * CHUNK_SIZE;
			var xWorld = x + chunk.x * CHUNK_SIZE;
			if yWorld >= terrain.size() || xWorld >= terrain[yWorld].size():
				continue
			if terrain[yWorld][xWorld] != terrain_next_frame[yWorld][xWorld]:
				return true;
			
			#check neighbor
			for xOff in range(-1, 2):
				for yOff in range(-1, 2):
					if yWorld + yOff < 0 || xWorld + xOff < 0:
						continue
					if yWorld + yOff >= terrain.size() || xWorld + xOff >= terrain[yWorld + yOff].size():
						continue
					if terrain[yWorld + yOff][xWorld + xOff] != terrain_next_frame[yWorld + yOff][xWorld + xOff]:
						return true;
	return false;

func _calculate_complete_mesh():
	var yS = ceil(terrain.size() / float(CHUNK_SIZE));
	var xS = ceil(terrain[0].size() / float(CHUNK_SIZE));
	
	print("Size: ", xS, " - ", yS)
	
	for c in chunks_cave.get_children():
		c.queue_free();
	for c in chunks_fog.get_children():
		c.queue_free();
	for c in chunks_fps.get_children():
		c.queue_free();
	for y in range(yS):
		for x in range(xS):
			print(x, " - ",y)
			var data = _generate_mesh(x, y);
			
			add_mesh_to(x, y, chunks_cave, data[0], data[3]);
			add_mesh_to(x, y, chunks_fog, data[1]);
			add_mesh_to(x, y, chunks_fps, data[2], data[4]);

func add_mesh_to(x: int, y: int, node: Node, mesh: Mesh, shape: Shape = null):
	var mI = MeshInstance.new();
	mI.mesh = mesh
	mI.translate(Vector3(x * CHUNK_SIZE * CUBE_SIZE, y * CHUNK_SIZE * CUBE_SIZE, 0));
	node.add_child(mI);
	mI.name = str(x) + "-" + str(y);
	if shape:
		var col = StaticBody.new();
		var colShape = CollisionShape.new();
		colShape.shape = shape;
		mI.add_child(col);
		col.add_child(colShape);
		col.connect("input_event", self, "_on_StaticBody_input_event", [Vector2(x, y)]);

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx, data):
	if event is InputEventMouseButton:
		if (event.button_index == 1 || event.button_index == 2) && event.button_mask == 0:
			var n;
			if event.button_index == 1:
				n = $dwarfs/Left;
			else:
				n = $dwarfs/Right;
			var toPos = navigation.get_closest_point(click_position);
			var fromPos = navigation.get_closest_point(n.translation);
			var path = navigation.get_point_path(fromPos, toPos);
			n.way_points = path;
			print(camera, "\t", event, "\t", click_position, "\t", click_normal, "\t", shape_idx, "\t", data, "\n\tnavId: ", "from: ", fromPos, " to: ", toPos, " size: ", path.size())
		elif event.button_index == 3 && event.button_mask == 0:
			print(click_position, click_normal)
			if click_normal == Vector3(0, 0, 1):
				var x = round(click_position.x / 2)
				var y = round(click_position.y / 2)
				print("here: ", Vector2(x, y), " terrain: ", terrain[y][x])
				discovered_flag = true
				update(x, y, 1, 1, 1)

#TODO: split caves/FPS and fog for faster calculation, it doesn't need to calc the caves if only fog is changed
func _generate_mesh(xOff = 0, yOff = 0, calcCave = true, calcFog = true, calcInverted = true) -> Array: #[mesh_cave, mesh_fog, mesh_inverted, shape_cave, shape_inverted]
	var st: SurfaceTool = null;
	if calcCave:
		st = SurfaceTool.new();
		st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var st2: SurfaceTool = null;
	if calcFog:
		st2 = SurfaceTool.new();
		st2.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var st3: SurfaceTool = null;
	if calcInverted:
		st3 = SurfaceTool.new();
		st3.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for y in range(CHUNK_SIZE):#range(terrain.size()):
		for x in range(CHUNK_SIZE):#range(terrain[y].size()):
			var yWorld = y + yOff * CHUNK_SIZE;
			var xWorld = x + xOff * CHUNK_SIZE;
			if yWorld >= terrain.size() || xWorld >= terrain[yWorld].size():
				continue
			if calcInverted:
				_plane(st3, xWorld, yWorld, 0, x, y, true); # Inverted - FirstPerson
			
			if calcFog:
				_fog(st2, xWorld, yWorld, 0, x, y); # Fog and undiscovered
			
			if calcCave:
				if terrain[yWorld][xWorld][1] != 0: # there is a way
					_add_navigation_point(xWorld, yWorld);
				if terrain[yWorld][xWorld][1] == 0:
					_plane(st, xWorld, yWorld, 0, x, y);
				elif terrain[yWorld][xWorld][1] >= 1:
					_plane(st, xWorld, yWorld, -2 * terrain[yWorld][xWorld][1], x, y);
					for i in range(terrain[yWorld][xWorld][1]):
						_passage(st, xWorld, yWorld, -2 * i, x, y);
	
	#print(navigation.get_points().size());
	
	# Commit to a mesh.
	var mesh = null;
	var mesh2 = null;
	var mesh3 = null;
	
	if calcCave:
		st.index();
		st.generate_normals();
		st.generate_tangents();
		mesh = st.commit();
		mesh.surface_set_material(0, load("res://tests/new_textureShader.tres")); #st  = normal
	if calcFog:
		st2.index();
		st2.generate_normals();
		st2.generate_tangents();
		mesh2 = st2.commit();
		mesh2.surface_set_material(0, load("res://tests/new_shadermaterial.tres"));  #st2 = fog of war and undiscovered
	if calcInverted:
		st3.index();
		st3.generate_normals();
		st3.generate_tangents();
		mesh3 = st3.commit();
		mesh3.surface_set_material(0, load("res://tests/new_textureShader.tres")); #st3 = FirstPerson / normal
	
	var shape_cave = null;
	var shape_fps = null;
	
	if calcCave:
		shape_cave = mesh.create_trimesh_shape();
	if calcInverted:
		shape_fps = mesh3.create_trimesh_shape();

	_connect_navigation_points();
	return [mesh, mesh2, mesh3, shape_cave, shape_fps];

func _connect_navigation_points():
	var points = navigation.get_points();
	var ig = $ImmediateGeometry;
	ig.begin(Mesh.PRIMITIVE_LINES)
	for p in points:
		var a = navigation.get_point_position(p);
		var gridPos = Vector2(a.x / CUBE_SIZE, a.y / CUBE_SIZE);
		var xWorld = gridPos.x;
		var yWorld = gridPos.y;
		_connect_navigation_points_from(xWorld - 1, yWorld, p);
		_connect_navigation_points_from(xWorld + 1, yWorld, p);
		_connect_navigation_points_from(xWorld, yWorld - 1, p);
		_connect_navigation_points_from(xWorld, yWorld + 1, p);
		
		var connected = navigation.get_point_connections(p);
		for c in connected:
			var b = navigation.get_point_position(c);
			ig.add_vertex(a);
			ig.add_vertex(b);
		#ig.add_vertex(a);
	ig.end();

func _add_navigation_point(xWorld, yWorld):
	if (terrain[yWorld][xWorld][1] > 1 || terrain[yWorld][xWorld][1] < 0) && !_is_wall(xWorld, yWorld - 1):
		#print("cave")
		return
	elif terrain[yWorld][xWorld][1] < 0: #TODO: Points should be calc based on premade cave
		return
	var navPoint = Vector3(xWorld * CUBE_SIZE, yWorld * CUBE_SIZE, -1);
	var pID = navigation.get_closest_point(navPoint);
	if pID == -1 || navigation.get_point_position(pID) != navPoint:
		navigation.add_point(navigation.get_available_point_id(), navPoint);

func _connect_navigation_points_from(xWorld, yWorld, pID):
	if !_is_wall(xWorld, yWorld):
		var navPoint = Vector3(xWorld * CUBE_SIZE, yWorld * CUBE_SIZE, -1);
		var testpID = navigation.get_closest_point(navPoint);
		if navigation.get_point_position(testpID) == navPoint:
			navigation.connect_points(pID, testpID);
		#else:
		#	var newId = navigation.get_available_point_id();
		#	navigation.add_point(newId, navPoint);
		#	navigation.connect_points(pID, newId);

func _cell_exists(x, y):
	if y > terrain.size() - 1 || x > terrain[y].size() - 1:
		return false;
	elif y <= 0 || x <= 0:
		return false;
	return true;

func _is_visible(x, y, checkPassage = true) -> bool:
	if y > terrain.size() - 1:
		return false;
	elif x > terrain[y].size() - 1:
		return false;
	elif y <= 0 || x <= 0:
		return false;
	elif !checkPassage && terrain[y][x][0] >= 1:
		return true;
	elif checkPassage && (terrain[y][x][0] >= 1 || terrain[y][x][1] >= 1):
		return true;
	return false;

func _is_fog(x, y) -> bool:
	if y > terrain.size() - 1:
		return false;
	elif x > terrain[y].size() - 1:
		return false;
	elif y <= 0 || x <= 0:
		return false;
	elif terrain[y][x][0] == 2:
		return true;
	return false;

func _is_wall(x, y, maxDepth = 0) -> bool:
	if y > terrain.size() - 1:
		return true;
	elif x > terrain[y].size() - 1:
		return true;
	elif y <= 0 || x <= 0:
		return true;
	elif terrain[y][x][1] <= maxDepth && terrain[y][x][1] > 0: #TODO: this makes no sense
		return true;
	elif terrain[y][x][1] != 0:
		return false;
	return true;

func _is_corner_left(x, y) -> bool:
#	if y > terrain.size() - 1:
#		return false;
#	elif x > terrain[y].size() - 1:
#		return false;
#	elif terrain[y][x - 1][1] > terrain[y][x][1] && terrain[y - 1][x][1] > terrain[y][x][1]:
#		return true;
	return false;
func _is_corner_right(x, y, difference = 1) -> bool:
#	if y > terrain.size() - 1:
#		return false;
#	elif x > terrain[y].size() - 2:
#		return false;
#	elif terrain[y][x + 1][1] - terrain[y][x][1] >= difference && terrain[y - 1][x][1] - terrain[y][x][1] >= difference:
#		return true;
	return false;

#
# 0   1
#
# 2   3
#

#r = shadow
#g = type
#b = abbau
#a = shadow
func _get_color(corner: int, x = 0, y = 0) -> Color:
	var type = terrain[y][x][2] / 255.0;
	if _is_visible(x, y, false) && _is_fog(x, y):
		return Color(1, type, 1, 1);
	elif  _is_visible(x, y, false):
		return Color(1, type, 1, 0);
	match(corner):
		0: 
			if not _is_visible(x - 1, y + 1, false) && not _is_visible(x, y + 1, false) && not _is_visible(x - 1, y, false):
				return Color(0, type, 0, 0);
			elif _is_fog(x - 1, y + 1) || _is_fog(x, y + 1) || _is_fog(x - 1, y):
				return Color(1, type, 1, 1);
		1: 
			if not _is_visible(x + 1, y + 1, false) && not _is_visible(x, y + 1, false) && not _is_visible(x + 1, y, false):
				return Color(0, type, 0, 0);
			elif _is_fog(x + 1, y + 1) || _is_fog(x, y + 1) || _is_fog(x + 1, y):
				return Color(1, type, 1, 1);
		2:
			if not _is_visible(x - 1, y - 1, false) && not _is_visible(x, y - 1, false) && not _is_visible(x - 1, y, false):
				return Color(0, type, 0, 0);
			elif _is_fog(x - 1, y - 1) || _is_fog(x, y - 1) || _is_fog(x - 1, y):
				return Color(1, type, 1, 1);
		3:
			if not _is_visible(x + 1, y - 1, false) && not _is_visible(x, y - 1, false) && not _is_visible(x + 1, y, false):
				return Color(0, type, 0, 0);
			elif _is_fog(x + 1, y - 1) || _is_fog(x, y - 1) || _is_fog(x + 1, y):
				return Color(1, type, 1, 1);
	return Color(1, type, 1, 0);

func _plane(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0, inverted = false):
	if inverted:
		st.add_color(_get_color(0, x, y));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(1, x, y));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(3, x, y));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(1, x, y));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
	elif (not _is_visible(x, y, false) && (_is_visible(x + 1, y + 1, false) || _is_visible(x - 1, y - 1, false))) || _is_corner_left(x, y):
		st.add_color(_get_color(0, x, y));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, x, y));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(3, x, y));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(3, x, y));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		if _is_corner_left(x, y):
			st.add_vertex(Vector3(-0 + xOffset*2, -0 + yOffset*2, z))
		else:
			st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(0, x, y));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
	else:
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(0, x, y));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, x, y));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, x, y));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(3, x, y));
		st.add_uv(Vector2(1, 0))
		if _is_corner_right(x, y):
			st.add_vertex(Vector3(0 + xOffset*2, -0 + yOffset*2, z))
		else:
			st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))

func _fog(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	_plane(st, x, y, z, xOffset, yOffset);
	var fogDepth = terrain[y][x][1];
	if fogDepth < 0:
		fogDepth = 10; #TODO: how depth shoud it be?
	# Right
	if _is_fog(x, y) && !_is_fog(x + 1, y) && !_is_wall(x + 1, y):
		for i in range(fogDepth):
			_passage_left(st, x, y, -2 * i, xOffset + 1, yOffset);
	# Left
	if _is_fog(x, y) && !_is_fog(x - 1, y) && !_is_wall(x - 1, y):
		for i in range(fogDepth):
			_passage_right(st, x, y, -2 * i, xOffset - 1, yOffset);
	# Top
	if _is_fog(x, y) && !_is_fog(x, y + 1) && !_is_wall(x, y + 1):
		for i in range(fogDepth):
			_passage_bottom(st, x, y, -2 * i, xOffset, yOffset + 1);
	# Bottom
	if _is_fog(x, y) && !_is_fog(x, y - 1) && !_is_wall(x, y - 1):
		for i in range(fogDepth):
			_passage_ceiling(st, x, y, -2 * i, xOffset, yOffset - 1);

func _passage(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	if _is_wall(x, y - 1, -z/2):
		_passage_bottom(st, x, y, z, xOffset, yOffset);
	if _is_wall(x + 1, y, -z/2):
		_passage_right(st, x, y, z, xOffset, yOffset);
	if _is_wall(x - 1, y, -z/2):
		_passage_left(st, x, y, z, xOffset, yOffset);
	if _is_wall(x, y + 1, -z/2):
		_passage_ceiling(st, x, y, z, xOffset, yOffset);

func _passage_bottom(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))

func _passage_right(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(3, x, y));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))

func _passage_left(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(2, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))

func _passage_ceiling(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, x, y));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(1, x, y));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))















