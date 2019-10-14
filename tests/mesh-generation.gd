extends Spatial

onready var chunks = $Chunks;

# [visbile, depth]

var terrain = [
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
	[[0,  0], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [1,  1], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [1,  1], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [0,  0], [0,  0], [0,  0], [1,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [1,  3], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  1], [0,  1], [0,  1], [1,  4], [1,  4], [1,  4], [1,  4], [1,  1], [1,  1], [1,  1], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [1, -1], [1, -1], [1, -1], [1, -1], [1, -1], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [1,  2], [1,  2], [1,  1], [1,  1], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  4], [1,  4], [1,  4], [1,  4], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [1,  1], [0,  0], [0,  0]],
	[[0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0], [0,  0]],
]

const CHUNK_SIZE = 10;
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
			mI.mesh = mesh;
			mI.material_override = load("res://tests/new_Spatialmaterial.tres");
			mI.translate(Vector3(x * CHUNK_SIZE * CUBE_SIZE, y * CHUNK_SIZE * CUBE_SIZE, 0));
			chunks.add_child(mI);
			mI.create_trimesh_collision();
			#TODO: check dynamic memory leaks


func _generate_mesh(xOff = 0, yOff = 0):
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for y in range(CHUNK_SIZE):#range(terrain.size()):
		for x in range(CHUNK_SIZE):#range(terrain[y].size()):
			var yWorld = y + yOff * CHUNK_SIZE;
			var xWorld = x + xOff * CHUNK_SIZE;
			if yWorld >= terrain.size() || xWorld >= terrain[yWorld].size():
				continue
			#if terrain[y][x][0] == 0: # Fog of War
			#	_plane(st, x, y);
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
	var mesh = st.commit()
	return mesh;
	
	#print(ResourceSaver.save("res://tests/testMesh.tres", mesh, 32));

func _is_visible(x, y, checkPassage = true) -> bool:
	if y > terrain.size() - 1:
		return false;
	elif x > terrain[y].size() - 1:
		return false;
	elif y <= 0 || x <= 0:
		return false;
	elif !checkPassage && terrain[y][x][0] == 1:
		return true;
	elif checkPassage && (terrain[y][x][0] == 1 || terrain[y][x][1] >= 1):
		return true;
	return false;

func _is_wall(x, y, maxDepth = 1) -> bool:
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
	if _is_visible(xOffset, yOffset, false):
		return Color(1, 1, 1);
	match(corner):
		0: 
			if not _is_visible(xOffset - 1, yOffset + 1, false) && not _is_visible(xOffset, yOffset + 1, false) && not _is_visible(xOffset - 1, yOffset, false):
				return Color(0, 0, 0);
		1: 
			if not _is_visible(xOffset + 1, yOffset + 1, false) && not _is_visible(xOffset, yOffset + 1, false) && not _is_visible(xOffset + 1, yOffset, false):
				return Color(0, 0, 0);
		2:
			if not _is_visible(xOffset - 1, yOffset - 1, false) && not _is_visible(xOffset, yOffset - 1, false) && not _is_visible(xOffset - 1, yOffset, false):
				return Color(0, 0, 0);
		3:
			if not _is_visible(xOffset + 1, yOffset - 1, false) && not _is_visible(xOffset, yOffset - 1, false) && not _is_visible(xOffset + 1, yOffset, false):
				return Color(0, 0, 0);
	return Color(1, 1, 1);

func _plane(st: SurfaceTool, x = 0, y = 0, z = 0, xOffset = 0, yOffset = 0):
	if not _is_visible(x, y, false) && (_is_visible(x + 1, y + 1, false) || _is_visible(x - 1, y - 1, false)):
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













