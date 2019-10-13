extends Spatial

onready var meshInstance = $MeshInstance;

var terrain = [
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 1, 1, 0, 0, 0, 1, 0],
	[0, 0, 0, 0, 0, 0, 1, 0],
	[0, 0, 1, 0, 0, 0, 1, 0],
	[0, 0, 0, 0, 0, 0, 1, 0],
	[0, 1, 1, 0, 0, 0, 1, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
]

func _ready():
	_generate_mesh();


func _generate_mesh():
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	for y in range(terrain.size()):
		for x in range(terrain[y].size()):
			print(x, " / ", y, " -> ",terrain[y][x]);
			if terrain[y][x] == 0:
				_plane(st, x, y);
			elif terrain[y][x] == 1:
				_plane(st, x, y, -2);
	
	st.index();
	st.generate_normals();
	st.generate_tangents();
	
	# Commit to a mesh.
	var mesh = st.commit()
	
	meshInstance.mesh = mesh;
	meshInstance.create_trimesh_collision();
	
	meshInstance.material_override = load("res://tests/new_shadermaterial.tres");
	
	print(ResourceSaver.save("res://tests/testMesh.tres", mesh, 32));

func _is_visible(x, y) -> bool:
	if y > terrain.size() - 1:
		return false;
	elif x > terrain[y].size() - 1:
		return false;
	elif y <= 0 || x <= 0:
		return false;
	elif terrain[y][x] == 1:
		return true;
	return false;

#
# 0   1
#
# 2   3
#
func _get_color(corner: int, xOffset = 0, yOffset = 0) -> Color:
	if _is_visible(xOffset, yOffset):
		return Color(1, 0, 0);
	match(corner):
		0: 
			if not _is_visible(xOffset - 1, yOffset + 1) && not _is_visible(xOffset, yOffset + 1) && not _is_visible(xOffset - 1, yOffset):
				return Color(0, 0, 0);
		1: 
			if not _is_visible(xOffset + 1, yOffset + 1) && not _is_visible(xOffset, yOffset + 1) && not _is_visible(xOffset + 1, yOffset):
				return Color(0, 0, 0);
		2:
			if not _is_visible(xOffset - 1, yOffset - 1) && not _is_visible(xOffset, yOffset - 1) && not _is_visible(xOffset - 1, yOffset):
				return Color(0, 0, 0);
		3:
			if not _is_visible(xOffset + 1, yOffset - 1) && not _is_visible(xOffset, yOffset - 1) && not _is_visible(xOffset + 1, yOffset):
				return Color(0, 0, 0);
	return Color(1, 0, 0);

func _plane(st: SurfaceTool, xOffset = 0, yOffset = 0, z = 0):
	if not _is_visible(xOffset, yOffset) && (_is_visible(xOffset + 1, yOffset + 1) || _is_visible(xOffset - 1, yOffset - 1)):
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
	pass