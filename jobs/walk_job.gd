extends AbstractJob

var navigation
var target


func _init(nav, pos):
	navigation = nav;
	target = pos;

func process(delta: float, origin: Node = owner):
	pass

func physics_process(delta: float, origin: Node = owner):
	pass

func finished():
	return false;
