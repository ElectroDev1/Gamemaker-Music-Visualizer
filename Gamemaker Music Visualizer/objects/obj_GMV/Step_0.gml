/// @description Editor logic

if(!OnAudio){   //If no sprite has been set
	
	window_set_caption("Gamemaker Music Visualizer");
	
	var _roof = 15+string_height("M")*2;

	//Select mode
	if(device_mouse_y(0)>_roof)&&(mouse_check_button_pressed(mb_left)){
	
	   if(device_mouse_x(0)<room_width/2){ //New song
		   
		  globalfile = get_open_filename("*.ogg","");	
		  SelectMode=0;
		  AnswerWait = Questions.new_file;
			 
	   }else{ //Select from .ini file
		   ini_open("musicdata.ini")
			   
			   var _count = ini_read_real(blacklist,"count",0);
			   
			   for(var a=0; a<_count; a++){
				   musiclist[a] = ini_read_string(blacklist,"name_"+string(a),"No name found");
			   }
			   
			   ini_close();
			  
			   OnAudio=2;
			   window_set_cursor(cr_default);
	   }
	
	}
	
	//We got a file
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
	
}else if(OnAudio==1){
	
	if(audio_is_playing(global.stream)){

	   if(audio_sound_get_track_position(global.currentstream)>=global.loopend)&&(global.loopend>=0)&&(useloops){
		  if(global.loopstart>=0){ audio_sound_set_track_position(global.currentstream,global.loopstart); }   
	   }
	
	}
	
}