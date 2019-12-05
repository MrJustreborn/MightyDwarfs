extends Spatial

const ray_length = 1000

func _ready():
	pass

var gimble = false;
var gimble_active = false;
func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 2:
			gimble = event.pressed;
			gimble_active = !gimble;
#			if event.pressed:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#			else:
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.button_index == BUTTON_WHEEL_UP:
			if $Camera.translation.z > 10:
				$Camera.translate(Vector3(0, 0, -1))
		elif event.button_index == BUTTON_WHEEL_DOWN:
			if $Camera.translation.z < 500:
				$Camera.translate(Vector3(0, 0, 1))
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_MASK_RIGHT):
			#print(rotation_degrees)
			if rotation_degrees.y >= -70 && rotation_degrees.y <= 70:
				rotate_y(deg2rad(-event.relative.x / 10.0));
			elif rotation_degrees.y <= -70:
				rotation_degrees.y = -70;
			elif rotation_degrees.y >= 70:
				rotation_degrees.y = 70
			
			if rotation_degrees.x >= -30 && rotation_degrees.x <= 30:
				rotate_x(deg2rad(-event.relative.y / 10.0));
			elif rotation_degrees.x <= -30:
				rotation_degrees.x = -30;
			elif rotation_degrees.x >= 30:
				rotation_degrees.x = 30
			
			rotation_degrees.z = 0;

func _physics_process(delta):
#	if gimble && !gimble_active:
#		gimble_active = true;
#		var pos = Vector2(1920/2, 1080/2)
#		var from = project_ray_origin(pos)
#		var to = from + project_ray_normal(pos) * ray_length
#		print(pos, " - ",from, " - ",to)
#		
#		var space_state = get_world().direct_space_state
#		var result = space_state.intersect_ray(from, to)
#		print(result)
	pass

func _process(delta):
	var speed = 0.2;
	if Input.is_action_pressed("ui_left"):
		global_translate(Vector3(-1, 0, 0) * speed)
	elif Input.is_action_pressed("ui_right"):
		global_translate(Vector3(1, 0, 0) * speed)
	elif Input.is_action_pressed("ui_up"):
		global_translate(Vector3(0, 1, 0) * speed)
	elif Input.is_action_pressed("ui_down"):
		global_translate(Vector3(0, -1, 0) * speed)