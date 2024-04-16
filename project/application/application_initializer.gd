extends Node
class_name ApplicationInitializer

export (PackedScene) var title_context_scene
export (PackedScene) var game_context_scene

onready var context_root = $ContextRoot
onready var game = $Game

func _ready():
	Application.set_game(game)
	
	var context_scene_dictionary = { 
		TitleContext.CONTEXT_ID : title_context_scene, 
		GameContext.CONTEXT_ID : game_context_scene
	}

	PresentationServices.context_service().context_root = context_root
	PresentationServices.context_service().load_with_context_scene_dictionary(context_scene_dictionary)
	PresentationServices.context_service().handle_transition_request(TitleContext.CONTEXT_ID)
