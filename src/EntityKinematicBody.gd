extends KinematicBody2D

enum Source {TREE}

var source : int # Override on child

signal clicked(area)
signal entered(area)
signal exited(area)


func _stimulus_clicked(area: Area2D) -> void:
    print("Clicked, Source: ", area.source, "Stimulus: ", area.stimulus)


func _stimulus_entered(area: Area2D) -> void:
    print("Entered, Source: ", area.source, "Stimulus: ", area.stimulus)


func _stimulus_exited(area: Area2D) -> void:
    print("Exited, Source: ", area.source, "Stimulus: ", area.stimulus)
