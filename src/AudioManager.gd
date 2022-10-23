extends Node

var _music_player : AudioStreamPlayer = AudioStreamPlayer.new()

enum MUSIC { MENU, CALM, ACTIVE }
enum SFX { WALK }

const _music_menu : String = "res://media/audio/ui/menu.ogg"
const _music_calm_1 : String = "res://media/audio/music/Isolation-calm-1.ogg"
const _music_active : String = "res://media/audio/music/Isolation-active.ogg"

func _ready():
    _music_player.bus = "Music"

func play_music( music: int ) -> void:
    var stream = null

    if music == MUSIC.MENU:
        stream = load(_music_menu)
    elif music == MUSIC.CALM:
        stream = load(_music_calm_1)
    elif music == MUSIC.ACTIVE:
        stream = load(_music_active)

    if stream != null:
        print("Stream not null")
        stream.set_loop(true)
        if _music_player.playing:
            _music_player.stop()
        _music_player.stream = stream
        _music_player.play()




