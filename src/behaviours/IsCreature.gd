class_name IsCreature extends Behaviour

const TIME_MOD = Vector2(-0.1, -0.1)
const POOP_MOD = Vector2(0.0, 0.1)


func _ready() -> void:
    assert(Globals.creature == null, "Already one creature in the world!")

    Globals.creature = entity

    var timer = Timer.new()
    add_child(timer)
    timer.connect("timeout", self, "_tick")
    timer.start(5)

func _tick():
    # Impact time on emotion
    Globals.add_emotion(TIME_MOD, "Time")

    # add poops to emotion
    var total_poops = get_tree().get_nodes_in_group("poops")

    for poop in range(total_poops.size()):
        Globals.add_emotion(POOP_MOD, "Poop")
