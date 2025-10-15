extends Container

@export var terrain: TTerrain

@onready var tags: Label = $TagLabel
@onready var values: Label = $ValuesLabel

var prev_lods: int = 1

func _process(_delta: float) -> void:
	var fps: int = int(Performance.get_monitor(Performance.TIME_FPS))
	var objects: int = int(Performance.get_monitor(Performance.OBJECT_COUNT))
	var rendered_objects: int = int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
	var memory: int = int(Performance.get_monitor(Performance.MEMORY_STATIC))
	var draw_calls: int = int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	var vmemory: int = int(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
	var lods: int = terrain.info_get_lod_levels()
	var chunks: int = terrain.info_get_selected_nodes_count()

	if lods != prev_lods:
		var tags_text: String = "FPS:\nObjects:\nRendered objects:\nMemory:\nDraw calls:\nVideo Memory:\nLOD levels:\nDisplayed Chunks:"
		for i in lods:
			var string: String = "\nLOD%d Chunks:" % i
			tags_text += string
		tags.text = tags_text
		prev_lods = lods

	var values_text: String = "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d" % [fps, objects, rendered_objects, memory, draw_calls, vmemory, lods, chunks]

	for i in lods:
		var string: String = "\n%d" % terrain.info_get_lod_nodes_count(i)
		values_text += string

	values.text = values_text
