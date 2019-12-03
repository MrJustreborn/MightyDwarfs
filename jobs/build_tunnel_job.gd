extends AbstractJob

var position: Vector2;

func _init(pos: Vector2):
	position = pos

func _setup_new_owner() -> void:
	pass

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
	pass

func physics_process(delta: float) -> void:
	pass

func finished() -> bool:
	return true;
