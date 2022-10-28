class_name Pet extends Behaviour

const PET_EMOTION_MOD = Vector2(0.1, 0.1)

var last_interaction : float
var cooldown_in_ms : int = 1500

func _ready() -> void:
    entity.connect("interacted", self, "entity_interacted")
    entity.sprite_emote.visible = true
    entity.sprite_emote.modulate.a8 = 0

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")

func entity_interacted(interaction_type: int) -> void:
    # Maybe later we want to queue the emotion changes, but for now a cooldown will suffice
    if Globals.settings.debug_skip_cooldowns == false && Globals.time_elapsed < last_interaction + cooldown_in_ms:
        return

    if interaction_type == 0 && entity._state == Enums.EntityStates.Idle:
        Globals.add_emotion(PET_EMOTION_MOD, "Pet")
        Audio.play_sound(Globals.SFX.LAUGH, entity.position)
        emote(entity, 7)
    # elif interaction_type == 1:
    #     Globals.emotion -= 1
    #     emote(entity, 2)

    last_interaction = Globals.time_elapsed

static func emote(entity: Entity, index: int) -> void:
    var sprite_size := 16
    var grid_size := 5
    var x := index % grid_size
    var y := index / grid_size
    entity.sprite_emote.region_rect.position.x = x * sprite_size
    entity.sprite_emote.region_rect.position.y = y * sprite_size

    var original_position := entity.sprite_emote.position

    var tween := entity.create_tween()
    tween.tween_property(entity.sprite_emote, "modulate:a", 1.0, 0.1)
    yield(tween, "finished")

    tween = entity.create_tween().set_loops(2)
    tween.tween_property(entity.sprite_emote, "position:y", original_position.y + -2.0, 0.25)
    tween.tween_property(entity.sprite_emote, "position:y", original_position.y, 0.25)
    yield(tween, "finished")

    tween = entity.create_tween()
    tween.tween_property(entity.sprite_emote, "modulate:a", 0.0, 0.1)
    yield(tween, "finished")
