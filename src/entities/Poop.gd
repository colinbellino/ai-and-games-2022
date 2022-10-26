extends Node2D

func _ready() -> void:
    add_to_group("poops")
    Audio.play_sound(Globals.SFX.POOP)

func interact(_interaction_type: int) -> void:
    queue_free()
