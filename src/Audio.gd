class_name Audio

static func play_sound(id: int, _position: Vector3 = Vector3.ZERO) -> void:
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (sound): %s" % [id])
    var stream : AudioStream = Globals.audio_sounds[id]
    Globals.audio_player_sound.stream = stream
    Globals.audio_player_sound.play()

static func play_sound_random(ids: PoolIntArray, _position: Vector3 = Vector3.ZERO) -> void:
    var id := randi() % ids.size()
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (sound_random): %s" % [id])
    var stream : AudioStream = Globals.audio_sounds[id]
    Globals.audio_player_sound.stream = stream
    Globals.audio_player_sound.play()

static func play_music(id: int, loop: bool = true) -> void:
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (music): %s" % [id])
    var stream : AudioStream = Globals.audio_musics[id]
    stream.set_loop(loop)
    Globals.audio_player_sound.stream = stream
    if Globals.audio_player_music.playing:
        Globals.audio_player_music.stop()
    Globals.audio_player_music.stream = stream
    Globals.audio_player_music.play()
