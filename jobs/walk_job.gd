extends AbstractJob

var navigation: AStar
var target: Vector3
var way_points: PoolVector3Array = [];

func _init(nav, pos):
	navigation = nav;
	target = pos;

func _setup_new_owner() -> void:
	print("Setup ... ", owner)
	if owner:
		way_points = calc_way_points();
	else:
		way_points = [];

func calc_way_points() -> Array:
	var toPos = navigation.get_closest_point(target);
	var targetPos = navigation.get_point_position(toPos);
	var dist = (targetPos - target).length()
	print("Dist: ", dist);
	if dist > 1.5:
		return [];
	
	var fromPos = navigation.get_closest_point(owner.translation);
	var path = navigation.get_point_path(fromPos, toPos);
	
	print("Waypoints size: ", path.size())
	
	return path;

func get_cell_pos() -> Vector2:
	var x = round(target.x / 2)
	var y = round(target.y / 2)
	return Vector2(x, y);

func get_job_name() -> String:
	return JobNames.WALK;

func process(delta: float):
	pass

func physics_process(delta: float):
	if way_points.size() > 0:
		var dist = owner.translation.distance_to(way_points[0]);
		var dir = owner.translation.direction_to(way_points[0]);
		#print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
		if dist >= 0.025:
			owner.move_and_slide(dir * owner.SPEED);
		else:
			way_points.remove(0);

func finished():
	return way_points.size() <= 0;
