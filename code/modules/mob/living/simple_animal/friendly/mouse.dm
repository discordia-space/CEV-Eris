/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "A small, disgusting rodent often found being annoying and aiding in the spread of disease."
	icon = 'icons/mob/mouse.dmi'
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"
	can_nap = TRUE
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	eat_sounds = list('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg')
	pass_flags = PASSTABLE
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	melee_damage_upper = 0
	melee_damage_lower = 0
	attacktext = "bitten"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps on"
	density = FALSE
	layer =69OB_LAYER
	mob_size =69OB_MINISCULE
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/mouse
	digest_factor = 0.05
	min_scan_interval = 2
	max_scan_interval = 20
	seek_speed = 1
	speed = 1
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs =69OB_PULL_NONE

	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 1

	can_burrow = TRUE

	//kitchen_tag = "rodent" //This is part of cooking overhaul,69ot yet ported

	var/decompose_time = 3069INUTES

	var/body_color //brown, gray and white, leave blank for random

	var/soft_squeaks = list('sound/effects/creatures/mouse_squeaks_1.ogg',
	'sound/effects/creatures/mouse_squeaks_2.ogg',
	'sound/effects/creatures/mouse_squeaks_3.ogg',
	'sound/effects/creatures/mouse_squeaks_4.ogg')
	var/last_softsqueak =69ull//Used to prevent the same soft squeak twice in a row
	var/squeals = 5//Spam control.
	var/maxSqueals = 5//SPAM PROTECTION
	var/last_squealgain = 0// #TODO-FUTURE: Remove from life() once something else is created
	var/squeakcooldown = 0


/mob/living/simple_animal/mouse/New()
	..()
	nutrition = rand(max_nutrition*0.25,69ax_nutrition*0.75)

/mob/living/simple_animal/mouse/Life()
	if(..())

		if(client)
			walk_to(src,0)

			//Player-animals don't do random speech69ormally, so this is here
			//Player-controlled69ice will still squeak, but less often than69PC69ice
			if (stat == CONSCIOUS && prob(speak_chance*0.05))
				squeak_soft(0)

			if (squeals <69axSqueals)
				var/diff = world.time - last_squealgain
				if (diff > 600)
					squeals++
					last_squealgain = world.time

	else
		if ((world.time - timeofdeath) > decompose_time)
			dust()


//Pixel offsetting as they scamper around
/mob/living/simple_animal/mouse/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	if((. = ..()))
		if (prob(50))
			var/new_pixelx = pixel_x
			new_pixelx += rand(-2,2)
			new_pixelx = CLAMP(new_pixelx, -10, 10)
			animate(src, pixel_x =69ew_pixelx, time = 1)
		else
			var/new_pixely = pixel_y
			new_pixely += rand(-2,2)
			new_pixely = CLAMP(new_pixely, -4, 14)
			animate(src, pixel_y =69ew_pixely, time = 1)

/mob/living/simple_animal/mouse/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "69name69 (69rand(1, 1000)69)"
	real_name =69ame

	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_69body_color69"
	item_state = "mouse_69body_color69"
	icon_living = "mouse_69body_color69"
	icon_rest = "mouse_69body_color69_sleep"
	icon_dead = "mouse_69body_color69_dead"
	if (body_color == "brown")
		holder_type = /obj/item/holder/mouse/brown
	if (body_color == "gray")
		holder_type = /obj/item/holder/mouse/gray
	if (body_color == "white")
		holder_type = /obj/item/holder/mouse/white

	//verbs += /mob/living/simple_animal/mouse/proc/squeak
	//verbs += /mob/living/simple_animal/mouse/proc/squeak_soft
	//verbs += /mob/living/simple_animal/mouse/proc/squeak_loud(1)


/mob/living/simple_animal/mouse/speak_audio()
	squeak_soft(0)

/mob/living/simple_animal/mouse/beg(var/atom/thing,69ar/atom/holder)
	squeak_soft(0)
	visible_emote("squeaks timidly, sniffs the air and gazes longingly up at \the 69thing.name69.",0)

/mob/living/simple_animal/mouse/attack_hand(mob/living/carbon/human/M as69ob)
	if (src.stat == DEAD)//If the69ouse is dead, we don't pet it, we just pickup the corpse on click
		get_scooped(M, usr)
		return
	else
		..()

/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.death()
	src.icon_dead = "mouse_69body_color69_splat"
	src.icon_state = "mouse_69body_color69_splat"

//Plays a sound.
//This is triggered when a69ob steps on an69PC69ouse, or69anually by a playermouse
/mob/living/simple_animal/mouse/proc/squeak(var/manual = 1)
	if (stat == CONSCIOUS)
		playsound(src, 'sound/effects/mousesqueek.ogg', 70, 1)
		if (manual)
			log_say("69key_name(src)69 squeaks! ")


//Plays a random selection of four sounds, at a low69olume
//This is triggered randomly periodically by any69ouse, or69anually
/mob/living/simple_animal/mouse/proc/squeak_soft(var/manual = 1)
	if (stat != DEAD) //Soft squeaks are allowed while sleeping
		var/list/new_squeaks = last_softsqueak ? soft_squeaks - last_softsqueak : soft_squeaks
		var/sound = pick(new_squeaks)

		last_softsqueak = sound
		playsound(src, sound, 5, 1, -4.6)

		if (manual)
			log_say("69key_name(src)69 squeaks softly! ")


//Plays a loud sound
//Triggered69anually, when a69ouse dies, or rarely when its stepped on
/mob/living/simple_animal/mouse/proc/squeak_loud(var/manual = 0)
	if (stat == CONSCIOUS)

		if (squeals > 0 || !manual)
			playsound(src, 'sound/effects/creatures/mouse_squeak_loud.ogg', 40, 1)
			squeals --
			log_say("69key_name(src)69 squeals! ")
		else
			to_chat(src, "<span class='warning'>Your hoarse69ousey throat can't squeal just69ow, stop and take a breath!</span>")


//Wrapper69erbs for the squeak functions
/mob/living/simple_animal/mouse/verb/squeak_loud_verb()
	set69ame = "Squeal!"
	set category = "Abilities"

	if (usr.client.prefs.muted &69UTE_IC)
		to_chat(usr, "<span class='danger'>You are69uted from IC emotes.</span>")
		return

	squeak_loud(1)

/mob/living/simple_animal/mouse/verb/squeak_soft_verb()
	set69ame = "Soft Squeaking"
	set category = "Abilities"

	if (usr.client.prefs.muted &69UTE_IC)
		to_chat(usr, "<span class='danger'>You are69uted from IC emotes.</span>")
		return

	squeak_soft(1)

/mob/living/simple_animal/mouse/verb/squeak_verb()
	set69ame = "Squeak"
	set category = "Abilities"

	if (usr.client.prefs.muted &69UTE_IC)
		to_chat(usr, "<span class='danger'>You are69uted from IC emotes.</span>")
		return

	squeak(1)


/mob/living/simple_animal/mouse/Crossed(AM as69ob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='notice'>\icon69src69 Squeek!</span>")
			poke(1) //Wake up if stepped on
			if (prob(95))
				squeak(0)
			else
				squeak_loud(0)//You trod on its tail

	if(!health)
		return


	..()

/mob/living/simple_animal/mouse/death()
	layer =69OB_LAYER
	if (stat != DEAD)
		if(ckey || prob(35))
			squeak_loud(0)//deathgasp

		addtimer(CALLBACK(src, .proc/dust), decompose_time)

	..()

/mob/living/simple_animal/mouse/dust()
	..(anim = "dust_69body_color69", remains = /obj/item/remains/mouse, iconfile = icon)

//Mice can bite69obs, deals 1 damage, and stuns the69ouse for a second
/mob/living/simple_animal/mouse/AltClickOn(A)
	if (!can_click()) //This has to be here because anything but69ormal leftclicks doesn't use a click cooldown. It would be easy to fix, but there69ay be unintended consequences
		return
	melee_damage_upper =69elee_damage_lower //We set the damage to 1 so we can hurt things
	attack_sound = pick(list('sound/effects/creatures/nibble1.ogg', 'sound/effects/creatures/nibble2.ogg'))
	UnarmedAttack(A, Adjacent(A))
	melee_damage_upper = 0 //Set it back to zero so we're69ot biting with every69ormal click
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2) //Unarmed attack already applies a cooldown, but it's69ot long enough


/*
 *69ouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	icon_rest = "mouse_white_sleep"
	holder_type = /obj/item/holder/mouse/white

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"
	icon_rest = "mouse_gray_sleep"
	holder_type = /obj/item/holder/mouse/gray

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	icon_rest = "mouse_brown_sleep"
	holder_type = /obj/item/holder/mouse/brown

/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	real_name = "Tom"
	desc = "Jerry the cat is69ot amused."

/mob/living/simple_animal/mouse/brown/Tom/Initialize()
	. = ..()
	// Change69y69ame back, don't want to be69amed Tom (666)
	name = initial(name)
	real_name =69ame

/mob/living/simple_animal/mouse/cannot_use_vents()
	return



