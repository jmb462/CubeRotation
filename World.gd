extends Spatial

var from_quat : Quat
var to_quat : Quat

onready var tween = $Tween
onready var cube : Spatial = $Cube
onready var mesh : MeshInstance = $Cube/Mesh

func _process(_delta : float) -> void:
	if not tween.is_active():
		if Input.is_action_pressed("ui_left"):
			start_rotation(Vector3(0.0,0,1.0), "translation:x", cube.translation.x-1)
		elif Input.is_action_pressed("ui_right"):
			start_rotation(Vector3(0.0,0,-1.0), "translation:x", cube.translation.x+1)
		elif Input.is_action_pressed("ui_up"):
			start_rotation(Vector3(-1.0,0,0.0), "translation:z", cube.translation.z-1)
		elif Input.is_action_pressed("ui_down"):
			start_rotation(Vector3(1.0,0,0.0), "translation:z", cube.translation.z+1)

func start_rotation(axis : Vector3, target_translation : String, dest_translation : float, duration : float = 0.5):
	from_quat = Quat(mesh.transform.basis)
	to_quat = Quat(mesh.transform.basis.rotated(axis, PI/2.0).orthonormalized())
	tween.interpolate_method(self, "rotation_lerp", 0.0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_method(self, "height", 0.0, PI, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(cube, target_translation, null, dest_translation, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func rotation_lerp(step : float) -> void:
	mesh.transform.basis = Basis(from_quat.slerp(to_quat, step))

func height(step : float) -> void:
	cube.translation.y = sin(step) / 10.0
