/// @description Free the song
if(!audio_exists(global.stream)){ audio_destroy_stream(global.stream); }