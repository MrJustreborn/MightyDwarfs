extends Spatial

func _ready():
	pass

func _process(delta):
	update();

func update():
	var x = round(translation.x / 2)
	var y = round(translation.y / 2)
	if (!$Area.get_overlapping_bodies().empty() || !$Area.get_overlapping_areas().empty()) && !get_parent()._is_fog(x, y):
		get_parent().update(x,y, 10);