class_name AbstractJob

var owner: Node = null setget _set_owner;
var personal: bool = false setget _set_personal; # can be readded or not, personal jobs are dwarf specific (user explicit added job for this dwarf) and cannot be readded to job-system

func _set_personal(isPersonal: bool):
	if !personal && isPersonal: #can only be set one time to true not back, a personal job cannot be made public to everyone again.
		personal = true;

func _set_owner(newOwner: Node):
	owner = newOwner;
	_setup_new_owner();

func _setup_new_owner() -> void:
	pass

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
