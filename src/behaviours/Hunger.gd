class_name Hunger extends Behaviour

const POOP_ENTITIES = [
    preload("res://media/scenes/entities/Poop0.tscn"),
    preload("res://media/scenes/entities/Poop1.tscn"),
    preload("res://media/scenes/entities/Poop2.tscn"),
    preload("res://media/scenes/entities/Poop3.tscn"),
]
const HUNGER_TICKS_IN_SECONDS := 3
const HUNGER_START := 10 # Start the dino a little hungry
const HUNGER_MAX := 60 # Fullness trying 60 to represent 1 minute
const HUNGER_EMOTION_DAMAGE_THRESHOLD := 0
const HUNGER_DEATH_THRESHOLD := -20
const EMOTION_TICKS_IN_SECONDS := 10
const HUNGER_EMOTION = Vector2(-0.2, -0.1)
const FEED_EMOTION = Vector2(0.2, 0.2)
const POOP_AT = 10

var hunger_timer : Timer
var emotional_impact_timer : Timer

func _ready() -> void:
    Globals.hunger = HUNGER_START
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

    # This should probably just be it's own behavoir
    # Increase poop number to represent bowels fill with waste
    Globals.poop += 1

    if Globals.poop >= POOP_AT:
        if Globals.creature._state == Enums.EntityStates.Idle:
            Globals.poop = 0
            # Poop code goes here
            var index = Globals.random.randi() % POOP_ENTITIES.size()
            var fresh_poop = Globals.spawn_entity(POOP_ENTITIES[index], entity.position)
            Globals.entities_node.move_child(fresh_poop, 0)
            var intensity = Globals.random.randi_range(1, 4)
            if index == 3:
                intensity = 8
            Globals.screen_shake.shake(intensity, 0.1, 2)

            var points = Globals.astar.get_points()
            var start_point = Globals.creature_closest_point
            var destination_point : int = points[Globals.random.randi() % points.size()]
            var path = Globals.astar.get_point_path(start_point, destination_point)

            var speed = LDTK.get_behaviour_meta(entity, "Roaming", "Speed", 16.0)
            entity.set_meta("moving_path", path)
            entity.set_meta("moving_speed", speed)
            entity.change_state(Enums.EntityStates.Moving)

func _emotional_impact_timeout() -> void:
    if Globals.hunger < HUNGER_EMOTION_DAMAGE_THRESHOLD:
        Globals.add_emotion(HUNGER_EMOTION, "Pet")
        # print("[HUNGER] emotional impact: ", Globals.emotion)

    if Globals.hunger < HUNGER_DEATH_THRESHOLD:
        if entity._state == Enums.EntityStates.Idle:
            entity.set_meta("dead_animation", "dead_hunger")
            entity.change_state(Enums.EntityStates.Dead)
            Audio.play_sound(Globals.SFX.DEATH)

func _entity_fed(amount: int) -> void:
    Globals.hunger += amount
    Globals.add_emotion(FEED_EMOTION, "Feed")
    entity.set_meta("bark_animation", "eat_large")
    entity.change_state(Enums.EntityStates.Bark)
    Pet.emote(entity, 26)
    Audio.play_sound(Globals.SFX.EAT)
