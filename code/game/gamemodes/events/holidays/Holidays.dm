//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays
var/global/Holiday = null

//Just thinking ahead! Here's the foundations to a69ore robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to69ake stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even69ore in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO,69OST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

/hook/startup/proc/updateHoliday()
	Get_Holiday()
	return 1

//sets up the Holiday global69ariable. Shouldbe called on game configuration or something.
/proc/Get_Holiday()
	if(!Holiday)	return		// Holiday stuff was not enabled in the config!

	Holiday = null				// reset our switch now so we can recycle it as our Holiday name

	var/YY	=	text2num(time2text(world.timeofday, "YY")) 	// get the current year
	var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current69onth
	var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)							Holiday = "New Year's Day"

		if(2)	//Feb
			switch(DD)
				if(2)							Holiday = "Groundhog Day"
				if(14)							Holiday = "Valentine's Day"
				if(17)							Holiday = "Random Acts of Kindness Day"

		if(3)	//Mar
			switch(DD)
				if(14)							Holiday = "Pi Day"
				if(17)							Holiday = "St. Patrick's Day"
				if(27)
					if(YY == 16)
						Holiday = "Easter"
				if(31)
					if(YY == 13)
						Holiday = "Easter"

		if(4)	//Apr
			switch(DD)
				if(1)
					Holiday = "April Fool's Day"
					if(YY == 18 && prob(50)) 	Holiday = "Easter"
				if(5)
					if(YY == 15)				Holiday = "Easter"
				if(16)
					if(YY == 17)				Holiday = "Easter"
				if(20)
					Holiday = "Four-Twenty"
					if(YY == 14 && prob(50))	Holiday = "Easter"
				if(22)							Holiday = "Earth Day"

		if(5)	//May
			switch(DD)
				if(1)							Holiday = "Labour Day"
				if(4)							Holiday = "FireFighter's Day"
				if(12)							Holiday = "Owl and Pussycat Day"	//what a dumb day of observence...but we -do- have costumes already :3

		if(6)	//Jun

		if(7)	//Jul
			switch(DD)
				if(1)							Holiday = "Doctor's Day"
				if(2)							Holiday = "UFO Day"
				if(8)							Holiday = "Writer's Day"
				if(30)							Holiday = "Friendship Day"

		if(8)	//Aug
			switch(DD)
				if(5)							Holiday = "Beer Day"

		if(9)	//Sep
			switch(DD)
				if(19)							Holiday = "Talk-Like-a-Pirate Day"
				if(28)							Holiday = "Stupid-69uestions Day"

		if(10)	//Oct
			switch(DD)
				if(4)							Holiday = "Animal's Day"
				if(7)							Holiday = "Smiling Day"
				if(16)							Holiday = "Boss' Day"
				if(31)							Holiday = "Halloween"

		if(11)	//Nov
			switch(DD)
				if(1)							Holiday = "Vegan Day"
				if(13)							Holiday = "Kindness Day"
				if(19)							Holiday = "Flowers Day"
				if(21)							Holiday = "Saying-'Hello' Day"

		if(12)	//Dec
			switch(DD)
				if(10)							Holiday = "Human-Rights Day"
				if(14)							Holiday = "Monkey Day"
				if(21)							if(YY==12)	Holiday = "End of the World"
				if(22)							Holiday = "Orgasming Day"		//lol. These all actually exist
				if(24)							Holiday = "Christmas Eve"
				if(25)							Holiday = "Christmas"
				if(26)							Holiday = "Boxing Day"
				if(31)							Holiday = "New Year's Eve"

	if(!Holiday)
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				Holiday = "Friday the 13th"

//Allows GA and GM to set the Holiday69ariable
ADMIN_VERB_ADD(/client/proc/Set_Holiday, R_SERVER, null)
/client/proc/Set_Holiday(T as text|null)
	set name = ".Set Holiday"
	set category = "Fun"
	set desc = "Force-set the Holiday69ariable to69ake the game think it's a certain day."
	if(!check_rights(R_SERVER))	return

	Holiday = T
	//get a new station name
	station_name = null
	station_name()
	//update our hub status
	world.update_status()
	Holiday_Game_Start()

	message_admins("<span class='notice'>ADMIN: Event: 69key_name(src)69 force-set Holiday to \"69Holiday69\"</span>")
	log_admin("69key_name(src)69 force-set Holiday to \"69Holiday69\"")


//Run at the  start of a round
/proc/Holiday_Game_Start()
	if(Holiday)
		to_chat(world, "<font color='blue'>and...</font>")
		to_chat(world, "<h4>Happy 69Holiday69 Everybody!</h4>")
		switch(Holiday)			//special holidays
			if("Easter")
				//do easter stuff
			if("Christmas Eve","Christmas")
				Christmas_Game_Start()

	return
