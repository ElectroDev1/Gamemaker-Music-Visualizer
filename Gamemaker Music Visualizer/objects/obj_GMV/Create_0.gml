/// @description Initialize variables
/*
This tool is used to test music and things like loop points and volume
using a .ini file
*/


OnAudio = 0;

globalfile = "";
checkfile = 1;
musicbuffer = -4;
filename = "";

musiclist=0;

blacklist = "GLOBALS";

/*
0 - none
1 - start
2 - end
*/
editloop=0;

useloops=false;


paused=true;

/*
0 - new song
1 - from .ini
*/
SelectMode = 0;


enum Questions {
	 new_file,
     ini_name	
}
AnswerWait = -1;

msg=0;

init_global();
