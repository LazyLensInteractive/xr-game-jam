extends Node3D
@onready var rigid_body_3d: RigidBody3D = $Persist/RigidBody3D
@onready var wall: StaticBody3D = $Persist/wall


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMananger._set_group_active("past_world", false)
	GameMananger._set_group_active("present_world", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_static_body_3d_11_body_entered(body: Node3D) -> void:
	if body.is_in_group("puzzle_ball"):
		wall.visible = false
		wall.collision_layer = 0
		wall.collision_mask = 0


func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	rigid_body_3d.constant_force = Vector3(0.2, 5, 0)


func _on_pickable_object_picked_up(pickable: Variant) -> void:
	rigid_body_3d.constant_force = Vector3(0.2, 5, 0)
