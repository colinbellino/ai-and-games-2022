class_name Hunger extends Behaviour

const HUNGER_TICKS_IN_SECONDS := 3
const HUNTER_START := 10 # Start the dino a little hungry
const HUNTER_MAX := 60 # Fullness trying 60 to represent 1 minute
const HUNTER_EMOTION_DAMAGE_THRESHOLD := 0
const HUNGER_DEATH_THRESHOLD := -20
const EMOTION_TICKS_IN_SECONDS := 10

var hunger_timer : Timer
var emotional_impact_timer : Timer

func _ready() -> void:
    Globals.hunger = HUNTER_START

    entity.connect("fed", self, "_entity_fed")

    hunger_timer = Timer.new()
    add_child(hunger_timer)
    hunger_timer.connect("timeout", self, "_hunger_timeout")
    hunger_timer.start(HUNGER_TICKS_IN_SECONDS)

    # We might want something more global where we have
    # a number that changes based on factors that
    # will hit emotion at specific intervals
    emotional_impact_timer = Timer.new()
    add_child(emotional_impact_timer)
    emotional_impact_timer.connect("timeout", self, "_emotional_impact_timeout")
    emotional_impact_timer.start(EMOTION_TICKS_IN_SECONDS)

func _exit_tree() -> void:
    entity.disconnect("fed", self, "_entity_fed")
    remove_child(hunger_timer)
    remove_child(emotional_impact_timer)

func _hunger_timeout() -> void:
    Globals.hunger -= 1
    # print("[HUNGER] ticked: ", Globals.hunger)

func _emotional_impact_timeout() -> void:
    if Globals.hunger < HUNTER_EMOTION_DAMAGE_THRESHOLD:
        Globals.emotion -= 1
        # print("[HUNGER] emotional impact: ", Globals.emotion)

    if Globals.hunger < HUNGER_DEATH_THRESHOLD:
        if entity._state == Enums.EntityStates.Idle:
            entity.set_meta("dead_animation", "dead_hunger")
            entity.change_state(Enums.EntityStates.Dead)

func _entity_fed(amount: int) -> void:
    Globals.hunger += amount
    Pet.emote(entity, 26)
