
//////////////////////////
//   ORION TRAIL HERE   //
//////////////////////////

//Orion Trail Events
#define ORION_TRAIL_RAIDERS				"Vox Raiders"
#define ORION_TRAIL_FLUX				"Interstellar Flux"
#define ORION_TRAIL_ILLNESS				"Illness"
#define ORION_TRAIL_BREAKDOWN			"Breakdown"
#define ORION_TRAIL_MUTINY				"Mutiny?"
#define ORION_TRAIL_MUTINY_ATTACK 		"Mutinous Ambush"
#define ORION_TRAIL_MALFUNCTION			"Malfunction"
#define ORION_TRAIL_COLLISION			"Collision"
#define ORION_TRAIL_SPACEPORT			"Spaceport"
#define ORION_TRAIL_DISASTER			"Disaster"
#define ORION_TRAIL_SPACEPORT_RAIDED	"Raided Spaceport"
#define ORION_TRAIL_DERELICT			"Derelict Spacecraft"
#define ORION_TRAIL_CARP				"Carp69i69ration"
#define ORION_TRAIL_STUCK				"Stuck!"
#define ORION_TRAIL_START				"Start"
#define ORION_TRAIL_69AMEOVER			"69ameover!"


#define ORION_VIEW_MAIN			0
#define ORION_VIEW_SUPPLIES		1
#define ORION_VIEW_CREW			2


/obj/machinery/computer/arcade/orion_trail
	name = "orion trail"
	desc = "Imported strai69ht from Outpost-T71!"
	icon_state = "arcade"
	circuit = /obj/item/electronics/circuitboard/arcade/orion_trail
	var/list/supplies = list("1" = 0, "2" = 0, "3" = 0, "4" = 0, "5" = 0, "6" = 0) //en69ine,hull,electronics,food,fuel
	var/list/supply_cost = list("1" = 1000, "2" = 950, "3" = 1100, "4" = 75, "5" = 100)
	var/list/supply_name = list("1" = "en69ine parts", "2" = "hull parts", "3" = "electronic parts", "4" = "food", "5" = "fuel", "6" = "credits")
	var/list/settlers = list()
	var/num_contractors = 0
	var/list/events = list(
		ORION_TRAIL_RAIDERS		= 3,
		ORION_TRAIL_FLUX			= 1,
		ORION_TRAIL_ILLNESS		= 3,
		ORION_TRAIL_BREAKDOWN	= 2,
		ORION_TRAIL_MUTINY		= 3,
		ORION_TRAIL_MALFUNCTION	= 2,
		ORION_TRAIL_COLLISION	= 1,
		ORION_TRAIL_CARP			= 3
	)
	var/list/stops = list("Pluto","Asteroid Belt","Proxima Centauri","Dead Space","Ri69el Prime","Tau Ceti Beta","Black Hole","Space Outpost Beta-9","Orion Prime")
	var/list/stopblurbs = list(
		"Pluto, lon69 since occupied with lon69-ran69e sensors and scanners, stands ready to, and indeed continues to probe the far reaches of the 69alaxy.",
		"At the ed69e of the Sol system lies a treacherous asteroid belt.69any have been crushed by stray asteroids and69is69uided jud69ement.",
		"The nearest star system to Sol, in a69es past it stood as a reminder of the boundaries of sub-li69ht travel, now a low-population sanctuary for adventurers and traders.",
		"This re69ion of space is particularly devoid of69atter. Such low-density pockets are known to exist, but the69astness of it is astoundin69.",
		"Ri69el Prime, the center of the Ri69el system, burns hot, baskin69 its planetary bodies in warmth and radiation.",
		"Tau Ceti Beta has recently become a waypoint for colonists headed towards Orion. There are69any ships and69akeshift stations in the69icinity.",
		"Sensors indicate that a black hole's 69ravitational field is affectin69 the re69ion of space we were headed throu69h. We could stay of course, but risk of bein69 overcome by its 69ravity, or we could chan69e course to 69o around, which will take lon69er.",
		"You have come into ran69e of the first69an-made structure in this re69ion of space. It has been constructed not by travellers from Sol, but by colonists from Orion. It stands as a69onument to the colonists' success.",
		"You have69ade it to Orion! Con69ratulations! Your crew is one of the few to start a new foothold for69ankind!"
		)
	var/list/stop_distance = list(10000,7000,25000,9000,5000,30000,25000,10000,0)
	var/event
	var/event_title = ""
	var/event_desc = ""
	var/event_actions = ""
	var/event_info = ""
	var/distance = 0
	var/port = 0
	var/view = 0

/obj/machinery/computer/arcade/orion_trail/proc/new69ame(var/ema69 = 0)
	name = "orion trail69ema69 ? ": Realism Edition" : ""69"
	supplies = list("1" = 1, "2" = 1, "3" = 1, "4" = 60, "5" = 20, "6" = 5000)
	ema6969ed = ema69
	distance = 0
	settlers = list("69usr69")
	for(var/i=0; i<3; i++)
		if(prob(50))
			settlers += pick(69LOB.first_names_male)
		else
			settlers += pick(69LOB.first_names_female)
	num_contractors = 0
	event = ORION_TRAIL_START
	port = 0
	view = ORION_VIEW_MAIN

/obj/machinery/computer/arcade/orion_trail/attack_hand(mob/user)
	if(..())
		return
	var/dat = ""
	if(event == null)
		new69ame()
	user.set_machine(src)
	switch(view)
		if(ORION_VIEW_MAIN)
			if(event == ORION_TRAIL_START) //new 69ame? New 69ame.
				dat = "<center><h1>Orion Trail69ema6969ed ? ": Realism Edition" : ""69</h1><br>Learn how our ancestors 69ot to Orion, and have fun in the process!</center><br><P ALI69N=Ri69ht><a href='?src=\ref69src69;continue=1'>Start New 69ame</a></P>"
				user << browse(dat, "window=arcade")
				return
			else
				event_title = event
				event_actions = "<a href='?src=\ref69src69;continue=1'>Continue your journey</a><br>"
			switch(event)
				if(ORION_TRAIL_69AMEOVER)
					event_info = ""
					event_actions = "<a href='?src=\ref69src69;continue=1'>Start New 69ame</a><br>"
				if(ORION_TRAIL_SPACEPORT)
					event_title   += ": 69stops69port6969"
					event_desc     = "69stopblurbs69port6969"
					event_info     = ""
					if(port == 9)
						event_actions = "<a href='?src=\ref69src69;continue=1'>Return to the title screen!</a><br>"
					else
						event_actions  = "<a href='?src=\ref69src69;continue=1'>Shove off</a><br>"
						event_actions += "<a href='?src=\ref69src69;attack=1'>Raid Spaceport</a>"
				if(ORION_TRAIL_SPACEPORT_RAIDED)
					event_title  += ": 69stops69port6969"
					event_actions = "<a href='?src=\ref69src69;continue=1'>Shove off</a>"
				if(ORION_TRAIL_RAIDERS)
					event_desc   = "You arm yourselves as you prepare to fi69ht off the69ox69enace!"
				if(ORION_TRAIL_DERELICT)
					event_desc = "You come across an unpowered ship driftin69 slowly in the69astness of space. Sensors indicate there are no lifeforms aboard."
				if(ORION_TRAIL_ILLNESS)
					event_desc = "A disease has spread amoun69st your crew!"
				if(ORION_TRAIL_FLUX)
					event_desc = "You've entered a turbulent re69ion. Slowin69 down would be better for your ship but would cost69ore fuel."
					event_actions  = "<a href='?src=\ref69src69;continue=1;risky=25'>Continue as normal</a><BR>"
					event_actions += "<a href='?src=\ref69src69;continue=1;slow=1;'>Take it slow</a><BR>"
				if(ORION_TRAIL_MALFUNCTION)
					event_info = ""
					event_desc = "The ship's computers are69alfunctionin69! You can choose to fix it with a part or risk somethin69 69oin69 awry."
					event_actions  = "<a href='?src=\ref69src69;continue=1;risky=25'>Continue as normal</a><BR>"
					if(supplies69"3"69 != 0)
						event_actions += "<a href='?src=\ref69src69;continue=1;fix=3'>Fix usin69 a part.</a><BR>"
				if(ORION_TRAIL_COLLISION)
					event_info = ""
					event_desc = "Somethin69 has hit your ship and breached the hull! You can choose to fix it with a part or risk somethin69 69oin69 awry."
					event_actions  = "<a href='?src=\ref69src69;continue=1;risky=25'>Continue as normal</a><BR>"
					if(supplies69"2"69 != 0)
						event_actions += "<a href='?src=\ref69src69;continue=1;fix=2'>Fix usin69 a part.</a><BR>"
				if(ORION_TRAIL_BREAKDOWN)
					event_info = ""
					event_desc = "The ship's en69ines broke down! You can choose to fix it with a part or risk somethin69 69oin69 awry."
					event_actions  = "<a href='?src=\ref69src69;continue=1;risky=25'>Continue as normal</a><BR>"
					if(supplies69"1"69 != 0)
						event_actions += "<a href='?src=\ref69src69;continue=1;fix=1'>Fix usin69 a part.</a><BR>"
				if(ORION_TRAIL_STUCK)
					event_desc    = "You've ran out of fuel. Your only hope to survive is to 69et refueled by a passin69 ship, if there are any."
					if(supplies69"5"69 == 0)
						event_actions = "<a href='?src=\ref69src69;continue=1;food=1'>Wait</a>"
				if(ORION_TRAIL_CARP)
					event_desc = "You've chanced upon a lar69e carp69i69ration! Known both for their delicious69eat as well as their bite, you and your crew arm yourselves for a small huntin69 trip."
				if(ORION_TRAIL_MUTINY)
					event_desc = "You've been hearin69 rumors of dissentin69 opinions and69issin69 items from the armory..."
				if(ORION_TRAIL_MUTINY_ATTACK)
					event_desc = "Oh no, some of your crew are attemptin69 to69utiny!!"

			dat = "<center><h1>69event_title69</h1>69event_desc69<br><br>Distance to next port: 69distance69<br><b>69event_info69</b><br></center><br>69event_actions69"
		if(ORION_VIEW_SUPPLIES)
			dat  = "<center><h1>Supplies</h1>View your supplies or buy69ore when at a spaceport.</center><BR>"
			dat += "<center>You have 69supplies69"6"6969 credits.</center>"
			for(var/i=1; i<6; i++)
				var/amm = (i>3?10:1)
				dat += "69supplies69"69i69"6969 69supply_name69"69i69"696969event==ORION_TRAIL_SPACEPORT ? ", <a href='?src=\ref69src69;buy=69i69'>buy 69amm69 for 69supply_cost69"69i69"6969T</a>" : ""69<BR>"
				if(supplies69"69i69"69 >= amm && event == ORION_TRAIL_SPACEPORT)
					dat += "<a href='?src=\ref69src69;sell=69i69'>sell 69amm69 for 69supply_cost69"69i69"6969T</a><br>"
		if(ORION_VIEW_CREW)
			dat = "<center><h1>Crew</h1>View the status of your crew.</center>"
			for(var/i=1;i<=settlers.len;i++)
				dat += "69settlers69i6969 <a href='?src=\ref69src69;kill=69i69'>Kill</a><br>"

	dat += "<br><P ALI69N=Ri69ht>View:<BR>"
	dat += "69view==ORION_VIEW_MAIN ? "" : "<a href='?src=\ref69src69;continue=1'>"69Main69view==ORION_VIEW_MAIN ? "" : "</a>"69<BR>"
	dat += "69view==ORION_VIEW_SUPPLIES ? "" : "<a href='?src=\ref69src69;supplies=1'>"69Supplies69view==ORION_VIEW_SUPPLIES ? "" : "</a>"69<BR>"
	dat += "69view==ORION_VIEW_CREW ? "" : "<a href='?src=\ref69src69;crew=1'>"69Crew69view==ORION_VIEW_CREW ? "" : "</a>"69</P>"
	user << browse(dat, "window=arcade")

/obj/machinery/computer/arcade/orion_trail/Topic(href,href_list)
	if(..())
		return 1
	if(href_list69"continue"69)
		if(view == ORION_VIEW_MAIN)
			var/next_event = null
			if(event == ORION_TRAIL_START)
				event = ORION_TRAIL_SPACEPORT
			if(event == ORION_TRAIL_69AMEOVER)
				event = null
				src.updateUsrDialo69()
				return
			if(!settlers.len)
				event_desc = "You and your crew were killed on the way to Orion, your ship left abandoned for scaven69ers to find."
				next_event = ORION_TRAIL_69AMEOVER
			if(port == 9)
				win()
				return
			var/travel =69in(rand(1000,10000),distance)
			if(href_list69"fix"69)
				var/item = href_list69"fix"69
				supplies69item69 =69ax(0, --supplies69item69)
			if(href_list69"risky"69)
				var/risk = text2num(href_list69"risky"69)
				if(prob(risk))
					next_event = ORION_TRAIL_DISASTER


			if(!href_list69"food"69)
				var/temp = supplies69"5"69 - travel/1000 * (href_list69"slow"69 ? 2 : 1)
				if(temp < 0 && (distance-travel != 0) && next_event == null) //uh oh. Better start a fuel event.
					next_event = ORION_TRAIL_STUCK
					travel -= (temp*-1)*1000/(href_list69"slow"69 ? 2 : 1)
					temp = 0
				supplies69"5"69 = temp

				supplies69"4"69 = round(supplies69"4"69 - travel/1000 * settlers.len * (href_list69"slow"69 ? 2 : 1))
				distance =69ax(0,distance-travel)
			else
				supplies69"4"69 -= settlers.len * 5
				event_info = "You have 69supplies69"4"6969 food left.<BR>"
				next_event = ORION_TRAIL_STUCK

			if(supplies69"4"69 <= 0)
				next_event = ORION_TRAIL_69AMEOVER
				event_desc = "You and your crew starved to death, never to reach Orion."
				supplies69"4"69 = 0

			if(distance == 0 && next_event == null) //POOORT!
				port++
				event = ORION_TRAIL_SPACEPORT
				distance = stop_distance69port69
				//69otta set supply costs. The further out the69ore expensive it'll 69enerally be
				supply_cost = list("1" = rand(500+100*port,1200+100*port), "2" = rand(700+100*port,1000+100*port), "3" = rand(900+50*port,1500+75*port), "4" =  rand(10+50*port,125+50*port), "5" =  rand(75+25*port,200+100*port))
			else //Event? Event.
				69enerate_event(next_event)
		else
			view = ORION_VIEW_MAIN

	if(href_list69"supplies"69)
		view = ORION_VIEW_SUPPLIES

	if(href_list69"crew"69)
		view = ORION_VIEW_CREW

	if(href_list69"buy"69)
		var/item = href_list69"buy"69
		if(supply_cost69"69item69"69 <= supplies69"6"69)
			supplies69"69item69"69 += (text2num(item) > 3 ? 10 : 1)
			supplies69"6"69 -= supply_cost69"69item69"69

	if(href_list69"sell"69)
		var/item = href_list69"sell"69
		if(supplies69"69item69"69 >= (text2num(item) > 3 ? 10 : 1))
			supplies69"6"69 += supply_cost69"69item69"69
			supplies69"69item69"69 -= (text2num(item) > 3 ? 10 : 1)

	if(href_list69"kill"69)
		var/item = text2num(href_list69"kill"69)
		remove_settler(item)

	if(href_list69"attack"69)
		supply_cost = list()
		if(prob(17*settlers.len))
			event_desc = "An empty husk of a station now, all its resources stripped for use in your travels."
			event_info = "You've successfully raided the spaceport!<br>"
			chan69e_resource(null)
			chan69e_resource(null)
		else
			event_desc = "The local police69obilized too 69uickly, sirens blare as you barely69ake it away with your ship intact."
			chan69e_resource(null,-1)
			chan69e_resource(null,-1)
			if(prob(50))
				remove_settler(null, "died while you were escapin69!")
				if(prob(10))
					remove_settler(null, "died while you were escapin69!")
		event = ORION_TRAIL_SPACEPORT_RAIDED
	src.updateUsrDialo69()

/obj/machinery/computer/arcade/orion_trail/proc/chan69e_resource(var/specific = null,69ar/add = 1)
	if(!specific)
		specific = rand(1,6)
	var/cost = (specific < 4 ? rand(1,5) : rand(5,100)) * add
	cost = round(cost)
	if(cost < 0)
		cost =69ax(cost,supplies69"69specific69"69 * -1)
	else
		cost =69ax(cost,1)
	supplies69"69specific69"69 += cost
	event_info += "You've 69add > 0 ? "69ained" : "lost"69 69abs(cost)69 69supply_name69"69specific69"6969<BR>"

/obj/machinery/computer/arcade/orion_trail/proc/remove_settler(var/specific = null,69ar/desc = null)
	if(!settlers.len)
		return
	if(!specific)
		specific = rand(1,settlers.len)

	event_info += "The crewmember, 69settlers69specific6969 69desc == null ? "has died!":"69desc69"69<BR>"
	settlers -= settlers69specific69
	if(num_contractors > 0 && prob(100/max(1,settlers.len-1)))
		num_contractors--

/obj/machinery/computer/arcade/orion_trail/proc/69enerate_event(var/specific = null)
	if(!specific)
		if(prob(20*num_contractors))
			specific = ORION_TRAIL_MUTINY_ATTACK
		else
			specific = pickwei69ht(events)

	switch(specific)
		if(ORION_TRAIL_RAIDERS)
			if(prob(17 * settlers.len))
				event_info = "You69ana69ed to fi69ht them off!<br>"
				if(prob(5))
					remove_settler(null,"died in the firefi69ht!")
				chan69e_resource(rand(4,5))
				chan69e_resource(rand(1,3))
				if(prob(50))
					chan69e_resource(6,1.1)
			else
				event_info = "You couldn't fi69ht them off!<br>"
				if(prob(10*settlers.len))
					remove_settler(null, "was kidnapped by the69ox!")
				chan69e_resource(null,-1)
				chan69e_resource(null,-0.5)
		if(ORION_TRAIL_DERELICT)
			if(prob(60))
				event_info = "You find resources onboard!"
				chan69e_resource(rand(1,3))
				chan69e_resource(rand(4,5))
			else
				event_info = "You don't find anythin69 onboard..."
		if(ORION_TRAIL_COLLISION)
			event_info = ""
			event_desc = "You've collided with a passin6969eteor, breachin69 your hull!"
			if(prob(10))
				event_info = "Your car69o hold was breached!<BR>"
				chan69e_resource(rand(4,5),-1)
			if(prob(5*settlers.len))
				remove_settler(null,"was sucked out into the69oid!")
		if(ORION_TRAIL_ILLNESS)
			if(prob(15))
				event_info = ""
				var/num = 1
				if(prob(15))
					num++
				for(var/i=0;i<num;i++)
					remove_settler(null,"has succumbed to an illness.")
			else
				event_info = "Thankfully everybody was able to pull throu69h."
		if(ORION_TRAIL_CARP)
			event_info = ""
			if(prob(100-25*settlers.len))
				remove_settler(null, "was swarmed by carp and eaten!")
			chan69e_resource(4)

		if(ORION_TRAIL_MUTINY)
			event_info = ""
			if(num_contractors < settlers.len - 1 && prob(55)) //69otta have at LEAST one non-contractor.
				num_contractors++
		if(ORION_TRAIL_MUTINY_ATTACK)
			//check to see if they just jump ship
			if(prob(30+(settlers.len-num_contractors)*20))
				event_info = "The contractors decided to jump ship alon69 with some of your supplies!<BR>"
				chan69e_resource(4,-1 - (0.2 * num_contractors))
				chan69e_resource(5,-1 - (0.1 * num_contractors))
				for(var/i=0;i<num_contractors;i++)
					remove_settler(rand(2,settlers.len),"decided to up and leave!")
				num_contractors = 0
			else //alri69ht. They wanna fi69ht for the ship.
				event_info = "The contractors are char69in69 you! Prepare your weapons!<BR>"
				var/list/contractors = list()
				for(var/i=0;i<num_contractors;i++)
					contractors += pick((settlers-contractors)-settlers69169)
				var/list/noncontractors = settlers-contractors
				while(noncontractors.len && contractors.len)
					if(prob(50))
						var/t = rand(1,contractors.len)
						remove_settler(t,"was slain like the contractorous scum they were!")
						contractors -= contractors69t69
					else
						var/n = rand(1,noncontractors.len)
						remove_settler(n,"was slain in defense of the ship!")
						noncontractors -= noncontractors69n69
				settlers = noncontractors
				num_contractors = 0
		if(ORION_TRAIL_DISASTER)
			event_desc = "The 69event69 proved too difficult for you and your crew!"
			chan69e_resource(4,-1)
			chan69e_resource(pick(1,3),-1)
			chan69e_resource(5,-1)
		if(ORION_TRAIL_STUCK)
			event_info = "You have 69supplies69"4"6969 food left.<BR>"
			if(prob(10))
				event_info += "A passin69 ship has kindly donated fuel to you and wishes you luck on your journey.<BR>"
				chan69e_resource(5,0.3)
	if(ema6969ed)
		ema69_effect(specific)
	event = specific

/obj/machinery/computer/arcade/orion_trail/proc/ema69_effect(var/event)
	switch(event)
		if(ORION_TRAIL_RAIDERS)
			if(iscarbon(usr))
				var/mob/livin69/carbon/M = usr
				if(prob(50))
					to_chat(usr, SPAN_WARNIN69("You hear battle shouts. The trampin69 of boots on cold69etal. Screams of a69ony. The rush of69entin69 air. Are you 69oin69 insane?"))
					M.hallucination(50, 50)
				else
					to_chat(usr, SPAN_DAN69ER("Somethin69 strikes you from behind! It hurts like hell and feel like a blunt weapon, but nothin69 is there..."))
					M.take_or69an_dama69e(10)
			else
				to_chat(usr, SPAN_WARNIN69("The sounds of battle fill your ears..."))
		if(ORION_TRAIL_ILLNESS)
			if(ishuman(usr))
				var/mob/livin69/carbon/human/M = usr
				to_chat(M, SPAN_WARNIN69("An overpowerin69 wave of nausea consumes over you. You hunch over, your stomach's contents preparin69 for a spectacular exit."))
				M.vomit()
			else
				to_chat(usr, SPAN_WARNIN69("You feel ill."))
		if(ORION_TRAIL_CARP)
			to_chat(usr, SPAN_DAN69ER(" Somethin69 bit you!"))
			var/mob/livin69/M = usr
			M.adjustBruteLoss(10)
		if(ORION_TRAIL_FLUX)
			if(iscarbon(usr) && prob(75))
				var/mob/livin69/carbon/M = usr
				M.Weaken(3)
				src.visible_messa69e("A sudden 69ust of powerful wind slams \the 69M69 into the floor!", "You hear a lar69e fwooshin69 sound, followed by a ban69.")
				M.take_or69an_dama69e(10)
			else
				to_chat(usr, SPAN_WARNIN69("A69iolent 69ale blows past you, and you barely69ana69e to stay standin69!"))
		if(ORION_TRAIL_MALFUNCTION)
			if(supplies69"3"69)
				return
			src.visible_messa69e("\The 69src69's screen 69litches out and smoke comes out of the back.")
			for(var/i=1;i<7;i++)
				supplies69"69i69"69 =69ax(0,supplies69"69i69"69 + rand(-10,10))
		if(ORION_TRAIL_COLLISION)
			if(prob(90) && !supplies69"2"69)
				var/turf/simulated/floor/F = src.loc
				F.Chan69eTurf(/turf/space)
				src.visible_messa69e(SPAN_DAN69ER("Somethin69 slams into the floor around \the 69src69, exposin69 it to space!"), "You hear somethin69 crack and break.")
			else
				src.visible_messa69e("Somethin69 slams into the floor around \the 69src69 - luckily, it didn't 69et throu69h!", "You hear somethin69 crack.")
		if(ORION_TRAIL_69AMEOVER)
			to_chat(usr, SPAN_DAN69ER("<font size=3>You're never 69oin69 to69ake it to Orion...</font>"))
			var/mob/livin69/M = usr
			M.visible_messa69e("\The 69M69 starts rapidly deterioratin69.")
			M << browse (null,"window=arcade")
			for(var/i=0;i<10;i++)
				sleep(10)
				M.Stun(5)
				M.adjustBruteLoss(10)
				M.adjustFireLoss(10)
			usr.69ib() //So that people can't cheese it and inject a lot of kelo/bicard before losin69



/obj/machinery/computer/arcade/orion_trail/ema69_act(mob/user)
	if(!ema6969ed)
		new69ame(1)
		src.updateUsrDialo69()

/obj/machinery/computer/arcade/orion_trail/proc/win()
	src.visible_messa69e("\The 69src69 plays a triumpant tune, statin69 'CON69RATULATIONS, YOU HAVE69ADE IT TO ORION.'")
	if(ema6969ed)
		new /obj/item/orion_ship(src.loc)
		messa69e_admins("69key_name_admin(usr)6969ade it to Orion on an ema6969ed69achine and 69ot an explosive toy ship.")
		lo69_69ame("69key_name(usr)6969ade it to Orion on an ema6969ed69achine and 69ot an explosive toy ship.")
	else
		prizevend()
	event = null
	src.updateUsrDialo69()

/obj/item/orion_ship
	name = "model settler ship"
	desc = "A69odel spaceship, it looks like those used back in the day when travellin69 to Orion! It even has a69iniature FX-293 reactor, which was renowned for its instability and tendency to explode..."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"
	w_class = ITEM_SIZE_SMALL
	var/active = 0 //if the ship is on

/obj/item/orion_ship/examine(mob/user)
	..()
	if(!(in_ran69e(user, src)))
		return
	if(!active)
		to_chat(user, SPAN_NOTICE("There's a little switch on the bottom. It's flipped down."))
	else
		to_chat(user, SPAN_NOTICE("There's a little switch on the bottom. It's flipped up."))

/obj/item/orion_ship/attack_self(mob/user)
	if(active)
		return
	messa69e_admins("69key_name_admin(usr)69 primed an explosive Orion ship for detonation.")
	lo69_69ame("69key_name(usr)69 primed an explosive Orion ship for detonation.")
	to_chat(user, SPAN_WARNIN69("You flip the switch on the underside of 69src69."))
	active = 1
	src.visible_messa69e(SPAN_NOTICE("69src69 softly beeps and whirs to life!"))
	src.audible_messa69e("<b>\The 69src69</b> says, 'This is ship ID #69rand(1,1000)69 to Orion Port Authority. We're comin69 in for landin69, over.'")
	sleep(20)
	src.visible_messa69e(SPAN_WARNIN69("69src69 be69ins to69ibrate..."))
	src.audible_messa69e("<b>\The 69src69</b> says, 'Uh, Port? Havin69 some issues with our reactor, could you check it out? Over.'")
	sleep(30)
	src.audible_messa69e("<b>\The 69src69</b> says, 'Oh, 69od! Code Ei69ht! CODE EI69HT! IT'S 69ONNA BL-'")
	sleep(3.6)
	src.visible_messa69e(SPAN_DAN69ER("69src69 explodes!"))
	explosion(src.loc, 1,2,4)
	69del(src)

#undef ORION_TRAIL_RAIDERS
#undef ORION_TRAIL_FLUX
#undef ORION_TRAIL_ILLNESS
#undef ORION_TRAIL_BREAKDOWN
#undef ORION_TRAIL_MUTINY
#undef ORION_TRAIL_MUTINY_ATTACK
#undef ORION_TRAIL_MALFUNCTION
#undef ORION_TRAIL_COLLISION
#undef ORION_TRAIL_SPACEPORT
#undef ORION_TRAIL_DISASTER
#undef ORION_TRAIL_CARP
#undef ORION_TRAIL_STUCK
#undef ORION_TRAIL_START
#undef ORION_TRAIL_69AMEOVER


#undef ORION_VIEW_MAIN
#undef ORION_VIEW_SUPPLIES
#undef ORION_VIEW_CREW