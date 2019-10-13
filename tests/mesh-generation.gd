extends Spatial

onready var meshInstance = $MeshInstance;

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

func _ready():
	_generate_mesh();


func _generate_mesh():
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for y in range(terrain.size()):
		for x in range(terrain[y].size()):
			#print(x, " / ", y, " -> ",terrain[y][x]);
			#if terrain[y][x][0] == 0: # Fog of War
			#	_plane(st, x, y);
			if terrain[y][x][1] == 0:
				_plane(st, x, y);
			elif terrain[y][x][1] >= 1:
				_plane(st, x, y, -2 * terrain[y][x][1]);
				for i in range(terrain[y][x][1]):
					_passage(st, x, y, -2 * i);
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	
	# Commit to a mesh.
	var mesh = st.commit()
	
	meshInstance.mesh = mesh;
	meshInstance.create_trimesh_collision();
	
	meshInstance.material_override = load("res://tests/new_shadermaterial.tres");
	
	print(ResourceSaver.save("res://tests/testMesh.tres", mesh, 32));

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
		return Color(1, 0, 0);
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
	return Color(1, 0, 0);

func _plane(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	if not _is_visible(xOffset, yOffset, false) && (_is_visible(xOffset + 1, yOffset + 1, false) || _is_visible(xOffset - 1, yOffset - 1, false)):
		st.add_color(_get_color(0, xOffset, yOffset));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, xOffset, yOffset));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(3, xOffset, yOffset));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(3, xOffset, yOffset));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(2, xOffset, yOffset));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(0, xOffset, yOffset));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
	else:
		st.add_color(_get_color(2, xOffset, yOffset));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(0, xOffset, yOffset));
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, xOffset, yOffset));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(1, xOffset, yOffset));
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, z))
		
		st.add_color(_get_color(3, xOffset, yOffset));
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, z))
		
		st.add_color(_get_color(2, xOffset, yOffset));
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, z))

func _passage(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	if _is_wall(xOffset, yOffset - 1, -z/2):
		_passage_bottom(st, xOffset, yOffset, z);
	if _is_wall(xOffset + 1, yOffset, -z/2):
		_passage_right(st, xOffset, yOffset, z);
	if _is_wall(xOffset - 1, yOffset, -z/2):
		_passage_left(st, xOffset, yOffset, z);
	if _is_wall(xOffset, yOffset + 1, -z/2):
		_passage_ceiling(st, xOffset, yOffset, z);

func _passage_bottom(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))

func _passage_right(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(3, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, -1 + yOffset*2, 0 + z))

func _passage_left(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(2, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, -1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))

func _passage_ceiling(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, -2 + z))
	
	st.add_color(_get_color(0, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1 + xOffset*2, 1 + yOffset*2, 0 + z))
	
	st.add_color(_get_color(1, xOffset, yOffset));
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(1 + xOffset*2, 1 + yOffset*2, 0 + z))













