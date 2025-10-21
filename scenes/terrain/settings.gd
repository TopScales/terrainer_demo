extends Button

@export var terrain: TTerrain
@export var camera: Camera3D
@export var chunk_size_spin: SpinBox
@export var detailed_radius_spin: SpinBox
@export var far_slider: HSlider
@export var ratio_slider: HSlider
@export var debug_boxes_checkbox: CheckBox


func _ready() -> void:
	chunk_size_spin.value = terrain.chunk_size
	detailed_radius_spin.value = terrain.lod_detailed_chunks_radius
	far_slider.value = camera.far
	ratio_slider.value = terrain.lod_distance_ratio
	debug_boxes_checkbox.button_pressed = terrain.debug_nodes_aabb_enabled


func _on_toggled(toggled_on: bool) -> void:
	$PanelContainer.visible = toggled_on


func _on_chunk_size_spin_box_value_changed(value: float) -> void:
	terrain.chunk_size = int(value)
	chunk_size_spin.value = terrain.chunk_size


func _on_detailed_radius_spin_box_value_changed(value: float) -> void:
	terrain.lod_detailed_chunks_radius = int(value)
	detailed_radius_spin.value = terrain.lod_detailed_chunks_radius


func _on_far_slider_value_changed(value: float) -> void:
	camera.far = value


func _on_debug_boxes_check_box_toggled(toggled_on: bool) -> void:
	terrain.debug_nodes_aabb_enabled = toggled_on


func _on_ratio_slider_value_changed(value: float) -> void:
	terrain.lod_distance_ratio = value
