extends Spatial

export var radius = 10;

func _ready():
	$Area.connect("input_event", self, "_a")
	pass

func _a( camera, event: InputEvent, click_position, click_normal, shape_idx ):
	print(event)
	get_tree()
	pass

func _process(delta):
	update();

func update():
	var x = round(translation.x / 2)
	var y = round(translation.y / 2)
	#get_tree().get_nodes_in_group("DWARFS");
	if (!$Area.get_overlapping_bodies().empty() || !$Area.get_overlapping_areas().empty()) && !get_parent()._is_fog(x, y):
		get_parent().update(x,y, radius);