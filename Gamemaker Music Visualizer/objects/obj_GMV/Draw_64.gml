/// @description Editor menu

//Set font
draw_set_font(Font1);
draw_set_halign(fa_center);draw_set_colour(c_white);draw_set_valign(fa_top);

//Title
draw_text_transformed(room_width/2,15,"Gamemaker Music Visualizer",2,2,0);

draw_set_halign(fa_center);draw_set_valign(fa_top);

#region Start menu
if(!OnAudio){
	
	var _roof = 15+string_height("M")*2+70;
	
	draw_set_alpha(0.2);
	
	//Draw buttons
	if(device_mouse_y_to_gui(0)>_roof){ if(AnswerWait==-1){ window_set_cursor(cr_handpoint); }
	
	if(device_mouse_x_to_gui(0)<room_width/2){
	   draw_rectangle(0,_roof,room_width/2,room_height,0);	
	}
	else{
	   draw_rectangle(room_width/2,_roof,room_width,room_height,0);	
	}
	
	}else{  window_set_cursor(cr_default); }
	
	draw_set_alpha(1);
	
	//Text
	draw_set_halign(fa_left);
	
	var _pres_string = "A tool by Electro";
	
	draw_text(10,_roof-42.5,_pres_string+" - v1.1.2");
	if(mouse_in_rectangle(10-4,_roof-42.5-6,10+string_width(_pres_string)+4,_roof-42.5+string_height("E")+2)){
	  if(mouse_check_button_pressed(mb_left)){
         execute_shell_simple( "https://electrodev1.github.io/home/" );
	  }
	  
	  draw_set_alpha(0.2);
	  draw_rectangle(10-4,_roof-42.5-6,10+string_width(_pres_string)+4,_roof-42.5+string_height("E")+2,0);
	  draw_set_alpha(1);
	  draw_rectangle(10-4,_roof-42.5-6,10+string_width(_pres_string)+4,_roof-42.5+string_height("E")+2,1);
	  
	}
	
	draw_set_halign(fa_right);
	draw_text(room_width-10-58,_roof-42.5,"Discord RPC");
	
	draw_rectangle(room_width-10-48,_roof-60,room_width-10,_roof-60+48,0);
	
	if(mouse_in_rectangle(
	room_width-10-48,_roof-60,room_width-10,_roof-60+48
	)){
	  if(mouse_check_button_pressed(mb_left)){
		 RPC=!RPC; 
	  }
	}
	
	if(RPC){
	draw_set_color(c_black);
	draw_rectangle(room_width-10-48+7,_roof-60+7,room_width-10-7,_roof-60+48-7,0);
	draw_set_color(c_white);
	}
	
	draw_set_halign(fa_center);
	
	draw_text(room_width/4,room_height/2,"Click to open a\nnew .ogg file");
	
	draw_text(room_width-room_width/4,room_height/2,"Click to select a song\nfrom the data file");
	
    draw_line_width(room_width/2,_roof,room_width/2,room_height,3);
    draw_line_width(0,_roof,room_width,_roof,3);

}
#endregion

#region Select song
else if(OnAudio==2){ //List of pre existing songs
	
	var _roof = 15+string_height("M")*4;
	
	draw_text_transformed(room_width/2,15+string_height("M")*2+8,"Select a song",1.5,1.5,0);
	
	for(var a=0; a<array_length(musiclist); a++){
				
		var _Y = _roof+20+(string_height("M")+18)*a;
		var _str = string_replace_all(musiclist[a],".ogg","");
		
		if(mouse_in_rectangle(room_width/2-string_width(_str)/2-4,
		_Y-6,room_width/2+string_width(_str)/2+4,
		_Y+string_height(_str)+4)){
		
		draw_rectangle(room_width/2-string_width(_str)/2-4,
		_Y-6,room_width/2+string_width(_str)/2+4,
		_Y+string_height(_str)+4,1);

          if(mouse_check_button_pressed(mb_left)){ //Select song
			  scr_load_music(_str,0,1,0,1,1);
			  
			  filename=_str;
			  
			  ini_open("musicdata.ini");
			  
			  global.loopstart = ini_read_real(filename,"loopstart",-4);
			  global.loopend   = ini_read_real(filename,"loopend",-4);
			  
			  ini_close();
			  
			  alarm[0]=2;
			  
			  OnAudio=1;
			  
		  }
		
		}
	
	
	    draw_text(room_width/2,_Y,_str);	
		
	}
	
	if(!is_array(musiclist)){
	   draw_text(room_width/2,room_height/2,"No song found");	
	}
	
	var _back = draw_button_ext(4,room_height-40,mouse_check_button(mb_left),"click",
	"Back",1,2,1.5)
	
	if(_back){ OnAudio=0; }
	
}
#endregion

#region Editor
else if(OnAudio==1){
	
	//Show song name
	draw_text_transformed(room_width/2,15+string_height("M")*2+8,"Visualizing '"+string(filename)+"'",1.5,1.5,0);
	
	if(editloop!=0){
	draw_text_transformed(room_width/2,15+string_height("M")*5+12,"Press Enter to stop editing loop points\nPress Alt to type loop point time",1,1,0);
	
	   if(keyboard_check_pressed(vk_alt)){
		   if(editloop==1){
			   AnswerWait = Questions.set_ls;
			   msg = get_string_async("Set loop start at (in seconds)","");
		   }
		   if(editloop==2){
			   AnswerWait = Questions.set_le;  
			   msg = get_string_async("Set loop end at (in seconds)","");
		   }
	   }
	
	}
	
	//Draw timeline
	
	//Audio values
	var _playpos = audio_sound_get_track_position(global.currentstream);
	var _length  = audio_sound_length(global.stream);
	var _playing = audio_is_playing(global.currentstream);
	var _paused = audio_is_paused(global.currentstream);
	
	//Music player menu values, you can change the
	//position and size of the bar here
	var _W = 600;
	var _H = 40;
	var _Y = room_height/2-_H/2
	var _X = room_width/2-_W/2;
	var _pad = 8;
	
	//Change audio position
	   
	   if(mouse_in_rectangle(_X-10,_Y,_X+_W+10,_Y+_H)){
		  if(mouse_check_button(mb_left)){
         
			 var _mouse_x_in_bar = clamp(device_mouse_x_to_gui(0)-_X,0,_W);
			 var _scale = (_mouse_x_in_bar/_W);
			 audio_sound_set_track_position(global.currentstream, min(_scale*_length,audio_sound_length(global.stream)));
			  
		  }   
	   }
	
	
	var _rW = (_W/_length)*_playpos;
	
	//Calculate the rectangle's width
	if(useloops)&&(global.loopend>=0)&&(global.loopstart>=0){
	  _rW = min((_W/_length)*_playpos,(_W/_length)*global.loopend);	
	}
	
	//Borders
	draw_line_width(_X-_pad,_Y-_pad,_X-_pad,_Y+_H+_pad,2);
	draw_line_width(_X+_W+_pad,_Y-_pad,_X+_W+_pad,_Y+_H+_pad,2);
	
	draw_set_alpha(0.2);
    draw_rectangle(_X,_Y,_X+_W,_Y+_H,0);
	
	//Draw loop region
	if(global.loopstart>=0)&&(global.loopend>=0)&&(useloops){
	   draw_set_colour(c_red);
	   draw_rectangle(
	   _X+ max((_W/_length)*global.loopstart,0),_Y,
	   _X+ max((_W/_length)*global.loopend,0),_Y+_H,0);
	   draw_set_colour(c_white);
	}
	
	draw_set_alpha(1);
	
	//Draw main rectangle
    draw_rectangle(_X,_Y,_X+max(1,_rW),_Y+_H,0);
	
	//Draw loop start
	var _loopX = _X+ max((_W/_length)*global.loopstart,0);
	var _pad = 6;
	
	if(global.loopstart>=0){
	
	   var _sec = global.loopstart;
	   var _min = floor(_sec/60);
	   draw_set_color(c_white);
	   if(editloop==1){draw_set_color(c_red);
		   
		  if(mouse_in_rectangle(_X-10,_Y-80,_X+_W+10,_Y)){
			 if(mouse_check_button(mb_left)){
				
				var _mouse_x_in_bar = clamp(device_mouse_x_to_gui(0)-_X,0,_W);
			    var _scale = (_mouse_x_in_bar/_W);
			    global.loopstart = _scale*_length;
				
			 }
	      }   
		   
	   }
	   draw_triangle(_loopX,_Y-_pad,_loopX-8,_Y-28,_loopX+8,_Y-28,0);	
	   
	   if(useloops){
		  draw_set_color(c_red);
		  draw_line_width(_loopX,_Y-_pad,_loopX,_Y+_H+_pad,2);
		  draw_set_color(c_white);
	   }
	   
	   draw_set_color(c_white);
	   draw_set_halign(fa_center);draw_set_valign(fa_bottom);
	   draw_text_transformed(_loopX+10,_Y-32,
	   "L.S."+"\n"+string_replace_all( string_format(_min%60,2,0)," ","0" )+":"+string_replace_all(string_format(_sec%60,2,2)," ","0")
	   ,1,1,0);
	     
	}
	
	//Draw loop end
	var _loopX = _X+ max((_W/_length)*global.loopend,0);
	var _pad = 6;
	
	if(global.loopend>=0){
	
	   var _sec = global.loopend;
	   var _min = floor(_sec/60);
	   draw_set_color(c_white);
	   if(editloop==2){draw_set_color(c_red);
		
		  if(mouse_in_rectangle(_X-10,_Y+_H,_X+_W+10,_Y+_H+80)){
			 if(mouse_check_button(mb_left)){
			    
				var _mouse_x_in_bar = clamp(device_mouse_x_to_gui(0)-_X,0,_W);
			    var _scale = (_mouse_x_in_bar/_W);
			    global.loopend = _scale*_length;
				
			 }
	      } 
		   
	   }
	   
	   draw_triangle(_loopX,_Y+_H+_pad,_loopX-8,_Y+_H+28,_loopX+8,_Y+_H+28,0);
	   
	   if(useloops){
		  draw_set_color(c_red);
		  draw_line_width(_loopX,_Y-_pad,_loopX,_Y+_H+_pad,2);
		  draw_set_color(c_white);
	   }
	   
	   draw_set_color(c_white);
	   draw_set_halign(fa_center);draw_set_valign(fa_top);
	   draw_text_transformed(_loopX+10,_Y+_H+34,
	   "L.E."+"\n"+string_replace_all( string_format(_min%60,2,0)," ","0" )+":"+string_replace_all(string_format(_sec%60,2,2)," ","0")
	   ,1,1,0);
	   
	}
	
	if(keyboard_check_pressed(vk_enter)){ editloop=0; } //Ecit all loops
	
	//Song time
	draw_set_halign(fa_right);draw_set_valign(fa_middle);
	
	var _sec = (_playpos)
	var _min = floor(_sec/60);
	
	draw_text(_X-_pad*2,_Y+_H/2+4,string_replace_all( string_format(_min%60,2,0)," ","0" )+":"+string_replace_all(string_format(_sec%60,2,2)," ","0"));
	
	//Song length
	draw_set_halign(fa_left);
	var _sec = (_length%60);
	var _min = (_length-_sec)/60;
	
	draw_text(_X+_W+_pad*2,_Y+_H/2+4, string_replace_all( string_format(_min,2,0)," ","0" )+":"+string_replace_all(string_format(_sec,2,2)," ","0"));
	
	draw_set_halign(fa_center);draw_set_valign(fa_top);
	
	//Buttons
	
	//Back
	var _back = draw_button_ext(4,room_height-40,mouse_check_button(mb_left),"click",
	"Back",1,2,1.5)
	
	if(_back){ init_global(); 
		
		ini_open("musicdata.ini")
			   
			   var _count = ini_read_real(blacklist,"count",0);
			   
			   for(var a=0; a<_count; a++){
				   musiclist[a] = ini_read_string(blacklist,"name_"+string(a),"No name found");
			   }
			   
			   ini_close();
			  
		
		
		OnAudio=2; }
	
	//Save
	var _save = draw_button_ext(4+string_width("Back")*1.5+16,room_height-40,mouse_check_button(mb_left),"click",
	"Save",1,2,1.5)
	
	if(_save){ 
	   
	   ini_open("musicdata.ini");
	   
	   ini_write_real(filename,"loopend",global.loopend);
	   ini_write_real(filename,"loopstart",global.loopstart);
	   
	   ini_close();
	   
	   clipboard_set_text(string(global.loopstart)+","+string(global.loopend));
	   
	   show_message("Loop points saved and copied to clipboard.")
	   
	}
	
	//Set time
	var _time = draw_button_ext(4+string_width("Back")*3+32,room_height-40,mouse_check_button(mb_left),"click",
	"Time",1,2,1.5)
	
	if(_time){ 
	   	  msg = get_string_async("Set time (in seconds)",string(_playpos));
		  AnswerWait = Questions.set_time;
	}
	
	var _c = c_white; if(doloop){_c=c_gray;}
	var _loop = draw_button_ext(4,room_height-80,mouse_check_button(mb_left),"click","Loop",1,2,1.5,_c);
	
	if(_loop){
	   doloop=!doloop;	
	}
	
	//Play/pause
	if((!_playing)||(_paused))&&(paused){
	   var _Bstr = "Play";	
	}else{
	   var _Bstr = "Pause";	
	}
	
	var _play = draw_button_ext(room_width/2-string_width(_Bstr)*1.5-10,room_height-40,mouse_check_button(mb_left),"click",
	_Bstr,1,2,1.5)
	
	if(_play){
	   if(_paused){
		  audio_resume_sound(global.currentstream);   
		  paused=0;
	   }else if(!_playing){
		  global.currentstream = audio_play_sound(global.stream,0,0); 
		  paused=0;
	   }else{
		  audio_pause_sound(global.currentstream)   
		  paused=1;
	   }
	}
	
    //Stop
	var _stop = draw_button_ext(room_width/2+10,room_height-40,mouse_check_button(mb_left),"click",
	"Stop",1,2,1.5)
	
	if(_stop){ 
	   if(_playing)||(_paused){
		  audio_pause_sound(global.currentstream)
		  audio_sound_set_track_position(global.currentstream,0); 
		  paused=1;
	   }
	}
	
	//Loop start
	var _loopstart = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,room_height-40-string_height("M")*1.5-10,mouse_check_button(mb_left),"click",
	"Set L.S.",1,2,1.5)
	
	if(_loopstart){
	   global.loopstart=max(global.loopstart,0);	
	   editloop=1;
	}
	
	//Erase loop start
	var _startX = draw_button_ext(room_width-string_width("X")*1.5-12,room_height-40-string_height("M")*1.5-10,mouse_check_button(mb_left),"click",
	"X",1,2,1.5)
	
	if(_startX){ 
	   editloop=0;
	   global.loopstart=-4;
	}
	
    //Loop end
	var _loopend = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,room_height-40,mouse_check_button(mb_left),"click",
	"Set L.E.",1,2,1.5)
	
	if(_loopend){ 
	   global.loopend=max(global.loopend,0);	
	   editloop=2;
	}
	
	//Erase loop end
	var _endX = draw_button_ext(room_width-string_width("X")*1.5-12,room_height-40,mouse_check_button(mb_left),"click",
	"X",1,2,1.5)
	
	if(_endX){ 
	   editloop=0;	
	   global.loopend=-4;
	}
	
	//Use loops
	var _useloops = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,
	room_height-40-string_height("M")*3-20,mouse_check_button(mb_left),"click",
	"Use loops",1,2,1.5)
	
	if(_useloops){ 
	   useloops=!useloops;
	}
	
	draw_set_colour(c_white);
	//Volume
	var _VX = room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5;
	var _VY = room_height-40-string_height("M")*3-40;
	var _VW = string_width("X")*2+string_width("Set L.S.")*1.5
	
	draw_set_alpha(0.2);
	draw_line_width(_VX,_VY,_VX+_VW,_VY,4);
	draw_set_alpha(1);
	
	draw_set_halign(fa_right);draw_set_valign(fa_top);
	draw_text_transformed(_VX-10,_VY-5,string(Volume*100),1,1,0);
	
	var _rVW = (_VW/1)*Volume
	
	draw_line_width(_VX,_VY,_VX+_rVW,_VY,4);
	
	draw_circle(_VX+_rVW,_VY,8,0);
	
	if(mouse_in_rectangle(_VX,_VY-6,_VX+_VW,_VY+6)){
	  if(mouse_check_button_pressed(mb_left)){	
		 VolumeEditing=1;
	  }
	}
	
	if(VolumeEditing)&&(mouse_in_rectangle(_VX-20,_VY-26,_VX+_VW+20,_VY+26)){   
		 var _mouse_x_in_bar = clamp(device_mouse_x_to_gui(0)-_VX,0,_VW);
		 var _scale = (_mouse_x_in_bar/_VW);
		 Volume = _scale;	
	}
	
	if(mouse_check_button_released(mb_left)){ VolumeEditing=0; }
	
}
#endregion