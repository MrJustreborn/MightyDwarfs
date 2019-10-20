extends KinematicBody

const SPEED = 5;

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		move_and_slide(Vector3(1, 0, 0) * SPEED);
	elif Input.is_action_pressed("ui_left"):
		move_and_slide(Vector3(-1, 0, 0) * SPEED);
	elif Input.is_action_pressed("ui_up"):
		move_and_slide(Vector3(0, 1, 0) * SPEED);
	elif Input.is_action_pressed("ui_down"):
		move_and_slide(Vector3(0, -1, 0) * SPEED);
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
