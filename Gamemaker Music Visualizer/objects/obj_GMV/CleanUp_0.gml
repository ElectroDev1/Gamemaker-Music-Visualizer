/// @description Free the song memory
if(!audio_exists(global.stream)){ audio_destroy_stream(global.stream); }