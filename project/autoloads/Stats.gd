extends Node


export(int) var score = 0


func  _ready() -> void:
	GlobalSignals.connect("score_incremented", self, "_increment_score")

func _increment_score(value: int) -> void:
	score = score + value
	GlobalSignals.emit_signal("score_updated", score)
