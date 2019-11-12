tool
extends EditorScript

const SIZE = 4;
const CHUNK_SIZE = 5;

func _run():
	print("Start")
	
	var test = {};
	
	for y in range(-10, 10):
		test[y] = {};
		for x in range(-10, 10):
			test[y][x] = [1,2,3]
	
	
	var yS = ceil(test.size() / float(CHUNK_SIZE));
	var xS = ceil(test[0].size() / float(CHUNK_SIZE));
	
	for y in range(yS):
		for x in range(xS):
			#print(x, " - ",y)
			pass
	
	var tX = -12
	var tY = -6
	
	var chunk = Vector2(int(floor(tX / float(CHUNK_SIZE))), int(floor(tY / float(CHUNK_SIZE))))
	var world = chunk * Vector2(CHUNK_SIZE, CHUNK_SIZE)
	
	print(chunk, " -> ", world)
	
	print(test.size())
	
	var kY = test.keys()
	kY.sort();
	
	var chunks = []
	for y in kY:
		var kX = test[y].keys()
		kX.sort();
		for x in kX:
			var cX: int = ceil(x / CHUNK_SIZE)
			var cY: int = ceil(y / CHUNK_SIZE)
			var chunkToAdd = Vector2(cX, cY);
			if !chunks.has(chunkToAdd):
				print(chunkToAdd)
				chunks.append(chunkToAdd)
	
	
#	var arr = TextureArray.new();
#	arr.create(64, 64, SIZE, Image.FORMAT_RGBA8)#, TextureLayered.FLAG_REPEAT | TextureLayered.FLAG_MIPMAPS | TextureLayered.FLAG_FILTER);
	
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
	
#	for i in range(SIZE):
#		var img = Image.new()
#		img.load("res://icon.png");
#		#var img = load("res://icon.png");
#		img.convert(Image.FORMAT_RGBA8);
#		#print(typeof(img), " ", img.get_format(), " - ", Image.FORMAT_RGBA8)
#		print(img, " ",i)
#		arr.set_layer_data(img.duplicate(), i);
	
#	var d = Directory.new()
#	d.open("res://tests/texture/");
#	if d.file_exists("type.res"):
#		d.remove("type.res");
#		print("Removed")
#	print(ResourceSaver.save("res://tests/texture/type.res", arr), " - ", arr.flags);

