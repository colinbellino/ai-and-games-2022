class_name Bark extends Behaviour

const BARK_DELAY_MIN_IN_MS : int = 2000
const BARK_DELAY_MAX_IN_MS : int = 8000
const EMOTION_DEATH_THRESHOLD : int = -20

var next_bark : int

func _ready() -> void:
    next_bark = Globals.time_elapsed + Globals.random.randi_range(BARK_DELAY_MIN_IN_MS, BARK_DELAY_MAX_IN_MS)
    entity.connect("state_entered", self, "entity_state_entered")

func _exit_tree() -> void:
    entity.disconnect("state_entered", self, "entity_state_entered")

func _process(_delta: float) -> void:
    if entity._state == Enums.EntityStates.Idle:
        if Globals.time_elapsed > next_bark:
            if Globals.emotion < EMOTION_DEATH_THRESHOLD:
                entity.set_meta("dead_animation", "dead_leave")
                entity.change_state(Enums.EntityStates.Dead)
            # Live, laugh, love very inspirational
            elif Globals.emotion < -5: # Sad
                entity.set_meta("bark_animation", "cry")
                entity.change_state(Enums.EntityStates.Bark)
            elif Globals.emotion > 5: # Happy
                entity.set_meta("bark_animation", "laugh")
                entity.change_state(Enums.EntityStates.Bark)
            else: # Neutral
                var random_number = Globals.random.randi_range(0, 30)
                if random_number > 20:
                    entity.set_meta("bark_animation", "bored")
                    entity.change_state(Enums.EntityStates.Bark)
                elif random_number > 10:
                    entity.set_meta("bark_animation", "asleep")
                    entity.change_state(Enums.EntityStates.Bark)
                else:
                    var points := Globals.astar.get_points()
                    var start_point := Globals.creature_closest_point
                    var destination_point : int = points[Globals.random.randi() % points.size()]
                    var path = Globals.astar.get_point_path(start_point, destination_point)

                    var speed = LDTK.get_behaviour_meta(entity, "Roaming", "Speed", 16.0)
                    entity.set_meta("moving_path", path)
                    entity.set_meta("moving_speed", speed)
                    entity.change_state(Enums.EntityStates.Moving)

func entity_state_entered(state: int) -> void:
    if state == Enums.EntityStates.Idle:
        next_bark = Globals.time_elapsed + Globals.random.randi_range(BARK_DELAY_MIN_IN_MS, BARK_DELAY_MAX_IN_MS)
