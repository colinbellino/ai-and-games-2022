class_name Poop extends Behaviour

const CLEAN_POOP_MOD = Vector2(0.1, 0.2)

func _ready() -> void:
    entity.add_to_group("poops")
    Audio.play_sound(Globals.SFX.POOP)

func interact(_interaction_type: int) -> void:
    Globals.add_emotion(CLEAN_POOP_MOD, "Clean poop")
    queue_free()
