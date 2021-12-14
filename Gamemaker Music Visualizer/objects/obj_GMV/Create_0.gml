/// @description Initialize variables
/*
This tool is used to test music and things like loop points and more
using a .ini file
*/

// Current version - 1.1.1

windowName = "Gamemaker Music Visualizer v1.1.1";
window_set_caption(windowName);

//Editor page
/*
0 - waiting for a song
1 - editing a song
2 - selecting an already loaded song
*/
OnAudio = 0;

globalfile = "";        //Global path of the new file selected
checkfile = 1;          //If we're waiting for a file
musicbuffer = -4;       //Used to store the buffer of the new file
filename = "";          //Name of the file selected

musiclist=0;            //List of stored songs

blacklist = "GLOBALS";  //Names that can't be used to save songs as, this is in case the name
                        //is already used as a header in the .ini file

//If we're editing a loop
/*
0 - none
1 - start loop
2 - end loop
*/
editloop=0;

//If the song is using the loops while playing
useloops=false;

//If the song is paused
paused=true;

//How we're selecting the song
/*
0 - new song
1 - from .ini
*/
SelectMode = 0;

//Answer type for the Async Dialog event
enum Questions {
	 new_file,
	 set_time
}
AnswerWait = -1;

//get_string_async variable
msg=0;

Volume=0;
VolumeEditing=0;

//Initialize globals
init_global();

//Discord RPC
np_initdiscord("920349022881988669", 0, 0);
ex=unix_timestamp();
details = "";
state = "";
RPC=true;