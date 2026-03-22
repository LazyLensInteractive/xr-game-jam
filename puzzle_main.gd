extends Node3D
var current_count = 0 # Starting at 0 is usually safer math!
@export var static_body_3d_2: StaticBody3D
@export var collision_shape_3d: CollisionShape3D
@export var collector_area: Area3D # Drag your Area3D here in the Inspector!

func _process(_delta: float) -> void:
	var overlapping_bodies = collector_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("orb") and not body.is_queued_for_deletion():
			current_count += 1
			body.queue_free()

	if current_count >= 3:
		if static_body_3d_2:
			static_body_3d_2.visible = false
		if collision_shape_3d:
			collision_shape_3d.disabled = true
