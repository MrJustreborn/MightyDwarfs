extends Node

signal job_added(new_job)

var jobs = []

func _ready():
	pass

# Array<AbstractJob>
func submit_jobs(job: Array, to_instance: Node = null):
	print("Submit new jobs: ", job, " -> ",to_instance)
	if to_instance && to_instance.has_method("set_personal_jobs"):
		for j in jobs:
			j.personal = true;
			j.owner = to_instance;
		to_instance.set_personal_jobs(job);
	else:
		for j in jobs:
			if !j.personal:
				j.owner = null;
				_add_job(j);
				emit_signal("job_added", j);
	print("Current jobs pending: ", jobs)

func _add_job(job):
	for j in jobs:
		var _j: AbstractJob = j;
		if _j.equals(job):
			return;
	jobs.append(job)
	print("new job added: ", job)

func get_copy_of_all_jobs():
	return jobs.duplicate(true);

func _get_job_titles_printable(jobs: Array):
	var string = "";
	for job in jobs:
		var j: AbstractJob = job;
		string += j.title() + "|";
	return string;