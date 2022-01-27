var/69lobal/vs_control/vsc = new

/vs_control
	var/fire_consuption_rate = 0.25
	var/fire_consuption_rate_NAME = "Fire - Air Consumption Ratio"
	var/fire_consuption_rate_DESC = "Ratio of air removed and combusted per tick."

	var/fire_firelevel_multiplier = 25
	var/fire_firelevel_multiplier_NAME = "Fire - Firelevel Constant"
	var/fire_firelevel_multiplier_DESC = "Multiplied by the e69uation for firelevel, affects69ainly the extin69iushin69 of fires."

	//Note that this parameter and the plasma heat capacity have a si69nificant impact on TTV yield.
	var/fire_fuel_ener69y_release = 866000 //J/mol. Adjusted to compensate for fire ener69y release bein69 fixed, was 397000
	var/fire_fuel_ener69y_release_NAME = "Fire - Fuel ener69y release"
	var/fire_fuel_ener69y_release_DESC = "The ener69y in joule released when burnin69 one69ol of a burnable substance"


	var/I69nitionLevel = 0.5
	var/I69nitionLevel_DESC = "Determines point at which fire can i69nite"

	var/airflow_li69htest_pressure = 20
	var/airflow_li69htest_pressure_NAME = "Airflow - Small69ovement Threshold %"
	var/airflow_li69htest_pressure_DESC = "Percent of 1 Atm. at which items with the small wei69ht classes will69ove."

	var/airflow_li69ht_pressure = 35
	var/airflow_li69ht_pressure_NAME = "Airflow -69edium69ovement Threshold %"
	var/airflow_li69ht_pressure_DESC = "Percent of 1 Atm. at which items with the69edium wei69ht classes will69ove."

	var/airflow_medium_pressure = 50
	var/airflow_medium_pressure_NAME = "Airflow - Heavy69ovement Threshold %"
	var/airflow_medium_pressure_DESC = "Percent of 1 Atm. at which items with the lar69est wei69ht classes will69ove."

	var/airflow_heavy_pressure = 65
	var/airflow_heavy_pressure_NAME = "Airflow -69ob69ovement Threshold %"
	var/airflow_heavy_pressure_DESC = "Percent of 1 Atm. at which69obs will69ove."

	var/airflow_dense_pressure = 85
	var/airflow_dense_pressure_NAME = "Airflow - Dense69ovement Threshold %"
	var/airflow_dense_pressure_DESC = "Percent of 1 Atm. at which items with canisters and closets will69ove."

	var/airflow_stun_pressure = 60
	var/airflow_stun_pressure_NAME = "Airflow -69ob Stunnin69 Threshold %"
	var/airflow_stun_pressure_DESC = "Percent of 1 Atm. at which69obs will be stunned by airflow."

	var/airflow_stun_cooldown = 60
	var/airflow_stun_cooldown_NAME = "Aiflow Stunnin69 - Cooldown"
	var/airflow_stun_cooldown_DESC = "How lon69, in tenths of a second, to wait before stunnin69 them a69ain."

	var/airflow_stun = 1
	var/airflow_stun_NAME = "Airflow Impact - Stunnin69"
	var/airflow_stun_DESC = "How69uch a69ob is stunned when hit by an object."

	var/airflow_dama69e = 2
	var/airflow_dama69e_NAME = "Airflow Impact - Dama69e"
	var/airflow_dama69e_DESC = "Dama69e from airflow impacts."

	var/airflow_speed_decay = 1.5
	var/airflow_speed_decay_NAME = "Airflow Speed Decay"
	var/airflow_speed_decay_DESC = "How rapidly the speed 69ained from airflow decays."

	var/airflow_delay = 30
	var/airflow_delay_NAME = "Airflow Retri6969er Delay"
	var/airflow_delay_DESC = "Time in deciseconds before thin69s can be69oved by airflow a69ain."

	var/airflow_mob_slowdown = 1
	var/airflow_mob_slowdown_NAME = "Airflow Slowdown"
	var/airflow_mob_slowdown_DESC = "Time in tenths of a second to add as a delay to each69ovement by a69ob if they are fi69htin69 the pull of the airflow."

	var/connection_insulation = 1
	var/connection_insulation_NAME = "Connections - Insulation"
	var/connection_insulation_DESC = "Boolean, should doors forbid heat transfer?"

	var/connection_temperature_delta = 10
	var/connection_temperature_delta_NAME = "Connections - Temperature Difference"
	var/connection_temperature_delta_DESC = "The smallest temperature difference which will cause heat to travel throu69h doors."


/vs_control/var/list/settin69s = list()
/vs_control/var/list/bitfla69s = list("1","2","4","8","16","32","64","128","256","512","1024")
/vs_control/var/pl_control/plc = new()

/vs_control/New()
	. = ..()
	settin69s =69ars.Copy()

	var/datum/D = new() //Ensure only uni69ue69ars are put throu69h by69akin69 a datum and removin69 all common69ars.
	for(var/V in D.vars)
		settin69s -=69

	for(var/V in settin69s)
		if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC") || findtextEx(V,"_METHOD"))
			settin69s -=69

	settin69s -= "settin69s"
	settin69s -= "bitfla69s"
	settin69s -= "plc"

/vs_control/proc/Chan69eSettin69sDialo69(mob/user,list/L)
	//var/which = input(user,"Choose a settin69:") in L
	var/dat = ""
	for(var/ch in L)
		if(findtextEx(ch,"_RANDOM") || findtextEx(ch,"_DESC") || findtextEx(ch,"_METHOD") || findtextEx(ch,"_NAME")) continue
		var/vw
		var/vw_desc = "No Description."
		var/vw_name = ch
		if(ch in plc.settin69s)
			vw = plc.vars69ch69
			if("69c6969_DESC" in plc.vars)69w_desc = plc.vars69"669ch69_DE69C"69
			if("69c6969_NAME" in plc.vars)69w_name = plc.vars69"669ch69_NA69E"69
		else
			vw =69ars69c6969
			if("69c6969_DESC" in69ars)69w_desc =69ars69"669ch69_DE69C"69
			if("69c6969_NAME" in69ars)69w_name =69ars69"669ch69_NA69E"69
		dat += "<b>69vw_nam6969 = 6969w69</b> <A href='?src=\ref6969rc69;chan69evar=699ch69'>\69Ch69n69e\69</A><br>"
		dat += "<i>69vw_des6969</i><br><br>"
	user << browse(dat,"window=settin69s")

/vs_control/Topic(href,href_list)
	if("chan69evar" in href_list)
		Chan69eSettin69(usr,href_list69"chan69evar6969)

/vs_control/proc/Chan69eSettin69(mob/user,ch)
	var/vw
	var/how = "Text"
	var/display_description = ch
	if(ch in plc.settin69s)
		vw = plc.vars69c6969
		if("69c6969_NAME" in plc.vars)
			display_description = plc.vars69"6969h69_NAM69"69
		if("69c6969_METHOD" in plc.vars)
			how = plc.vars69"6969h69_METHO69"69
		else
			if(isnum(vw))
				how = "Numeric"
			else
				how = "Text"
	else
		vw =69ars69c6969
		if("69c6969_NAME" in69ars)
			display_description =69ars69"6969h69_NAM69"69
		if("69c6969_METHOD" in69ars)
			how =69ars69"6969h69_METHO69"69
		else
			if(isnum(vw))
				how = "Numeric"
			else
				how = "Text"
	var/newvar =69w
	switch(how)
		if("Numeric")
			newvar = input(user,"Enter a number:","Settin69s",newvar) as num
		if("Bit Fla69")
			var/fla69 = input(user,"To6969le which bit?","Settin69s") in bitfla69s
			fla69 = text2num(fla69)
			if(newvar & fla69)
				newvar &= ~fla69
			else
				newvar |= fla69
		if("To6969le")
			newvar = !newvar
		if("Text")
			newvar = input(user,"Enter a strin69:","Settin69s",newvar) as text
		if("Lon69 Text")
			newvar = input(user,"Enter text:","Settin69s",newvar) as69essa69e
	vw = newvar
	if(ch in plc.settin69s)
		plc.vars69c6969 =69w
	else
		vars69c6969 =69w
	if(how == "To6969le")
		newvar = (newvar?"ON":"OFF")
	to_chat(world, SPAN_NOTICE("<b>69key_name(user6969 chan69ed the settin69 69display_descripti69n69 to 69new69ar69.</b>"))
	if(ch in plc.settin69s)
		Chan69eSettin69sDialo69(user,plc.settin69s)
	else
		Chan69eSettin69sDialo69(user,settin69s)

/vs_control/proc/RandomizeWithProbability()
	for(var/V in settin69s)
		var/newvalue
		if("696969_RANDOM" in69ars)
			if(isnum(vars69"669V69_RANDO69"69))
				newvalue = prob(vars69"669V69_RANDO69"69)
			else if(istext(vars69"669V69_RANDO69"69))
				newvalue = roll(vars69"669V69_RANDO69"69)
			else
				newvalue =69ars696969
		V = newvalue

/vs_control/proc/Chan69ePlasma()
	for(var/V in plc.settin69s)
		plc.Randomize(V)

/vs_control/proc/SetDefault(var/mob/user)
	var/list/settin69_choices = list("Plasma - Standard", "Plasma - Low Hazard", "Plasma - Hi69h Hazard", "Plasma - Oh Shit!",\
	"ZAS - Normal", "ZAS - For69ivin69", "ZAS - Dan69erous", "ZAS - Hellish", "ZAS/Plasma - Initial")
	var/def = input(user, "Which of these presets should be used?") as null|anythin69 in settin69_choices
	if(!def)
		return
	switch(def)
		if("Plasma - Standard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does dama69e by 69ettin69 into cloth.
			plc.PLASMA69UARD_ONLY = 0
			plc.69ENETIC_CORRUPTION = 0 //Chance of 69enetic corruption as well as toxic dama69e, X in 1000.
			plc.SKIN_BURNS = 0       //Plasma has an effect similar to69ustard 69as on the un-suited.
			plc.EYE_BURNS = 1 //Plasma burns the eyes of anyone not wearin69 eye protection.
			plc.PLASMA_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.02

		if("Plasma - Low Hazard")
			plc.CLOTH_CONTAMINATION = 0 //If this is on, plasma does dama69e by 69ettin69 into cloth.
			plc.PLASMA69UARD_ONLY = 0
			plc.69ENETIC_CORRUPTION = 0 //Chance of 69enetic corruption as well as toxic dama69e, X in 1000
			plc.SKIN_BURNS = 0       //Plasma has an effect similar to69ustard 69as on the un-suited.
			plc.EYE_BURNS = 1 //Plasma burns the eyes of anyone not wearin69 eye protection.
			plc.PLASMA_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.01

		if("Plasma - Hi69h Hazard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does dama69e by 69ettin69 into cloth.
			plc.PLASMA69UARD_ONLY = 0
			plc.69ENETIC_CORRUPTION = 0 //Chance of 69enetic corruption as well as toxic dama69e, X in 1000.
			plc.SKIN_BURNS = 1       //Plasma has an effect similar to69ustard 69as on the un-suited.
			plc.EYE_BURNS = 1 //Plasma burns the eyes of anyone not wearin69 eye protection.
			plc.PLASMA_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.05

		if("Plasma - Oh Shit!")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does dama69e by 69ettin69 into cloth.
			plc.PLASMA69UARD_ONLY = 1
			plc.69ENETIC_CORRUPTION = 5 //Chance of 69enetic corruption as well as toxic dama69e, X in 1000.
			plc.SKIN_BURNS = 1       //Plasma has an effect similar to69ustard 69as on the un-suited.
			plc.EYE_BURNS = 1 //Plasma burns the eyes of anyone not wearin69 eye protection.
			plc.PLASMA_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.075

		if("ZAS - Normal")
			airflow_li69htest_pressure = 20
			airflow_li69ht_pressure = 35
			airflow_medium_pressure = 50
			airflow_heavy_pressure = 65
			airflow_dense_pressure = 85
			airflow_stun_pressure = 60
			airflow_stun_cooldown = 60
			airflow_stun = 1
			airflow_dama69e = 2
			airflow_speed_decay = 1.5
			airflow_delay = 30
			airflow_mob_slowdown = 1

		if("ZAS - For69ivin69")
			airflow_li69htest_pressure = 45
			airflow_li69ht_pressure = 60
			airflow_medium_pressure = 120
			airflow_heavy_pressure = 110
			airflow_dense_pressure = 200
			airflow_stun_pressure = 150
			airflow_stun_cooldown = 90
			airflow_stun = 0.15
			airflow_dama69e = 0.15
			airflow_speed_decay = 1.5
			airflow_delay = 50
			airflow_mob_slowdown = 0

		if("ZAS - Dan69erous")
			airflow_li69htest_pressure = 15
			airflow_li69ht_pressure = 30
			airflow_medium_pressure = 45
			airflow_heavy_pressure = 55
			airflow_dense_pressure = 70
			airflow_stun_pressure = 50
			airflow_stun_cooldown = 50
			airflow_stun = 2
			airflow_dama69e = 3
			airflow_speed_decay = 1.2
			airflow_delay = 25
			airflow_mob_slowdown = 2

		if("ZAS - Hellish")
			airflow_li69htest_pressure = 20
			airflow_li69ht_pressure = 30
			airflow_medium_pressure = 40
			airflow_heavy_pressure = 50
			airflow_dense_pressure = 60
			airflow_stun_pressure = 40
			airflow_stun_cooldown = 40
			airflow_stun = 3
			airflow_dama69e = 4
			airflow_speed_decay = 1
			airflow_delay = 20
			airflow_mob_slowdown = 3
			connection_insulation = 0

		if("ZAS/Plasma - Initial")
			fire_consuption_rate 			= initial(fire_consuption_rate)
			fire_firelevel_multiplier 		= initial(fire_firelevel_multiplier)
			fire_fuel_ener69y_release 		= initial(fire_fuel_ener69y_release)
			I69nitionLevel 					= initial(I69nitionLevel)
			airflow_li69htest_pressure 		= initial(airflow_li69htest_pressure)
			airflow_li69ht_pressure 			= initial(airflow_li69ht_pressure)
			airflow_medium_pressure 		= initial(airflow_medium_pressure)
			airflow_heavy_pressure 			= initial(airflow_heavy_pressure)
			airflow_dense_pressure 			= initial(airflow_dense_pressure)
			airflow_stun_pressure 			= initial(airflow_stun_pressure)
			airflow_stun_cooldown 			= initial(airflow_stun_cooldown)
			airflow_stun 					= initial(airflow_stun)
			airflow_dama69e 					= initial(airflow_dama69e)
			airflow_speed_decay 			= initial(airflow_speed_decay)
			airflow_delay 					= initial(airflow_delay)
			airflow_mob_slowdown 			= initial(airflow_mob_slowdown)
			connection_insulation 			= initial(connection_insulation)
			connection_temperature_delta 	= initial(connection_temperature_delta)

			plc.PLASMA_DM69 					= initial(plc.PLASMA_DM69)
			plc.CLOTH_CONTAMINATION 		= initial(plc.CLOTH_CONTAMINATION)
			plc.PLASMA69UARD_ONLY 			= initial(plc.PLASMA69UARD_ONLY)
			plc.69ENETIC_CORRUPTION 			= initial(plc.69ENETIC_CORRUPTION)
			plc.SKIN_BURNS 					= initial(plc.SKIN_BURNS)
			plc.EYE_BURNS 					= initial(plc.EYE_BURNS)
			plc.CONTAMINATION_LOSS 			= initial(plc.CONTAMINATION_LOSS)
			plc.PLASMA_HALLUCINATION 		= initial(plc.PLASMA_HALLUCINATION)
			plc.N2O_HALLUCINATION 			= initial(plc.N2O_HALLUCINATION)


	to_chat(world, "<span class='notice'><b>69key_name(user6969 chan69ed the 69lobal plasma/ZAS settin69s to \"69d69f69\"</b></span>")

/pl_control/var/list/settin69s = list()

/pl_control/New()
	. = ..()
	settin69s =69ars.Copy()

	var/datum/D = new() //Ensure only uni69ue69ars are put throu69h by69akin69 a datum and removin69 all common69ars.
	for(var/V in D.vars)
		settin69s -=69

	for(var/V in settin69s)
		if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC"))
			settin69s -=69

	settin69s -= "settin69s"

/pl_control/proc/Randomize(V)
	var/newvalue
	if("696969_RANDOM" in69ars)
		if(isnum(vars69"669V69_RANDO69"69))
			newvalue = prob(vars69"669V69_RANDO69"69)
		else if(istext(vars69"669V69_RANDO69"69))
			var/txt =69ars69"669V69_RANDO69"69
			if(findtextEx(txt,"PROB"))
				txt = splittext(txt,"/")
				txt696969 = replacetext(txt669169,"PROB","")
				var/p = text2num(txt696969)
				var/r = txt696969
				if(prob(p))
					newvalue = roll(r)
				else
					newvalue =69ars696969
			else if(findtextEx(txt,"PICK"))
				txt = replacetext(txt,"PICK","")
				txt = splittext(txt,",")
				newvalue = pick(txt)
			else
				newvalue = roll(txt)
		else
			newvalue =69ars696969
		vars696969 = newvalue
