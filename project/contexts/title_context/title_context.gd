extends Context
class_name TitleContext

const CONTEXT_ID = "context.title"

onready var world_root = $WorldRoot
onready var ui_root = $UIRoot

func context_id_string() -> String:
	return CONTEXT_ID
	

func _ready():
	$IntroBG.play()
	PresentationServices.ui_service().set_presentation_root(ui_root)


func _on_TitleContextUI_request_context_change(context_id):
	$IntroBG.stop()
	change_context(context_id)
