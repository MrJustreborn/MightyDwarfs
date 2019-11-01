extends Spatial

onready var path: Path = $Spatial/Path

func _ready():
	var p = path.curve.get_baked_points()
	print(p, " - ", path.curve.get_baked_length())
	pass
