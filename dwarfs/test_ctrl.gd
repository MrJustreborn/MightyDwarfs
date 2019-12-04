class_name Dwarf
extends KinematicBody

onready var state = $"/root/in_game_state";
onready var job_system = $"/root/in_game_jobs";

const SPEED = 5;

export var WASD = false;

var CTRL: Spatial

var jobs = [];

#var way_points: PoolVector3Array = [] setget set_way_points;

#var target: Vector2;

func _ready():
	#FIXME: setup ctrl
	CTRL = get_parent().get_parent();
	connect("input_event", $"/root/in_game_state", "_on_dwarf_input_event", [self]);
	if WASD:
		$MeshInstance2.material_override = $MeshInstance2.get_surface_material(0).duplicate()
		$MeshInstance2.material_override.albedo_color = Color(1,0,0)
	pass

func set_personal_jobs(jobsToDO: Array):
	if !jobs.empty(): #Readd pending jobs
		job_system.submit_jobs(jobs);
	jobs = jobsToDO
	pass

#func set_way_points(points: PoolVector3Array):
#	print("Update way points in: ", name)
#	way_points = points;

func _physics_process(delta):
#	if way_points.size() > 0:
#		var dist = translation.distance_to(way_points[0]);
#		var dir = translation.direction_to(way_points[0]);
#		#print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
#		if dist >= 0.25:
#			move_and_slide(dir * SPEED);
#		else:
#			way_points.remove(0);
#		if way_points.size() > 1:
#			var x = round(way_points[1].x / 2)
#			var y = round(way_points[1].y / 2)
#			var next_cell = Vector2(x,y);
#			updateLabel(next_cell)
#		else:
#			updateLabel(last_cell)
	if jobs.size() > 0:
		var job: AbstractJob = jobs[0];
		job.physics_process(delta);
	pass

var time = 0;
func _process(delta):
	update();
	var pos = get_viewport().get_camera().unproject_position(translation);
	$Label.rect_global_position = pos;
	$Label.text = str(jobs.size());
	if jobs.size() > 0:
		var job: AbstractJob = jobs[0];
		job.process(delta);
		$Label.text += "\n" + job.title();
		$Label.text += "\n" + str(job.finished());
		if job.finished():
			jobs.remove(0);
	elif time >= 100:
		time = 0;
		var newJob = job_system.request_job(last_cell, self)
		if newJob:
			jobs.append(newJob)
	else:
		time += 1;

#func updateLabel(next: Vector2):
#	var dir = (last_cell-next)
#	var dirText = "none"
#	if dir.x == 1:
#		dirText = "left"
#	elif dir.x == -1:
#		dirText = "right"
#	elif dir.y == -1:
#		dirText = "up"
#	elif dir.y == 1:
#		dirText = "down"
#	#$Label.text = str(last_cell) +"\n"+ str(next) +"\n"+ str(dirText)
#	$Label.text = str(dirText) +"\n"+ "walk" + "\n" + str(is_in_group("ACTIVE_SELECTION"))


var last_cell = Vector2();
func update():
	var x = round(translation.x / 2)
	var y = round(translation.y / 2)
	var cur_cell = Vector2(x,y);
	if last_cell != cur_cell:
		#print(last_cell, cur_cell)
		last_cell = cur_cell;
		#print("update")
	CTRL.update(x,y);
