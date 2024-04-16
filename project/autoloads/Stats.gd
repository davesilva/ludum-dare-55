extends Node


export(int) var score = 0 setget on_score_set


func  _ready() -> void:
	GlobalSignals.connect("score_incremented", self, "_increment_score")

func on_score_set(value: int) -> void:
	score = value
	GlobalSignals.emit_signal("score_updated", score)

func _increment_score(value: int) -> void:
	score = score + value
