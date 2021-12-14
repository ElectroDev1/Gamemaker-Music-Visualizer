/// @description Editor logic
if(RPC){
	
np_initdiscord("920349022881988669", 0, 0);
np_setpresence_timestamps(ex, 0, 1);
np_setpresence(state, details, "gmv", "");
np_update();

}else{np_clearpresence()}

if(!OnAudio){//If no audio has been selected
	
	window_set_caption(windowName+" - Waiting for a song");
	
	details="Loading a song";
	
	var _roof = 15+string_height("M")*2+70;

	//Buttons
	if(device_mouse_y(0)>_roof)&&(mouse_check_button_pressed(mb_left)){
	
	   if(device_mouse_x(0)<room_width/2){//New song
		   
		  globalfile = get_open_filename("*.ogg","");	
		  SelectMode=0;
		  AnswerWait = Questions.new_file;
			 
	   }else{ //Select from .ini file
		   
		   //Reload list
		   ini_open("musicdata.ini")
			   
			   var _count = ini_read_real(blacklist,"count",0);
			   
			   for(var a=0; a<_count; a++){
				   musiclist[a] = ini_read_string(blacklist,"name_"+string(a),"No name found");
			   }
			   
		   ini_close();
			   
		   //Go to the list
		   OnAudio=2;
		   window_set_cursor(cr_default);
			   
	   }
	
	}
	
	//If a file has been selected and we're waiting for one
	if(globalfile!="")&&(checkfile){
	   
	   checkfile=0;
	   
	   switch(SelectMode){
		   
		      case 0: //Load new song
			   
			   msg=get_string_async("Save song name as","");
			   AnswerWait = Questions.new_file;
			   show_debug_message("Selected new file at path '"+string(globalfile)+"', waiting for name");
			   
			  break;
			  
	   }
	   
	}
	
}else if(OnAudio==1){//Editor
	
	window_set_caption(windowName+" - Editing song '"+string(filename)+"'");
	
	details="Editing song '"+string(filename)+"'";
	
	//Loop track at loop points
	if(audio_is_playing(global.stream)){

	   if(audio_sound_get_track_position(global.currentstream)>=global.loopend)&&(global.loopend>=0)&&(useloops){
		  if(global.loopstart>=0){ audio_sound_set_track_position(global.currentstream,global.loopstart); }   
	   }
	
	}
	
	audio_sound_gain(global.currentstream,Volume,1);
	
}else if(OnAudio=2){//Loaded songs list

    window_set_caption(windowName+" - Choosing from loaded songs");
	
	details="Choosing a loaded song";

}