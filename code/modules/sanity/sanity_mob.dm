#define SANITY_PASSIVE_GAIN 0.2

#define SANITY_DAMAGE_MOD 0.7

// Damage received from unpleasant stuff in view
#define SANITY_DAMAGE_VIEW(damage, vig, dist) ((damage) * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX) * (1 - (dist)/15))

// Damage received from body damage
#define SANITY_DAMAGE_HURT(damage, vig) ((damage) / 5 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX))

// Damage received from shock
#define SANITY_DAMAGE_SHOCK(shock, vig) ((shock) / 50 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX))

// Damage received from psy effects
#define SANITY_DAMAGE_PSY(damage, vig) (damage * SANITY_DAMAGE_MOD * (2 - (vig) / STAT_LEVEL_MAX))

// Damage received from seeing someone die
#define SANITY_DAMAGE_DEATH(vig) (10 * SANITY_DAMAGE_MOD * (1 - (vig) / STAT_LEVEL_MAX))

#define SANITY_GAIN_SMOKE 0.05 // A full cig restores 300 times that
#define SANITY_GAIN_SAY 1

#define SANITY_COOLDOWN_SAY rand(30 SECONDS, 45 SECONDS)
#define SANITY_COOLDOWN_BREAKDOWN rand(7 MINUTES, 10 MINUTES)


/datum/sanity
	var/flags
	var/mob/living/carbon/human/owner

	var/sanity_invulnerability = 0
	var/level
	var/max_level = 100

	var/positive_prob = 20
	var/negative_prob = 30

	var/view_damage_threshold = 20

	var/say_time = 0
	var/breakdown_time = 0

	var/list/datum/breakdown/breakdowns = list()

/datum/sanity/New(mob/living/carbon/human/H)
	owner = H
	level = max_level
	RegisterSignal(owner, COMSIG_MOB_LIFE, .proc/onLife)
	RegisterSignal(owner, COMSIG_HUMAN_SAY, .proc/onSay)

/datum/sanity/proc/onLife()
	if(owner.stat == DEAD || owner.in_stasis)
		return
	var/affect = SANITY_PASSIVE_GAIN
	if(owner.stat)
		changeLevel(affect)
		return
	if(!(owner.sdisabilities & BLIND) && !owner.blinded)
		affect += handle_area()
		affect -= handle_view()
	changeLevel(max(affect, min(view_damage_threshold - level, 0)))
	handle_breakdowns()
	handle_level()

/datum/sanity/proc/handle_view()
	. = 0
	if(sanity_invulnerability)
		return
	var/vig = owner.stats.getStat(STAT_VIG)
	for(var/atom/A in view(owner.client ? owner.client : owner))
		if(A.sanity_damage)
			. += SANITY_DAMAGE_VIEW(A.sanity_damage, vig, get_dist(owner, A))

/datum/sanity/proc/handle_area()
	var/area/my_area = get_area(owner)
	if(!my_area)
		return 0
	. = my_area.sanity.affect
	if(. < 0)
		. *= owner.stats.getStat(STAT_VIG) / STAT_LEVEL_MAX

/datum/sanity/proc/handle_breakdowns()
	for(var/datum/breakdown/B in breakdowns)
		if(!B.update())
			breakdowns -= B

var/list/sanity_mirages = list()

/datum/hallucination/sanity_mirage
	duration = 3 SECONDS
	max_power = 30
	var/number = 1
	var/list/things = list() //list of images to display

/datum/hallucination/sanity_mirage/Destroy()
	end()
	. = ..()

/datum/hallucination/sanity_mirage/proc/generate_mirage()
	var/icon/T = new('icons/obj/sanity_hallucinations.dmi')
	return image(T, pick(T.IconStates()), layer = LOW_ITEM_LAYER)

/datum/hallucination/sanity_mirage/start()
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1 to number)
			var/image/thing = generate_mirage()
			things += thing
			thing.loc = pick(possible_points)
		holder.client.images += things

/datum/hallucination/sanity_mirage/end()
	if(holder.client)
		holder.client.images -= things
	
	
/datum/sanity/proc/handle_level()
	var/list/sanity_quotes_40 = list( 
		"You hear something squeezing through the ventilation ducts.", 
		"You’re the only sane one on this ship!",
		"You feel a tine prick!", 
		"You can hear your own heart beating in your head.",
		"You feel a slight prick.", 
		"Someone whispered behind your back.", 
		"All it takes is one bad day. All it takes is one bad day.",
		"You hear heavy breathing behind you.", 
		"Everyone is judging you.", 
		"When was the last time you had a good dream?",
		"You feel weary.", 
		"A spiderling runs between your legs and scuttles away",
		"Your head throbs with a dull pain.", 
		"Someone speaks your name. But when you turn, there is only dust.",
		"You need a smoke", 
		"Something in the air makes it taste metallic. Is this copper..?",
		"You are the greatest person on this ship.", 
		"Nothing has changed. But you know it did.", 
		"They put something in the water. Something that makes you forget.",
		"Everyone here is insane",
		"Your skin feels tight.", 
		"Your clothing is choking you.", 
		"Your teeth are itchy.", 
		"You can’t stop yourself from jerking your foot.", 
		"This is just too much",
		"You need a fix. Just a bit to take away the edge.", 
		"You smell something you can’t quite comprehend",
		"The sounds are elusive, they escape your mind.", 
		"Clear your throat, blink, grasp on reality and carry on.",
		"You think you understand now, why they called it a cursed ship.", 
		"Something just not right here.",
		"Dark thoughts glimpse in your mind, drowned in an overwhelming sense of deja vu", 
		"Count to ten. Breathe in. You can do it.",
		"You are tired, but sleep won't bring you peace.", 
		"So many people have died exploring a Null Space, why would your fate will be different?",
		"You got something in your throat.", 
		"You need be alone.", 
		"Why machines on this ship look a bit different each day?",
		"Those Vagabonds sure got some weird job titles, how old is this ship? What’s YOUR role in it’s fate?", 
		"At the end of the day, you will rest and recover. But not now, there is work to be done",
		"A shadow thwiches.", 
		"There is something in the corner of your eye, almost unseen. For how long it was there?", 
		"One day you will retire of this shit with a money large enough to buy your own house at the riverside. One day.",
		"Your nerve twists, but you regain control.", 
		"Carry on. Don’t look around. Carry on. Don’t look around.", 
		"It’s under the surface.", 
		"You recall a name, but it’s mean nothing to you.", 
		"Fear reigns over you body. Courage is running out.", 
		"What if they were right?", 
		"Your month open, you tell something to yourself, in silence.", 
		"The reality itself feels so old for you.", 
		"You are not significant.", 
		"A distant ticking, followed by a death of spring. What was that?", 
		"A flash of nothingness, a spark of emptiness, it just happened, and it’s all you can tell about it.",
		"Your meat is itchy, and bones are weak.", 
		"It all adds up to the rhythm.", 
		"Conceal your weakness, pretend that there is nothing going on. Good, yes, like this.",
		"You ignore it. It’s all not makes sense, so you just ignore it", 
		"You know who you are, you know why you are here, so you don’t bother with a details of the mind.",
		"You promised to buy him a drink, but what was his name? Wait, who is he?", 
		"Don’t ask, don’t tell, you are fine, and so do people around you",
		"Somewhere in this world, a spider just died. But why this is relevant?",
		"Space is the final frontier, and we are pioneers of the new age. Yet we stuck in junk, roaches and idiots",
		"Close your eyes. Remember the name. Go.",
		"But why does it make sense?",
		"A truth opens, yet closes before you was able to comprehend ше. If you dive deeper, you will discover it again, but is it worth it?",
		"Who was there before you, in your boots, in your place? What do they do, and where are they now?",
		"Too much information, you are overloaded.",
		"Something dies out.",
		"Where are you?",
		"You gotta have faith to walk those halls. In God, yourself, in something.",
		"Breath in, and kill the revolution inside you.",
		"You ask for strength. No one answered.",
		"Cuts run deep in your mind. Your sanity leaks through wounds.",
		"Shiver, run, and come back for more",
		"How old are roaches? How much did they saw?",
		"You are asking too many questions. You feel guilty.",
		"But they know, they always know. Accept this.",
		"Something inside your skull cracks. You feel no pain.",
		"Curiosity is your greatest sin.",
		"A burger could be good. Any tasty food, really.",
	)

	var/list/sanity_quotes_20 = list( 
		"Everything is beginning to freeze. Not even the comfort of warmth wants you.",
		"Every part of you is twitching. Remaining still is death.",
		"They want you dead.",
		"A wave of exhaustion overtakes you. Give up.",
		"You realize that the waking world was always a dream. You have to find a way to wake up. Wake up. Wake up.",
		"Sleep isn’t real.",
		"The people on this ship are not real. They do not deserve your kindness.",
		"Your existence is not welcomed on this ship.",
		"Memories once fond begin to fade from your mind. You question whether they were real to begin with.",
		"End it all.",
		"You begin to realize that drugs are the only escape from the agony that is existence.",
		"The walls are wrong. The walls are wrong!",
		"You have a strange urge to go North.",
		"Your teeth feel out of place. They should be in your stomach.",
		"Nothing shall be well. And nothing shall be well. And no manner of things shall be well.",
		"You'll feel better when you sink your teeth into their backs. You're sure.",
		"It feels like you're breathing inside your own lungs.",
		"You hunger for something rich and red rich and red rich and red rich and red rich and r-",
		"Escaping from your purpose is impossible...",
		"Seven times seven. Seven times seven. Seven times seven. Seven times seven. Seven times seven. Seven times seven. Seven times seven. Seven times seven. Seven times seven. ",
		"[rand(1, 9)] is the number.",
		"And so they laughed. They laughed. You know they laughed. You heard them laugh. They laughed. They laughed.",
		"Whenever you see a mirror, you feel like you can just reach out… and step through it.",
		"THEY ARE COMING THEY ARE COMING THEY ARE COMING",
		"No. Parts of you are crumbling. No. No!",
		"What is this? No… No!",
		"Something is scratching from behind your eyes, aching to get out.",
		"SHE EMBRACES ALL CHILDREN SHE EMBRACES ALL CHILDREN SHE EMBRACES ALL CHILDREN",
		"Shadows lie still, here where there is no sun to move them. Sometimes they shiver in fluorescent-light.",
		"They watch you with narrow eyes. What do they see?",
		"It echoes loudly through your skin, the rhythm of the world.",
		"It occurred to you that bolts can scream as well. But there is more to it, they sing.",
		"A prayer is what moves some machines. Not by words, but by actions, a rituals that bind the reality. A mantra to their only God.",
		"See them live, die, rot, in a single moment passed. A glimpse of a life cycle.",
		"Turn your mind towards you, as a world clearest mirror. See the pity and wretched soul that’s you.",
		"There was something between a gun and that target.",
		"Sell your dreams, crash your happiness. Enjoy the ticking sound of this worlds insides.",
		"Now you see it, a sharp pain that only your mind can feel resonates in a picture of the perfect machine. Then you see the rust and damage, a dead God.",
		"Move towards the light, even if your skin burns away.",
		"You radiate a hunger for knowledge, your mind is overheated and can melt the bounds of reality. Time to observe.",
		"Stay with them. Hear the music.",
		"The ceiling is covered in dark slime, how can anyone never noticed this before?",
		"You are not mad. You see the reality as it really are.",
		"You are clearly insane now, you can’t trust your eyes.",
		"Converge with shadows to dance under the moonlight of dead planet.",
		"TODAY IS A GOOD DAY",
		"You know who you are. But who am I?",
		"Bash your head until it’s good. It’s never good.",
		"Humanity is doomed, and so do you.",
		"Crave for salvation under a dead suns. It’s all that we have.",
		"At a verge of your sanity, gasping for sense, you are visited by an extreme though, what if all of this could have been avoided if you were more kind to people around you?",
		"ALL IS FINE",
		"YOU ARE A HAPPY INDIVIDUAL",
		"YOUR LIFE HAVE A MEANING",
		"Destroy it by any means, with all your force.",
		"Impatience breeds stronger, a crimson craving is unleashed in your mind.",
		"Open your mind to the wind of rotten flesh and crimson bones. Regret it afterwards.",
		"You collide with concepts so obscure that you lost yourself for a minute. But no time passed for the rest.",
		"Restrain your dancing mind and focus!",
		"A gunshot, a cloaked figure, a knife in the back. An overkill.",
		"SEE BEHIND THE START",
		"WEEP FOR WHAT WAS LOST BY THOSE WHO BELIEVE IN YOU",
		"It is possible to consume the fabric of reality itself. It tastes of oranges",
		"A communism is a valid choice for large human populations, and should be enforced globally.",
		"A stench of a poisoned mind. Yours.",
		"Everyone can read your thoughts. They are written on your face.",
		"What people will think of you when they found out?",
		"Your bones hurt. A superstructure inside demands to be set free.",
		"An idea reign over your mind now. You can’t tell what it is about, because it refuses to speak with you.",
		"Silence! Drown in silence!",
		"Repurpose your mind as bar of lost souls. Listen to their stories.",
		"Before the start, the beginning of everything, was the End, and you are so close to see it!",
		"You have no words. You just ate them up.",
		"Conquer the fields of madness with your bare hands, to find out if you are worthy",
		"The beat goes on. It goes, and goes, until your head will pop from sound.",
		"A corridor seemed endless at some point, like it was a different place, or even another world.",
		"You must maintain it. You must be a part of it.",
		"The forbidden animals roam the land.",
		"The rules are written in blood. Very old blood of generations of idiots.",
		"You are coming home.",
		"The writings are here, behind your skull.",
		"YOU HAVE NO CHOICE",
		"YOU HAVE NO CHANCE"
	)

	var/list/sanity_sounds_without_text = list(
		'sound/sanity/waterdrop.ogg',
		'sound/sanity/piano.ogg',
		'sound/sanity/limb_tear_off.ogg',
		'sound/sanity/slice.ogg',
		'sound/sanity/circsaw.ogg',
		'sound/sanity/hydraulic.ogg',
		'sound/sanity/glass_step.ogg',
		'sound/sanity/supermatter.ogg'
	)

	if(level<40 && level>20)
		if(prob(2))
			var/emote = pick(list(
			"shivers",
			"stares at something blindly for a moment.",
			"looks disoriented for a moment."
		))
			owner.custom_emote(message=emote)

	else if (level<=20)
		if(prob(2))
			var/emote = pick(list(
				"have a zombie stare",
				"is about to snap.",
				"rapidly and loudly tilts their head in unusual angle.",
				"laughs a bit.",
				"sobs for a moment."				
			))
			owner.custom_emote(message=emote)

	if(level<40 && level>20)
		if(prob(5))
			to_chat(owner, SPAN_DANGER("\icon['icons/effects/fabric_symbols_40.dmi'][pick(sanity_quotes_40)]"))

	if(level<=20)
		if(prob(5))
			to_chat(owner, SPAN_DANGER("\icon['icons/effects/fabric_symbols_20.dmi'][pick(sanity_quotes_20)]"))

	if(level<=20) //sounds without to_chat texts
		if(prob(0.1))
			owner.playsound_local(owner, pick(sanity_sounds_without_text), 50, 0, 8, null, 8)
	
//Sounds with to_chat texts

	if(level <= 20)
		if(prob(0.1))
			owner.playsound_local(owner, 'sound/hallucinations/i_see_you1.ogg', 50, 0, 8, null, 8)
			to_chat(owner, SPAN_DANGER("You hear someone behind you"))

	if(level <= 20)
		if(prob(0.1))
			owner.playsound_local(owner, 'sound/sanity/heavy_footsteps.ogg', 50, 0, 8, null, 8)
			to_chat(owner, SPAN_DANGER("You hear that something heavy behind you"))

	if(level <= 20)
		if(prob(0.1))
			owner.playsound_local(owner, 'sound/sanity/screech.ogg', 50, 0, 8, null, 8)
			to_chat(owner, SPAN_DANGER("You’ve got a goosbumps"))

	if(level <= 20)
		if(prob(0.1))
			owner.playsound_local(owner, 'sound/sanity/very_evil_laugh.ogg', 50, 0, 8, null, 8)
			to_chat(owner, SPAN_DANGER("You hear an evil laugh"))



		if(level < 20) //hallucinations from icons/obj/sanity_hallucinations.dmi
			if(prob(15))
				var/datum/hallucination/H = new /datum/hallucination/sanity_mirage
				H.holder = owner
				H.activate()

		

/datum/sanity/proc/onDamage(amount)
	changeLevel(-SANITY_DAMAGE_HURT(amount, owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onPsyDamage(amount)
	changeLevel(-SANITY_DAMAGE_PSY(amount, owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onSeeDeath(mob/M)
	if(ishuman(M))
		changeLevel(-SANITY_DAMAGE_DEATH(owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onShock(amount)
	changeLevel(-SANITY_DAMAGE_SHOCK(amount, owner.stats.getStat(STAT_VIG)))


/datum/sanity/proc/onChem(datum/reagent/R, multiplier)
	changeLevel(R.sanity_gain * multiplier)

/datum/sanity/proc/onAlcohol(datum/reagent/ethanol/E, multiplier)
	changeLevel(E.sanity_gain_ingest * multiplier)

/datum/sanity/proc/onEat(obj/item/weapon/reagent_containers/food/snacks/snack, amount_eaten)
	changeLevel(snack.sanity_gain * amount_eaten / snack.bitesize)

/datum/sanity/proc/onSmoke(obj/item/clothing/mask/smokable/S)
	changeLevel(SANITY_GAIN_SMOKE)

/datum/sanity/proc/onSay()
	if(world.time < say_time)
		return
	say_time = world.time + SANITY_COOLDOWN_SAY
	changeLevel(SANITY_GAIN_SAY)


/datum/sanity/proc/changeLevel(amount)
	if(sanity_invulnerability && amount < 0)
		return
	level = CLAMP(level + amount, 0, max_level)
	updateLevel()

/datum/sanity/proc/setLevel(amount)
	if(sanity_invulnerability)
		restoreLevel(amount)
		return
	level = amount
	updateLevel()

/datum/sanity/proc/restoreLevel(amount)
	level = max(level, amount)
	updateLevel()

/datum/sanity/proc/updateLevel()
	level = CLAMP(level, 0, max_level)
	if(level == 0 && world.time >= breakdown_time)
		breakdown()

/datum/sanity/proc/breakdown()
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN

	for(var/obj/item/device/mind_fryer/M in oview(owner))
		M.reg_break(owner)

	var/list/possible_results
	if(prob(positive_prob))
		possible_results = subtypesof(/datum/breakdown/positive)
	else if(prob(negative_prob))
		possible_results = subtypesof(/datum/breakdown/negative)
	else
		possible_results = subtypesof(/datum/breakdown/common)

	for(var/datum/breakdown/B in breakdowns)
		possible_results -= B.type

	while(possible_results.len)
		var/breakdown_type = pick(possible_results)
		var/datum/breakdown/B = new breakdown_type(src)

		if(!B.can_occur())
			possible_results -= breakdown_type
			qdel(B)
			continue

		if(B.occur())
			breakdowns += B
		return

#undef SANITY_PASSIVE_GAIN
