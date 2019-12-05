extends AbstractJob

var position: Vector2;
var navigation: AStar
var mapMeshCtrl: Node

func _init(pos: Vector2, nav: AStar, meshCtrl: Node):
	position = pos;
	navigation = nav;
	mapMeshCtrl = meshCtrl;

func _setup_new_owner() -> void:
	pass

func get_cell_pos() -> Vector2:
	return position;

func distance_from_cell(cell: Vector2) -> Array:
	var target = Vector3(cell.x * 2, cell.y * 2, 0);
	var selfPos = Vector3(position.x * 2, position.y * 2, 0);
	
	var toPos = navigation.get_closest_point(selfPos);
	var targetPos = navigation.get_point_position(toPos);
	
	var dist = (targetPos - selfPos).length()
	#print(self, " Dist: ", dist);
	if dist > 3:
		return [];
	
	var fromPos = navigation.get_closest_point(target);
	var path = navigation.get_point_path(fromPos, toPos);
	#print(self, " -> ", path)
	return path;

func get_job_name() -> String:
	return JobNames.BUILD_TUNNEL;

func equals(other: AbstractJob) -> bool:
	return other.get_job_name() == get_job_name() && other.position == position

func icon():# -> Texture:
	pass

func title() -> String:
	return tr("");

func description() -> String:
	return tr("");

func process(delta: float) -> void:
	mapMeshCtrl.update(position.x, position.y, 0, 0, 1);
	var c = mapMeshCtrl.terrain_next_frame[int(position.y)][int(position.x)]
	#print("asdf ", c, " ", mapMeshCtrl._cell_exists(position.x, position.y), mapMeshCtrl._cell_exists(position.x, position.y) && c[1] < 1 && c[3] <= 5)

func physics_process(delta: float) -> void:
	pass

func finished() -> bool:
	var finished = !mapMeshCtrl.is_mineable(get_cell_pos().x, get_cell_pos().y);
	if finished:
		jobSystem.remove_finished_job(self);
	return finished
