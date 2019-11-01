extends Camera

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		translate(Vector3(-1, 0, 0))
	elif Input.is_action_pressed("ui_right"):
		translate(Vector3(1, 0, 0))
	elif Input.is_action_pressed("ui_up"):
		translate(Vector3(0, 1, 0))
	elif Input.is_action_pressed("ui_down"):
		translate(Vector3(0, -1, 0))
	elif Input.is_key_pressed(KEY_PAGEUP):
		translate(Vector3(0, 0, -1))
	elif Input.is_key_pressed(KEY_PAGEDOWN):
		translate(Vector3(0, 0, 1))
	elif Input.is_key_pressed(KEY_INSERT):
		rotate_x(deg2rad(2))
	elif Input.is_key_pressed(KEY_DELETE):
		rotate_x(deg2rad(-2))