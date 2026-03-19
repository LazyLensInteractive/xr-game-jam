#good luck figuring this out its a frankinstine of docs yt vids sprinkled in with a little stupidity

extends Node
@export var world_type = false #true if in the past false if in present
@export var rewind_text: Label3D
@export var laser: XRToolsFunctionPointer
@export var lasercollision: CollisionShape3D
@export var player: XROrigin3D
@export var distance_to_auto_stop = 2
@export var shader: MeshInstance3D
@export var level_holder: Node
@export var grapple_pos: StaticBody3D
@export var end_pickable: XRToolsPickable #the mesh of the end level object used to alter its material for an effect
var total_rewinds_used = 0
var grapple_equiped = false
var grapple_button = false #checks if grapple is deployed
var trigger_touch_held = false
var trigger_held = false
var current_target = null
var grappling = false
var grapple_point_position = Vector3.ZERO
var speed = 20
var current_level_id = 0
var is_loading_level = false
var end_obj = null
func _ready() -> void:
	_set_group_active("past_world", false)
	_set_group_active("present_world", true)
	
	
	#shader.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if trigger_held and current_target != null and not grappling:
		grappling = true
		grapple_point_position = current_target.global_position
	if grappling:
		var direction = grapple_point_position - player.global_position
		var distance = direction.length()
		
		if distance > distance_to_auto_stop:
			direction = direction.normalized()
			player.global_position += direction * speed * delta
		else:
			grappling = false
	if not trigger_held:
		grappling = false
	
	
	

func _on_xr_controller_3d_2_button_pressed(name: String) -> void: #right hand
	if name == "trigger_touch": 
		lasercollision.disabled = false
		laser.show_laser = 1
		trigger_touch_held = true
	if name == "trigger_click":
		trigger_held = true
	
	
func _on_xr_controller_3d_2_button_released(name: String) -> void:
	if name == "trigger_touch":
		lasercollision.disabled = true
		laser.show_laser = 0
		trigger_touch_held = false
	if name == "trigger_click":
		trigger_held = false


func _on_xr_controller_3d_button_pressed(name: String) -> void: #left hand
	if name == "ax_button":
		world_type = !world_type
		if world_type:
			total_rewinds_used += 1
			rewind_text.text = str(total_rewinds_used) + "/100 used"
			_set_group_active("past_world", true)
			_set_group_active("present_world", false)
			shader.visible = true
			grappling = false
		else:
			_set_group_active("past_world", false)
			_set_group_active("present_world", true)
			shader.visible = false
			grappling = false
func _set_group_active(group_name: String, state: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		if node is Node3D:
			node.visible = state
		for shape in node.get_children():
			if shape is CollisionShape3D:
				shape.disabled = !state
			if shape.get_child_count() > 0:
				_disable_collision(shape, !state)


func _disable_collision(parent: Node, disable: bool):
	for child in parent.get_children():
		if child is CollisionShape3D:
			child.disabled = disable
		elif child.get_child_count() > 0:
			_disable_collision(child, disable)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("grapple_points"):
		current_target = body
		
	
		
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("grapple_points"):
		current_target = null
		
var levels = {
	1: {
		"path": "res://puzzle_1.tscn",
		"grapple_pos": Vector3(32, 1, 13),
		"end_pos": Vector3(12.667, 0.853, 3.332),
		"player_pos": Vector3(2.5, 1.45, 3.557)
	},

	2: {
		"path": "res://rooftops_2.tscn",
		"grapple_pos": Vector3(32, 2, 10.85),
		"end_pos": Vector3(0.7, 2, 16.8),
		"player_pos": Vector3(2.5, 1.45, 3.557)
	},

	4: {
		"path": "res://rooftops_2.tscn",
		"grapple_pos": Vector3(1, 1, 1),
		"end_pos": Vector3(2, 2, 2),
		"player_pos": Vector3(2.5, 1.45, 3.557)
	}
}
func load_level(id):
	current_level_id = id
	for child in level_holder.get_children():
		child.queue_free()
	var data = levels[id]
	var level_scene = load(data["path"])
	var level_instance = level_scene.instantiate()
	level_holder.add_child(level_instance)
	end_obj.drop()
	await get_tree().process_frame
	end_obj.drop()
	await get_tree().physics_frame
	end_obj.drop()
	await get_tree().physics_frame
	end_obj.drop()
	end_obj.drop()
	end_obj.drop()
	grapple_pos.global_position = data["grapple_pos"]
	end_obj.drop()
	end_obj.drop()
	end_pickable.global_transform.origin = data["end_pos"]
	player.global_position = data["player_pos"]
	end_obj.drop()
	await get_tree().process_frame
	_set_group_active("past_world", false)
	_set_group_active("present_world", true)
	shader.visible = false
	is_loading_level = false
	end_obj.enabled = true
	
# this is painful im sorry if you see this
func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	if is_loading_level:
		return
	pickable.drop()
	pickable.enabled = false
	pickable.drop()
	end_obj = pickable
	pickable.drop()
	is_loading_level = true
	pickable.drop()
	load_level(current_level_id + 1)
	pickable.drop()
