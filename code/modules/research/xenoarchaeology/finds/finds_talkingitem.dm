
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Formerly talking crystals - these procs are69ow69odular so that you can69ake any /obj/item 'parrot' player speech back to them
// This could be extended to atoms, but it's bad enough as is
// I genuinely tried to Add and Remove them from69ar and proc lists, but just couldn't get it working

//for easy reference
/obj/var/datum/talking_atom/talking_atom

/datum/talking_atom
	var/list/heard_words = list()
	var/last_talk_time = 0
	var/atom/holder_atom
	var/talk_interval = 50
	var/talk_chance = 10

/datum/talking_atom/New(atom/holder)
	holder_atom = holder
	init()

/datum/talking_atom/proc/init()
	if(holder_atom)
		START_PROCESSING(SSobj, src)

/datum/talking_atom/Process()
	if(!holder_atom)
		STOP_PROCESSING(SSobj, src)

	else if(heard_words.len >= 1 && world.time > last_talk_time + talk_interval && prob(talk_chance))
		SaySomething()

/datum/talking_atom/proc/catchMessage(var/msg,69ar/mob/source)
	if(!holder_atom)
		return

	var/list/seperate = list()
	if(findtext(msg,"(("))
		return
	else if(findtext(msg,"))"))
		return
	else if(findtext(msg," ")==0)
		return
	else
		/*var/l = length(msg)
		if(findtext(msg," ",l,l+1)==0)
			msg+=" "*/
		seperate = splittext(msg, " ")

	for(var/Xa = 1,Xa<seperate.len,Xa++)
		var/next = Xa + 1
		if(heard_words.len > 20 + rand(10,20))
			heard_words.Remove(heard_words69169)
		if(!heard_words69"69lowertext(seperate69Xa69)69"69)
			heard_words69"69lowertext(seperate69Xa69)69"69 = list()
		var/list/w = heard_words69"69lowertext(seperate69Xa69)69"69
		if(w)
			w.Add("69lowertext(seperate69next69)69")
		//world << "Adding 69lowertext(seperate69next69)69 to 69lowertext(seperate69Xa69)69"

	if(prob(30))
		var/list/options = list("69holder_atom69 seems to be listening intently to 69source69...",\
			"69holder_atom69 seems to be focusing on 69source69...",\
			"69holder_atom69 seems to turn it's attention to 69source69...")
		holder_atom.loc.visible_message("\blue \icon69holder_atom69 69pick(options)69")

	if(prob(20))
		spawn(2)
			SaySomething(pick(seperate))

/*/obj/item/talkingcrystal/proc/debug()
	//set src in69iew()
	for(var/v in heard_words)
		to_chat(world, "69uppertext(v)69")
		var/list/d = heard_words69"69v69"69
		for(var/X in d)
			to_chat(world, "69X69")*/

/datum/talking_atom/proc/SaySomething(var/word =69ull)
	if(!holder_atom)
		return

	var/msg
	var/limit = rand(max(5,heard_words.len/2))+3
	var/text
	if(!word)
		text = "69pick(heard_words)69"
	else
		text = pick(splittext(word, " "))
	if(length(text)==1)
		text=uppertext(text)
	else
		var/cap = copytext(text,1,2)
		cap = uppertext(cap)
		cap += copytext(text,2,length(text)+1)
		text=cap
	var/69 = 0
	msg+=text
	if(msg=="What" |69sg == "Who" |69sg == "How" |69sg == "Why" |69sg == "Are")
		69=1

	text=lowertext(text)
	for(var/ya,ya <= limit,ya++)

		if(heard_words.Find("69text69"))
			var/list/w = heard_words69"69text69"69
			text=pick(w)
		else
			text = "69pick(heard_words)69"
		msg+=" 69text69"
	if(69)
		msg+="?"
	else
		if(rand(0,10))
			msg+="."
		else
			msg+="!"

	var/list/listening =69iewers(holder_atom)
	for(var/mob/M in SSmobs.mob_list)
		if (!M.client)
			continue //skip69onkeys and leavers
		if (isnewplayer(M))
			continue
		if(M.stat == DEAD &&69.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
			listening|=M

	for(var/mob/M in listening)
		to_chat(M, "\icon69holder_atom69 <b>69holder_atom69</b> reverberates, \blue\"69msg69\"")
	last_talk_time = world.time
