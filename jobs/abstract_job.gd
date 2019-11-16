class_name AbstractJob

var owner: Node = null;
var personal: bool = false setget _set_personal; # can be readded or not, personal jobs are dwarf specific (user explicit added job for this dwarf) and cannot be readded to job-system

func _set_personal(isPersonal: bool):
	if !personal && isPersonal: #can only be set one time to true not back, a personal job cannot be made public to everyone again.
		personal = true;

func icon():# -> Texture:
	pass

func title() -> String:
	return tr("");

func description() -> String:
	return tr("");

func process(delta: float, origin: Node = owner):
	pass

func physics_process(delta: float, origin: Node = owner):
	pass

func finished():
	return true;
