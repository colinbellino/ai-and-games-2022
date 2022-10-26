class_name DebugDraw extends Control

var font : DynamicFont

func _ready() -> void:
    font = DynamicFont.new()
    font.font_data = ResourceLoader.load(Globals.font1_path)
    font.size = 26

func _process(_delta: float) -> void:
    get_parent().visible = Globals.settings.debug_draw
    update()

func _draw() -> void:
    if Globals.settings.debug_draw == false:
        return

    var scale := Globals.SPRITE_SIZE * Globals.SCALE
    var TEXT_OFFSET := Vector2(0.3, 0.6)

    if Globals.astar != null:
        var points := Globals.astar.get_points()
        for cell_index in points:
            var cell_position := Globals.astar.get_point_position(cell_index)
            var color = Color.red
            color.a = 0.5
            draw_rect(Rect2((cell_position + Vector2(0.1, 0.1)) * scale, Vector2(0.8, 0.8) * scale),  color)
            draw_string(font, (cell_position + TEXT_OFFSET) * scale, "%s,%s" % [cell_position.x, cell_position.y], Color.white)

            var connections := Globals.astar.get_point_connections(cell_index)
            for connection_index in connections:
                var connection_position := Globals.astar.get_point_position(connection_index)
                draw_line((cell_position + Vector2(0.5, 0.5)) * scale, (connection_position + Vector2(0.5, 0.5)) * scale, Color.blue, 0.5)

    if Globals.mouse_closest_point > -1:
        var mouse_point_position := Globals.astar.get_point_position(Globals.mouse_closest_point)
        draw_rect(Rect2((mouse_point_position + Vector2(0.1, 0.1)) * scale, Vector2(0.8, 0.8) * scale),  Color.yellow)
        draw_rect(Rect2(Globals.mouse_position * scale, Vector2(10, 10)), Color.yellow)

    if Globals.creature:

        if Globals.creature_closest_point > -1:
            var creature_point_position := Globals.astar.get_point_position(Globals.creature_closest_point)
            draw_rect(Rect2((creature_point_position + Vector2(0.1, 0.1)) * scale, Vector2(0.8, 0.8) * scale),  Color.green)
            draw_rect(Rect2(Globals.creature.position * scale, Vector2(10, 10)), Color.green)

        if Globals.creature._state == Enums.EntityStates.Moving && Globals.creature.has_meta("moving_path"):
            var path : PoolVector2Array = Globals.creature.get_meta("moving_path")
            var point_position := path[path.size() - 1]
            draw_rect(Rect2((point_position + Vector2(0.1, 0.1)) * scale, Vector2(0.8, 0.8) * scale),  Color.blue)

            for index in range(1, path.size()):
                var point = path[index]
                var start = path[index-1]
                draw_line((start + Vector2(0.5, 0.5)) * scale, (point + Vector2(0.5, 0.5)) * scale, Color.blue, 5)
