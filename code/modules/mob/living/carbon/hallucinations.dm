/mob/living/carbon/var/hallucination_power = 0
/mob/living/carbon/var/hallucination_duration = 0
/mob/living/carbon/var/next_hallucination
/mob/living/carbon/var/list/hallucinations = list()

/mob/living/carbon/proc/hallucination(duration, power)
	hallucination_duration =69ax(hallucination_duration, duration)
	hallucination_power =69ax(hallucination_power, power)

/mob/living/carbon/proc/adjust_hallucination(duration, power)
	hallucination_duration =69ax(0, hallucination_duration + duration)
	hallucination_power =69ax(0, hallucination_power + power)

/mob/living/carbon/proc/handle_hallucinations()
	//Tick down the duration
	hallucination_duration =69ax(0, hallucination_duration - 1)
	if(chem_effects69CE_MIND69 > 0)
		hallucination_duration =69ax(0, hallucination_duration - 1)

	//Adjust power if we have some chems that affect it
	if(chem_effects69CE_MIND69 < 0)
		hallucination_power =69in(hallucination_power++, 50)
	if(chem_effects69CE_MIND69 < -1)
		hallucination_power = hallucination_power++
	if(chem_effects69CE_MIND69 > 0)
		hallucination_power =69ax(hallucination_power - chem_effects69CE_MIND69, 0)

	//See if hallucination is gone
	if(!hallucination_power)
		hallucination_duration = 0
		return
	if(!hallucination_duration)
		hallucination_power = 0
		return

	if(!client || stat || world.time <69ext_hallucination)
		return
	if(chem_effects69CE_MIND69 > 0 && prob(chem_effects69CE_MIND69*40)) //antipsychotics help
		return
	var/hall_delay = rand(10,20) SECONDS

	if(hallucination_power < 50)
		hall_delay *= 2
	next_hallucination = world.time + hall_delay
	var/list/candidates = list()
	for(var/T in subtypesof(/datum/hallucination/))
		var/datum/hallucination/H =69ew T
		if(H.can_affect(src))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/H = pick(candidates)
		H.holder = src
		H.activate()

//////////////////////////////////////////////////////////////////////////////////////////////////////
//Hallucination effects datums
//////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/hallucination
	var/mob/living/carbon/holder
	var/allow_duplicates = 1
	var/duration = 0
	var/min_power = 0 //at what levels of hallucination power69obs should get it
	var/max_power = INFINITY

/datum/hallucination/proc/start()

/datum/hallucination/proc/end()

/datum/hallucination/proc/can_affect(var/mob/living/carbon/C)
	if(!C.client)
		return 0
	if(min_power > C.hallucination_power)
		return 0
	if(max_power < C.hallucination_power)
		return 0
	if(!allow_duplicates && (locate(type) in C.hallucinations))
		return 0
	return 1

/datum/hallucination/Destroy()
	. = ..()
	holder =69ull

/datum/hallucination/proc/activate()
	if(!holder || !holder.client)
		return
	holder.hallucinations += src
	start()
	spawn(duration)
		if(holder)
			end()
			holder.hallucinations -= src
		qdel(src)


//Playing a random sound
/datum/hallucination/sound
	var/list/sounds = list('sound/machines/airlock.ogg','sound/effects/explosionfar.ogg','sound/machines/windowdoor.ogg','sound/machines/twobeep.ogg')

/datum/hallucination/sound/start()
	var/turf/T = locate(holder.x + rand(6,11), holder.y + rand(6,11), holder.z)
	holder.playsound_local(T,pick(sounds),70)

/datum/hallucination/sound/tools
	sounds = list('sound/items/Ratchet.ogg','sound/items/Welder.ogg','sound/items/Crowbar.ogg','sound/items/Screwdriver.ogg')

/datum/hallucination/sound/danger
	min_power = 30
	sounds = list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg','sound/weapons/smash.ogg')

/datum/hallucination/sound/spooky
	min_power = 50
	sounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
	'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
	'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
	'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
	'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')

//Hearing someone being shot twice
/datum/hallucination/gunfire
	var/gunshot
	var/turf/origin
	duration = 15
	min_power = 30

/datum/hallucination/gunfire/start()
	gunshot = pick('sound/weapons/guns/fire/hpistol_fire.ogg', 'sound/weapons/guns/fire/revolver_fire.ogg', 'sound/weapons/guns/fire/shotgunp_fire.ogg', 'sound/weapons/guns/fire/pistol_fire.ogg','sound/weapons/guns/fire/sfrifle_fire.ogg')
	origin = locate(holder.x + rand(4,8), holder.y + rand(4,8), holder.z)
	holder.playsound_local(origin,gunshot,50)

/datum/hallucination/gunfire/end()
	holder.playsound_local(origin,gunshot,50)

//Hearing someone talking to/about you.
/datum/hallucination/talking/can_affect(var/mob/living/carbon/C)
	if(!..())
		return 0
	for(var/mob/living/M in oview(C))
		return TRUE

/datum/hallucination/talking/start()
	var/sanity = 5 //even insanity69eeds some sanity
	for(var/mob/living/talker in oview(holder))
		if(talker.stat)
			continue
		var/message
		if(prob(80))
			var/list/names = list()
			var/lastname = copytext(holder.real_name, findtext(holder.real_name, " ")+1)
			var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
			if(lastname)69ames += lastname
			if(firstname)69ames += firstname
			if(!names.len)
				names += holder.real_name
			var/add = prob(20) ? ", 69pick(names)69" : ""
			var/list/phrases = list("69prob(50) ? "Hey, " : ""6969pick(names)69!","69prob(50) ? "Hey, " : ""6969pick(names)69?","Get out69add69!","Go away69add69.","What are you doing69add69?","Where's your ID69add69?")
			if(holder.hallucination_power > 50)
				phrases += list("What did you come here for69add69?","Don't touch69e69add69.","You're69ot getting out of here69add69.", "You are a failure, 69pick(names)69.","Just die already, 69pick(names)69.","Put on some clothes69add69.","Take off your clothes69add69.")
			message = pick(phrases)
			to_chat(holder,"<span class='game say'><span class='name'>69talker.name69</span> 69holder.say_quote(message)69, <span class='message'><span class='body'>\"69message69\"</span></span></span>")
		else
			to_chat(holder,"<B>69talker.name69</B> points at 69holder.name69")
			to_chat(holder,"<span class='game say'><span class='name'>69talker.name69</span> says something softly.</span>")
		var/image/speech_bubble = image('icons/mob/talk.dmi',talker,"h69holder.say_test(message)69")
		spawn(30) qdel(speech_bubble)
		holder << speech_bubble
		sanity-- //don't spam them in69ery populated rooms.
		if(!sanity)
			return

//Spiderling skitters
/datum/hallucination/skitter/start()
	to_chat(holder,SPAN_NOTICE("The spiderling skitters69pick(" away"," around","")69."))

//Spiders in your body
/datum/hallucination/spiderbabies
	min_power = 40

/datum/hallucination/spiderbabies/start()
	if(istype(holder,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = holder
		var/obj/O = pick(H.organs)
		to_chat(H,SPAN_WARNING("You feel something 69pick("moving","squirming","skittering")69 inside of your 69O.name69!"))

//Seeing stuff
/datum/hallucination/mirage
	duration = 30 SECONDS
	max_power = 30
	var/number = 1
	var/list/things = list() //list of images to display

/datum/hallucination/mirage/Destroy()
	end()
	. = ..()

/datum/hallucination/mirage/proc/generate_mirage()
	var/icon/T =69ew('icons/obj/trash.dmi')
	return image(T, pick(T.IconStates()), layer = LOW_ITEM_LAYER)

/datum/hallucination/mirage/start()
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in69iew(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1 to69umber)
			var/image/thing = generate_mirage()
			things += thing
			thing.loc = pick(possible_points)
		holder.client.images += things

/datum/hallucination/mirage/end()
	if(holder.client)
		holder.client.images -= things

//LOADSEMONEY
/datum/hallucination/mirage/money
	min_power = 20
	max_power = 45
	number = 2

/datum/hallucination/mirage/money/generate_mirage()
	return image('icons/obj/items.dmi', "spacecash69pick(1000,500,200,100,50)69", layer = LOW_ITEM_LAYER)

//Blood and aftermath of firefight
/datum/hallucination/mirage/carnage
	min_power = 50
	number = 10

/datum/hallucination/mirage/carnage/generate_mirage()
	if(prob(50))
		var/image/I = image('icons/effects/blood.dmi', pick("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7"), layer = LOW_ITEM_LAYER)
		I.color = COLOR_BLOOD_HUMAN
		return I
	else
		var/image/I = image('icons/obj/ammo.dmi', "s-casing-spent", layer = LOW_ITEM_LAYER)
		I.layer = LOW_ITEM_LAYER
		I.dir = pick(GLOB.alldirs)
		I.pixel_x = rand(-10,10)
		I.pixel_y = rand(-10,10)
		return I

//Fake telepathy
/datum/hallucination/telepahy
	allow_duplicates = 0
	duration = 2069INUTES

/datum/hallucination/telepahy/start()
	to_chat(holder,"<span class = 'notice'>You expand your69ind outwards.</span>")
	holder.verbs += /mob/living/carbon/human/proc/fakeremotesay

/datum/hallucination/telepahy/end()
	if(holder)
		holder.verbs -= /mob/living/carbon/human/proc/fakeremotesay

/mob/living/carbon/human/proc/fakeremotesay()
	set69ame = "Telepathic69essage"
	set category = "Superpower"

	if(!hallucination_power)
		src.verbs -= /mob/living/carbon/human/proc/fakeremotesay
		return

	if(stat)
		to_chat(usr, "<span class = 'warning'>You're69ot in any state to use your powers right69ow!'</span>")
		return

	if(chem_effects69CE_MIND69 > 0)
		to_chat(usr, "<span class = 'warning'>Chemicals in your blood prevent you from using your power!'</span>")

	var/list/creatures = list()
	for(var/mob/living/carbon/C in SSmobs.mob_list)
		creatures += C
	creatures -= usr
	var/mob/target = input("Who do you want to project your69ind to ?") as69ull|anything in creatures
	if (isnull(target))
		return

	var/msg = sanitize(input(usr, "What do you wish to transmit"))
	show_message("<span class = 'notice'>You project your69ind into 69target.name69: \"69msg69\"</span>")
	if(!stat && prob(20))
		say(msg)

//Fake attack
/datum/hallucination/fakeattack
	min_power = 30

/datum/hallucination/fakeattack/can_affect(var/mob/living/carbon/C)
	if(!..())
		return 0
	for(var/mob/living/M in oview(C,1))
		return TRUE

/datum/hallucination/fakeattack/start()
	for(var/mob/living/M in oview(holder,1))
		to_chat(holder, SPAN_DANGER("69M69 has punched 69holder69!"))
		holder.playsound_local(get_turf(holder),"punch",50)

//Fake injection
/datum/hallucination/fakeattack/hypo
	min_power = 30

/datum/hallucination/fakeattack/hypo/start()
	to_chat(holder, SPAN_NOTICE("You feel a tiny prick!"))