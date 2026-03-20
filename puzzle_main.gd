extends Node3D
var current_count = 0
@onready var static_body_3d_2: StaticBody3D = $Node/StaticBody3D2
@onready var collision_shape_3d: CollisionShape3D = $Node/StaticBody3D2/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_count >= 5:
		static_body_3d_2.visible = false
		collision_shape_3d.disabled = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("orb"):
		current_count += 1
