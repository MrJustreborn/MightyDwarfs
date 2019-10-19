extends Spatial

onready var chunks = $Chunks;

# [visbile, depth]

var terrain = [
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
	[[0,  0], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [1,  1], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [1,  1], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [1,  3], [2,  3], [1,  3], [1,  3], [1,  3], [0,  0], [2,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  1], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  1], [0,  1], [0,  1], [2,  4], [2,  4], [2,  4], [2,  4], [2,  1], [2,  1], [1,  1], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [2,  4], [2,  4], [2,  4], [2,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
]

const CHUNK_SIZE = 50;
const CUBE_SIZE = 2;
func _ready():
	var yS = ceil(terrain.size() / float(CHUNK_SIZE));
	var xS = ceil(terrain[0].size() / float(CHUNK_SIZE));
	
	print("Size: ", xS, " - ", yS)
	
	for y in range(yS):
		for x in range(xS):
			print(x, " - ",y)
			var mesh = _generate_mesh(x, y);
			var mI = MeshInstance.new();
			
			mI.mesh = mesh
			mI.translate(Vector3(x * CHUNK_SIZE * CUBE_SIZE, y * CHUNK_SIZE * CUBE_SIZE, 0));
			chunks.add_child(mI);
			mI.create_trimesh_collision();
			#TODO: check dynamic memory leaks
			print(ResourceSaver.save("res://tests/testMesh2.tres", mesh, 32));


func _generate_mesh(xOff = 0, yOff = 0) -> ArrayMesh:
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var st2 = SurfaceTool.new();
	st2.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var st3 = SurfaceTool.new();
	st3.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for y in range(CHUNK_SIZE):#range(terrain.size()):
		for x in range(CHUNK_SIZE):#range(terrain[y].size()):
			var yWorld = y + yOff * CHUNK_SIZE;
			var xWorld = x + xOff * CHUNK_SIZE;
			if yWorld >= terrain.size() || xWorld >= terrain[yWorld].size():
				continue
			_plane(st3, xWorld, yWorld, 0, x, y, true); # Inverted - FirstPerson
			#if terrain[yWorld][xWorld][0] == 0: # Fog of War
			_fog(st2, xWorld, yWorld, 0, x, y); # TODO: start/end plane
			if terrain[yWorld][xWorld][1] == 0:
				_plane(st, xWorld, yWorld, 0, x, y);
			elif terrain[yWorld][xWorld][1] >= 1:
				_plane(st, xWorld, yWorld, -2 * terrain[yWorld][xWorld][1], x, y);
				for i in range(terrain[yWorld][xWorld][1]):
					_passage(st, xWorld, yWorld, -2 * i, x, y);
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	
	# Commit to a mesh.
	var mesh = st.commit();
	var mesh2 = st2.commit();
	var mesh3 = st3.commit();
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh2.surface_get_arrays(0));
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh3.surface_get_arrays(0));

	mesh.surface_set_material(0, load("res://tests/new_textureShader.tres")); #st  = normal
	mesh.surface_set_material(1, load("res://tests/new_shadermaterial.tres"));  #st2 = fog of war and undiscovered
	mesh.surface_set_material(2, load("res://tests/new_textureShader.tres")); #st3 = FirstPerson / normal
	#mesh.surface_get_material(1).set_shader_param('color', Color(.5, .5, .5));
	return mesh;
	
	#print(ResourceSaver.save("res://tests/testMesh.tres", mesh, 32));

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
	elif terrain[y][x][1] <= maxDepth && terrain[y][x][1] > 0:
		return true;
	elif terrain[y][x][1] != 0:
		return false;
	return true;

#
# 0   1
#
# 2   3
#
func _get_color(corner: int, xOffset = 0, yOffset = 0) -> Color:
	if _is_visible(xOffset, yOffset, false) && _is_fog(xOffset, yOffset):
		return Color(1, 1, 1, 1);
	elif  _is_visible(xOffset, yOffset, false):
		return Color(1, 1, 1, 0);
	match(corner):
		0: 
			if not _is_visible(xOffset - 1, yOffset + 1, false) && not _is_visible(xOffset, yOffset + 1, false) && not _is_visible(xOffset - 1, yOffset, false):
				return Color(0, 0, 0, 0);
			elif _is_fog(xOffset - 1, yOffset + 1) || _is_fog(xOffset, yOffset + 1) || _is_fog(xOffset - 1, yOffset):
				return Color(1, 1, 1, 1);
		1: 
			if not _is_visible(xOffset + 1, yOffset + 1, false) && not _is_visible(xOffset, yOffset + 1, false) && not _is_visible(xOffset + 1, yOffset, false):
				return Color(0, 0, 0, 0);
			elif _is_fog(xOffset + 1, yOffset + 1) || _is_fog(xOffset, yOffset + 1) || _is_fog(xOffset + 1, yOffset):
				return Color(1, 1, 1, 1);
		2:
			if not _is_visible(xOffset - 1, yOffset - 1, false) && not _is_visible(xOffset, yOffset - 1, false) && not _is_visible(xOffset - 1, yOffset, false):
				return Color(0, 0, 0, 0);
			elif _is_fog(xOffset - 1, yOffset - 1) || _is_fog(xOffset, yOffset - 1) || _is_fog(xOffset - 1, yOffset):
				return Color(1, 1, 1, 1);
		3:
			if not _is_visible(xOffset + 1, yOffset - 1, false) && not _is_visible(xOffset, yOffset - 1, false) && not _is_visible(xOffset + 1, yOffset, false):
				return Color(0, 0, 0, 0);
			elif _is_fog(xOffset + 1, yOffset - 1) || _is_fog(xOffset, yOffset - 1) || _is_fog(xOffset + 1, yOffset):
				return Color(1, 1, 1, 1);
	return Color(1, 1, 1, 0);

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
	elif not _is_visible(x, y, false) && (_is_visible(x + 1, y + 1, false) || _is_visible(x - 1, y - 1, false)):
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
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(2, x, y));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))

func _fog(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	_plane(st, x, y, z, xOffset, yOffset);
	# Right
	if _is_fog(x, y) && !_is_fog(x + 1, y) && !_is_wall(x + 1, y):
		for i in range(terrain[y][x][1]):
			_passage_left(st, x, y, -2 * i, xOffset + 1, yOffset);
	# Left
	if _is_fog(x, y) && !_is_fog(x - 1, y) && !_is_wall(x - 1, y):
		for i in range(terrain[y][x][1]):
			_passage_right(st, x, y, -2 * i, xOffset - 1, yOffset);
	# Top
	if _is_fog(x, y) && !_is_fog(x, y + 1) && !_is_wall(x, y + 1):
		for i in range(terrain[y][x][1]):
			_passage_bottom(st, x, y, -2 * i, xOffset, yOffset + 1);
	# Bottom
	if _is_fog(x, y) && !_is_fog(x, y - 1) && !_is_wall(x, y - 1):
		for i in range(terrain[y][x][1]):
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













