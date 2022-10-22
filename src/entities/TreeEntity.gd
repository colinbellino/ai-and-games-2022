extends EntityNode


func clicked() -> void:
    print("Clicked: ", self)


func stimulus_entered(area: EntityArea2D) -> void:
    print("Entered, Source: ", area.source, "Stimulus: ", area.stimulus)


func stimulus_exited(area: EntityArea2D) -> void:
    print("Exited, Source: ", area.source, "Stimulus: ", area.stimulus)