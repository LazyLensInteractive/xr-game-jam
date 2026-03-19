extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMananger._set_group_active("past_world", false)
	GameMananger._set_group_active("present_world", true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
