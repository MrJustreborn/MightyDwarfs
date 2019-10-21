extends KinematicBody

const SPEED = 5;

export var WASD = false;

var way_points: PoolVector3Array = [];

func _ready():
	pass

func _physics_process(delta):
	if !WASD:
		if Input.is_action_pressed("ui_right"):
			move_and_slide(Vector3(1, 0, 0) * SPEED);
		elif Input.is_action_pressed("ui_left"):
			move_and_slide(Vector3(-1, 0, 0) * SPEED);
		elif Input.is_action_pressed("ui_up"):
			move_and_slide(Vector3(0, 1, 0) * SPEED);
		elif Input.is_action_pressed("ui_down"):
			move_and_slide(Vector3(0, -1, 0) * SPEED);
	else:
		if Input.is_key_pressed(KEY_D):
			move_and_slide(Vector3(1, 0, 0) * SPEED);
		elif Input.is_key_pressed(KEY_A):
			move_and_slide(Vector3(-1, 0, 0) * SPEED);
		elif Input.is_key_pressed(KEY_W):
			move_and_slide(Vector3(0, 1, 0) * SPEED);
		elif Input.is_key_pressed(KEY_S):
			move_and_slide(Vector3(0, -1, 0) * SPEED);
	
	if way_points.size() > 0:
		var dist = translation.distance_to(way_points[0]);
		var dir = translation.direction_to(way_points[0]);
		#print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
		if dist >= 0.5:
			move_and_slide(dir * SPEED);
		else:
			way_points.remove(0);
			print(way_points.size())
func _process(delta):
	update();


#var last_cell = Vector2();
func update():
	var x = round(translation.x / 2)
	var y = round(translation.y / 2)
	#var cur_cell = Vector2(x,y);
	#if last_cell != cur_cell:
		#print(last_cell, cur_cell)
	#	last_cell = cur_cell;
		#print("update")
	get_parent().update(x,y);
