extends Node

@onready var se_player: AudioStreamPlayer = $SEPlayer
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

func play_se(audio_path: String):
	var audio: AudioStream = load(audio_path)
	if audio:
		se_player.stream = audio
		se_player.play()

func play_bgm(audio_path: String):
	var audio: AudioStream = load(audio_path)
	if audio:
		audio.loop = true
		bgm_player.stream = audio
		bgm_player.play()
