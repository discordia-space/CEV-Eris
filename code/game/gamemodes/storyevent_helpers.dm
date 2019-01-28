//Helpers.

//A generic announcement to keep people on their toes, used by a few events.
//Doesn't give any info about exactly what is coming
/proc/generic_lifesign_announcement()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')
