extends Spatial

var mouse_cell_pos: Vector2 setget set_mouse_pos;

var start_pos = null
var end_pos = null

func _ready():
	pass

func set_mouse_pos(pos: Vector2):
	mouse_cell_pos = pos;
	var x = int(pos.x)
	var y = int(pos.y)
	
	if x % 2 == 0 && y % 2 == 0 && !start_pos:
		$MeshInstance.translation.x = pos.x * 2;
		$MeshInstance.translation.y = pos.y * 2;
		$MeshInstance.get_surface_material(0).set_shader_param("blue_tint", get_color(x, y))
	elif x % 2 == 0 && y % 2 == 0 && (start_pos.x == x || start_pos.y == y):
		$MeshInstance.translation.x = pos.x * 2;
		$MeshInstance.translation.y = pos.y * 2;
		$MeshInstance.get_surface_material(0).set_shader_param("blue_tint", get_color(x, y))
		if end_pos != pos:
			end_pos = pos;
			generate_mesh()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) && !start_pos:
		#print("HERE ", pos)
		start_pos = pos
	elif !Input.is_mouse_button_pressed(BUTTON_LEFT) && start_pos:
		#print("COMPLETE:", start_pos, end_pos)
		start_pos = null;
		end_pos = null;

func get_color(x, y):
	if get_parent()._is_wall(x, y):
		return Color(0, 1, 0)
	return Color(1, 0, 0)

func generate_mesh():
	print("Update info mesh")
	
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	print(start_pos-end_pos)