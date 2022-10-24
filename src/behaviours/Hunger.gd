class_name Hunger extends Behaviour

const STARTING_HUNGER := 20 # Start the dino a little hungry
const MAX_HUNGER := 60 # Fullness trying 60 to represent 1 minute
const HUNGER_TICKS := 3 # Hunger ticks every
const EMOTION_TICKS := 5 # Check for emotional impact every
const EMOTIONAL_THRESHOLD := 10 # Threshold for emotional impact

func _ready() -> void:
    Globals.hunger = STARTING_HUNGER

    var hunger_timer = Timer.new()
    add_child(hunger_timer)
    hunger_timer.connect("timeout", self, "_hunger_timeout")
    hunger_timer.one_shot = false # loop timer
    hunger_timer.start(HUNGER_TICKS)

    # We might want something more global where we have
    # a number that changes based on factors that
    # will hit emotion at specific intrivals
    var emotional_impact_timer = Timer.new()
    add_child(emotional_impact_timer)
    emotional_impact_timer.connect("timeout", self, "_emotional_impact_timeout")
    emotional_impact_timer.one_shot = false # loop timer
    emotional_impact_timer.start(EMOTION_TICKS)

func _hunger_timeout():
    Globals.hunger -= 1
    print("[HUNGER] ticked: ", Globals.hunger)

func _emotional_impact_timeout():
    if Globals.hunger <= EMOTIONAL_THRESHOLD:
        Globals.emotion -= 1
        print("[HUNGER] emotional impact: ", Globals.emotion)
