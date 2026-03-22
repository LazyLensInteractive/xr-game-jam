extends XRCamera3D

@export var start_text : Label3D

func _on_xr_initialized():
	start_text.hide()
