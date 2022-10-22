class_name Save

const settings_path : String = "user://settings.tres"

static func read_settings() -> GameSettings:
    var settings : GameSettings
    if ResourceLoader.exists(settings_path):
        settings = ResourceLoader.load(settings_path) as GameSettings
        print("[Save] Settings read from file.")
    else:
        print("[Save] Settings couldn't be read from file, creating default.")
        settings = GameSettings.new()
        write_settings(settings)
    return settings

static func write_settings(data: GameSettings) -> void:
    var result = ResourceSaver.save(settings_path, data)
    if result == OK:
        print("[Save] Settings written to file.")
    else:
        print("[Save] Settings couldn't be written to file: ", result)
