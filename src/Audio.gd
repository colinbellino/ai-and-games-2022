class_name Audio

static func play_sound(id: int, position: Vector3 = Vector3.ZERO, loop: bool = false) -> void:
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (sound): %s" % [id])
    var stream : AudioStream = Globals.audio_sounds[id]
    if stream is AudioStreamOGGVorbis or stream is AudioStreamMP3:
        stream.loop = loop
    # if stream is AudioStreamSample and loop:
    #     print("LOOOPINGGGGGGG")
        # stream.set_loop_mode(AudioStreamSample.LOOP_FORWARD)
    Globals.audio_player_sound.stream = stream
    Globals.audio_player_sound.play()

static func play_sound_random(ids: PoolIntArray, position: Vector3 = Vector3.ZERO, loop: bool = false) -> void:
    var id := randi() % ids.size()
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (sound_random): %s" % [id])
    play_sound(id, position, loop)

static func stop_sound() -> void:
    Globals.audio_player_sound.stop()

static func play_music(id: int, loop: bool = true) -> void:
    assert(Globals.audio_sounds.has(id), "[Audio] Stream not found (music): %s" % [id])
    var stream : AudioStream = Globals.audio_musics[id]
    stream.set_loop(loop)
    Globals.audio_player_sound.stream = stream
    if Globals.audio_player_music.playing:
        Globals.audio_player_music.stop()
    Globals.audio_player_music.stream = stream
    Globals.audio_player_music.play()
