extends Node

signal job_added(new_job)
signal job_removed(removed_job)

var jobs = []

func _ready():
	pass

# Array<AbstractJob>
func submit_jobs(job: Array, to_instance: Node = null):
	print("Submit new jobs: ", job, " -> ",to_instance)
	if to_instance && to_instance.has_method("set_personal_jobs"):
		for j in job:
			j.personal = true;
			j.owner = to_instance;
			j.jobSystem = self;
		to_instance.set_personal_jobs(job);
	else:
		for j in job:
			if !j.personal:
				j.owner = null;
				j.jobSystem = self;
				_add_job(j);
	print("Current jobs pending: ", jobs)

func _add_job(job):
	for j in jobs:
		var _j: AbstractJob = j;
		if _j.equals(job):
			return;
	jobs.append(job)
	emit_signal("job_added", job);
	print("new job added: ", job)

func remove_finished_job(job: AbstractJob):
	var where = jobs.find(job);
	if where > 0:# && job.finished():
		jobs.remove(where);
		emit_signal("job_removed", job);

func get_copy_of_all_jobs():
	return jobs.duplicate(true);

func get_tunnel_job_on_cell(pos: Vector2):
	for j in jobs:
		var _j: AbstractJob = j;
		if _j.get_job_name() == JobNames.BUILD_TUNNEL:
			if _j.get_cell_pos() == pos:
				return _j;
	return null;

func request_jobs(pos: Vector2, caller: Node):
	var nearest: AbstractJob = null;
	var lastPos = 500;
	for j in jobs:
		if j.distance_from_cell(pos).size() < lastPos && j.distance_from_cell(pos).size() > 0:# && j.owner == null: #todo: is reachable
			lastPos = j.distance_from_cell(pos).size();
			nearest = j;
			#print(j, " ", j.owner)
	if nearest:
		print(pos, " -> ", lastPos, " ", nearest, " ", nearest.get_cell_pos(), " ", nearest.owner, " ", caller);
		nearest.owner = caller;
		var path = nearest.distance_from_cell(pos);
		if path.size() > 0:
			var walk: AbstractJob = preload("res://jobs/walk_job.gd").new(nearest.navigation, path[path.size() - 1]);
			walk.personal = true;
			walk.owner = caller;
			return [walk, nearest];
		else:
			return [nearest]
	else:
		print(pos, " -> ", lastPos, " ", nearest, " ", nearest);
	return [];

func _get_job_titles_printable(jobs: Array):
	var string = "";
	for job in jobs:
		var j: AbstractJob = job;
		string += j.title() + "|";
	return string;