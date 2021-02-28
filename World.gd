extends Spatial

var from_quat : Quat
var to_quat : Quat

onready var tween = $Tween
onready var cube : Spatial = $Cube
onready var mesh : MeshInstance = $Cube/Mesh

enum DIRECTION { LEFT, RIGHT, UP, DOWN }

func _process(_delta):
	if not tween.is_active():
		if Input.is_action_pressed("ui_left"):
			setup_rotation(DIRECTION.LEFT);
		if Input.is_action_pressed("ui_right"):
			setup_rotation(DIRECTION.RIGHT);
		if Input.is_action_pressed("ui_up"):
			setup_rotation(DIRECTION.UP);
		if Input.is_action_pressed("ui_down"):
			setup_rotation(DIRECTION.DOWN);

func setup_rotation(dir : int) -> void:
	match dir:
		DIRECTION.LEFT :
			start_rotation(Vector3(0.0,0,1.0), "translation:x", cube.translation.x-1)
		DIRECTION.RIGHT :
			start_rotation(Vector3(0.0,0,-1.0), "translation:x", cube.translation.x+1)
		DIRECTION.UP:
			start_rotation(Vector3(-1.0,0,0.0), "translation:z", cube.translation.z-1)
		DIRECTION.DOWN:
			start_rotation(Vector3(1.0,0,0.0), "translation:z", cube.translation.z+1)

func start_rotation(axe, target_translation, dest_translation, duration = 0.5):
	from_quat = Quat(mesh.transform.basis)
	to_quat = Quat(mesh.transform.basis.rotated(axe, PI/2.0).orthonormalized())
	tween.interpolate_method(self, "rotation_lerp", 0.0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_method(self, "height", 0.0, PI, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(cube, target_translation, null, dest_translation, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func rotation_lerp(step):
	mesh.transform.basis = Basis(from_quat.slerp(to_quat, step))

func height(step):
	cube.translation.y = sin(step) / 10.0
