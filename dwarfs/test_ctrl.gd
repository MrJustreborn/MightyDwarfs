class_name Dwarf
extends KinematicBody

const SPEED = 5;

export var WASD = false;

var CTRL: Spatial

var way_points: PoolVector3Array = [] setget set_way_points;

var target: Vector2;

func _ready():
	#FIXME: setup ctrl
	CTRL = get_parent().get_parent();
	connect("input_event", $"/root/in_game_state", "_on_dwarf_input_event", [self]);
	if WASD:
		$MeshInstance2.material_override = $MeshInstance2.get_surface_material(0).duplicate()
		$MeshInstance2.material_override.albedo_color = Color(1,0,0)
	pass

func _on_input(camera: Camera, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.button_mask == 0:
			if Input.is_key_pressed(KEY_SHIFT):
				add_to_group("ACTIVE_SELECTION");
			else:
				get_tree().call_group("ACTIVE_SELECTION", "_remove_active");
				add_to_group("ACTIVE_SELECTION");
			updateLabel(last_cell);
func _remove_active():
	remove_from_group("ACTIVE_SELECTION");
	updateLabel(last_cell);

func set_way_points(points: PoolVector3Array):
	print("Update way points in: ", name)
	way_points = points;

func _physics_process(delta):
#	if !WASD:
#		if Input.is_action_pressed("ui_right"):
#			move_and_slide(Vector3(1, 0, 0) * SPEED);
#		elif Input.is_action_pressed("ui_left"):
#			move_and_slide(Vector3(-1, 0, 0) * SPEED);
#		elif Input.is_action_pressed("ui_up"):
#			move_and_slide(Vector3(0, 1, 0) * SPEED);
#		elif Input.is_action_pressed("ui_down"):
#			move_and_slide(Vector3(0, -1, 0) * SPEED);
#	else:
#		if Input.is_key_pressed(KEY_D):
#			move_and_slide(Vector3(1, 0, 0) * SPEED);
#		elif Input.is_key_pressed(KEY_A):
#			move_and_slide(Vector3(-1, 0, 0) * SPEED);
#		elif Input.is_key_pressed(KEY_W):
#			move_and_slide(Vector3(0, 1, 0) * SPEED);
#		elif Input.is_key_pressed(KEY_S):
#			move_and_slide(Vector3(0, -1, 0) * SPEED);
	
	if way_points.size() > 0:
		var dist = translation.distance_to(way_points[0]);
		var dir = translation.direction_to(way_points[0]);
		#print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
		if dist >= 0.25:
			move_and_slide(dir * SPEED);
		else:
			way_points.remove(0);
		if way_points.size() > 1:
			var x = round(way_points[1].x / 2)
			var y = round(way_points[1].y / 2)
			var next_cell = Vector2(x,y);
			updateLabel(next_cell)
		else:
			updateLabel(last_cell)
func _process(delta):
	update();
	var pos = get_viewport().get_camera().unproject_position(translation);
	$Label.rect_global_position = pos;

func updateLabel(next: Vector2):
	var dir = (last_cell-next)
	var dirText = "none"
	if dir.x == 1:
		dirText = "left"
	elif dir.x == -1:
		dirText = "right"
	elif dir.y == -1:
		dirText = "up"
	elif dir.y == 1:
		dirText = "down"
	#$Label.text = str(last_cell) +"\n"+ str(next) +"\n"+ str(dirText)
	$Label.text = str(dirText) +"\n"+ "walk" + "\n" + str(is_in_group("ACTIVE_SELECTION"))


var last_cell = Vector2();
func update():
	var x = round(translation.x / 2)
	var y = round(translation.y / 2)
	var cur_cell = Vector2(x,y);
	if last_cell != cur_cell:
		#print(last_cell, cur_cell)
		last_cell = cur_cell;
		#print("update")
	CTRL.update(x,y);
