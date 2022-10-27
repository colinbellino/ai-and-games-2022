class_name Poop extends Behaviour

const CLEAN_POOP_MOD = Vector2(0.1, 0.2)

func _ready() -> void:
    yield(get_tree(), "idle_frame")
    entity.add_to_group("poops")
    entity.connect("interacted", self, "entity_interacted")

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")

func entity_interacted(_interaction_type: int) -> void:
    Globals.add_emotion(CLEAN_POOP_MOD, "Clean poop")
    Audio.play_sound(Globals.SFX.SWISH)
    Globals.despawn_entity(entity)
