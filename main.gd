extends Node3D
@onready var mat = $FloatyOrb/MeshInstance3D.get_active_material(0)

signal xr_initialized

var xr_interface: XRInterface
var glitch_speed = 0.67
var timer = 0.0
var glitch_value = 0.5
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_initialized.emit()

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
func _process(delta: float) -> void:
	timer += delta
	if timer >= glitch_speed:
		timer -= glitch_speed
		glitch_value = randf_range(0.3, 1.0)

	var current = mat.get_shader_parameter("voxel_size")
	var new_val = lerp(current, glitch_value, delta * 10)
	mat.set_shader_parameter("voxel_size", new_val)
