extends Node
# Application
# An autoload that holds onto the Game, Session and Round
# as well as other relevant application-level information

var game_instance = null

func set_game(game: Game):
	game_instance = game

func game() -> Game:
	return game_instance
