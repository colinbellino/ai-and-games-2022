class_name Bark extends Behaviour

var timer_start : int
var sleep_delay_in_ms : int = 5000

const EMOTION_DEATH_THRESHOLD := -20

func _ready() -> void:
    entity.connect("state_entered", self, "entity_state_entered")

func _exit_tree() -> void:
    entity.disconnect("state_entered", self, "entity_state_entered")

func _process(_delta: float) -> void:
    if entity._state == Enums.EntityStates.Idle:
        if OS.get_ticks_msec() >= timer_start + sleep_delay_in_ms:
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
                entity.set_meta("bark_animation", "bored")
                entity.change_state(Enums.EntityStates.Bark)

func entity_state_entered(state: int) -> void:
    if state == Enums.EntityStates.Idle:
        timer_start = OS.get_ticks_msec()
