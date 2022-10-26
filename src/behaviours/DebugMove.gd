class_name DebugMove extends Behaviour

func _ready() -> void:
    entity.connect("state_entered", self, "entity_state_entered")

func _exit_tree() -> void:
    entity.disconnect("state_entered", self, "entity_state_entered")

func _process(_delta: float) -> void:

    if Input.is_action_just_released("mouse_left"):
        var start_point := Globals.astar.get_closest_point(Globals.creature.position / Globals.SPRITE_SIZE)
        # var start := Globals.astar.get_point_position(start_point)
        var destination_point := Globals.mouse_closest_point
        # var destination := Globals.astar.get_point_position(destination_point)
        var path = Globals.astar.get_point_path(start_point, destination_point)

        var speed = LDTK.get_behaviour_meta(entity, "Roaming", "Speed", 16.0)
        entity.set_meta("moving_path", path)
        entity.set_meta("moving_speed", speed)
        entity.change_state(Enums.EntityStates.Moving)

func entity_state_entered(state: int) -> void:
    print("entity_state_entered: ", [state])
