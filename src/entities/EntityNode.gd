extends Node

class_name EntityNode

export(Globals.Source) var source : int # Set in scene inspector

# Override these functions with a child
func clicked() -> void:
    pass #print("Clicked")


func stimulus_entered(_area: EntityArea2D) -> void:
    pass #print("Entered, Source: ", area.source, "Stimulus: ", area.stimulus)
    # You could do match statements for source and stimulus
    # just use the gobals to match enum values

func stimulus_exited(_area: EntityArea2D) -> void:
    pass #print("Exited, Source: ", area.source, "Stimulus: ", area.stimulus)
    # You could do match statements for source and stimulus
    # just use the gobals to match enum values
