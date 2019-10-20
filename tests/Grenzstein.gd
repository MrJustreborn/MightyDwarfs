extends Spatial

func _ready():
	pass

func _physics_process(delta):
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