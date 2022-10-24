class_name FoodSource extends Behaviour

var last_interaction : int
var cooldown_in_ms : int = 1500

func _ready() -> void:
    entity.connect("interacted", self, "entity_interacted")

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")

func entity_interacted(interaction_type: int) -> void:
    if Globals.settings.debug_skip_cooldowns == false && OS.get_ticks_msec() < last_interaction + cooldown_in_ms:
        return

    if interaction_type == 0:
        var amount : int = LDTK.get_behaviour_meta(entity, "FoodSource", "Amount", 10)
        Audio.play_sound(Globals.SFX.BUTTON_CLICK_1)
        Globals.creature.emit_signal("fed", amount)

    last_interaction = OS.get_ticks_msec()
