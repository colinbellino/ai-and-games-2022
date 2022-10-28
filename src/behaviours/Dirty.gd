class_name Poop extends Behaviour

const CLEAN_POOP_MOD = Vector2(0.1, 0.2)

func _ready() -> void:
    yield(get_tree(), "idle_frame")
    entity.connect("interacted", self, "entity_interacted")
    entity.connect("area_entered", self, "entity_area_entered")
    entity.connect("area_exited", self, "entity_area_exited")

    entity.add_to_group("poops")

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")
    entity.disconnect("area_entered", self, "entity_area_entered")
    entity.disconnect("area_exited", self, "entity_area_exited")

func entity_interacted(_interaction_type: int) -> void:
    Globals.add_emotion(CLEAN_POOP_MOD, "Clean poop")
    Audio.play_sound(Globals.SFX.SWISH)
    Globals.set_cursor(Globals.CURSORS.DEFAULT)
    Globals.despawn_entity(entity)

func entity_area_entered(_area: Area2D) -> void:
    Globals.set_cursor(Globals.CURSORS.CLEAN)

func entity_area_exited(_area: Area2D) -> void:
    Globals.set_cursor(Globals.CURSORS.DEFAULT)
