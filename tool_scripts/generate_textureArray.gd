tool
extends EditorScript

const SIZE = 4;

func _run():
	print("Start")
	var arr = TextureArray.new();
	arr.create(64, 64, SIZE, Image.FORMAT_RGBA8)#, TextureLayered.FLAG_REPEAT | TextureLayered.FLAG_MIPMAPS | TextureLayered.FLAG_FILTER);
	
#	var _img = Image.new();
#	_img.create(64, 64, true, Image.FORMAT_RGBA8);
#	_img.fill(Color(1, 0, 0));
#	arr.set_layer_data(_img, 0);
#	
#	_img = Image.new();
#	_img.create(64, 64, true, Image.FORMAT_RGBA8);
#	_img.fill(Color(0, 1, 0));
#	arr.set_layer_data(_img, 1);
#	
#	_img = Image.new();
#	_img.create(64, 64, true, Image.FORMAT_RGBA8);
#	_img.fill(Color(0, 0, 1));
#	arr.set_layer_data(_img, 2);
	
	for i in range(SIZE):
		var img = Image.new()
		img.load("res://icon.png");
		#var img = load("res://icon.png");
		img.convert(Image.FORMAT_RGBA8);
		#print(typeof(img), " ", img.get_format(), " - ", Image.FORMAT_RGBA8)
		print(img, " ",i)
		arr.set_layer_data(img.duplicate(), i);
	
	var d = Directory.new()
	d.open("res://tests/texture/");
	if d.file_exists("type.res"):
		d.remove("type.res");
		print("Removed")
	print(ResourceSaver.save("res://tests/texture/type.res", arr), " - ", arr.flags);

