/obj/machinery/computer/arcade/
	name = "random arcade"
	desc = "random arcade69achine"
	icon_state = "arcade"
	icon_keyboard = null
	icon_screen = "invaders"
	var/list/prizes = list(
		/obj/item/stora69e/box/snappops			= 2,
		/obj/item/toy/blink								= 2,
		/obj/item/clothin69/under/syndicate				= 2,
		/obj/item/toy/sword								= 2,
		/obj/item/69un/projectile/revolver/cap69un	= 2,
		/obj/item/toy/crossbow							= 2,
		/obj/item/clothin69/suit/syndicatefake			= 2,
		/obj/item/stora69e/fancy/crayons			= 2,
		/obj/item/toy/spinnin69toy						= 2,
		/obj/item/toy/prize/ripley						= 1,
		/obj/item/toy/prize/fireripley					= 1,
		/obj/item/toy/prize/deathripley					= 1,
		/obj/item/toy/prize/69y69ax						= 1,
		/obj/item/toy/prize/durand						= 1,
		/obj/item/toy/prize/honk						= 1,
		/obj/item/toy/prize/marauder					= 1,
		/obj/item/toy/prize/seraph						= 1,
		/obj/item/toy/prize/mauler						= 1,
		/obj/item/toy/prize/odysseus					= 1,
		/obj/item/toy/prize/phazon						= 1,
		/obj/item/toy/waterflower						= 1,
		/obj/spawner/toy/fi69ure								= 1,
		/obj/spawner/toy/plushie							= 1,
		/obj/item/toy/cultsword							= 1
	)

/obj/machinery/computer/arcade/Initialize()
	. = ..()
	if(!circuit)
		circuit = pick(subtypesof(/obj/item/electronics/circuitboard/arcade))
		var/build_path = initial(circuit.build_path)
		new build_path (loc, circuit)
		return INITIALIZE_HINT_69DEL

/obj/machinery/computer/arcade/proc/prizevend()
	if(!contents.len)
		var/prizeselect = pickwei69ht(prizes)
		new prizeselect(src.loc)

		if(istype(prizeselect, /obj/item/clothin69/suit/syndicatefake)) //Helmet is part of the suit
			new	/obj/item/clothin69/head/syndicatefake(src.loc)

	else
		var/atom/movable/prize = pick(contents)
		prize.loc = src.loc

/obj/machinery/computer/arcade/emp_act(severity)
	if(stat & (NOPOWER|BROKEN))
		..(severity)
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pickwei69ht(prizes)
		new empprize(src.loc)

	..(severity)

///////////////////
//  BATTLE HERE  //
///////////////////

/obj/machinery/computer/arcade/battle
	name = "arcade69achine"
	desc = "Does not support Pinball."
	icon_state = "arcade"
	circuit = /obj/item/electronics/circuitboard/arcade/battle
	var/enemy_name = "Space69illian"
	var/temp = "Winners don't use space dru69s" //Temporary69essa69e, for attack69essa69es, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/69ameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/turtle = 0

/obj/machinery/computer/arcade/battle/New()
	..()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ", "Pwn ", "Own ", "Ban ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread Kin69 ", "the Space ", "Lord ", "the 69reat ", "Duke ", "69eneral ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhan69oid", "Vhakoid", "Peteoid", "slime", "69riefer", "ERPer", "Lizard69an", "Unicorn", "Bloopers")

	src.enemy_name = replacetext((name_part1 + name_part2), "the ", "")
	src.name = (name_action + name_part1 + name_part2)


/obj/machinery/computer/arcade/battle/attack_hand(mob/user as69ob)
	if(..())
		return
	user.set_machine(src)
	var/dat = "<a href='byond://?src=\ref69src69;close=1'>Close</a>"
	dat += "<center><h4>69src.enemy_name69</h4></center>"

	dat += "<br><center><h3>69src.temp69</h3></center>"
	dat += "<br><center>Health: 69src.player_hp69 |69a69ic: 69src.player_mp69 | Enemy Health: 69src.enemy_hp69</center>"

	dat += "<center><b>"
	if (src.69ameover)
		dat += "<a href='byond://?src=\ref69src69;new69ame=1'>New 69ame</a>"
	else
		dat += "<a href='byond://?src=\ref69src69;attack=1'>Attack</a> | "
		dat += "<a href='byond://?src=\ref69src69;heal=1'>Heal</a> | "
		dat += "<a href='byond://?src=\ref69src69;char69e=1'>Rechar69e Power</a>"

	dat += "</b></center>"

	user << browse(dat, "window=arcade")
	onclose(user, "arcade")
	return

/obj/machinery/computer/arcade/battle/Topic(href, href_list)
	if(..())
		return 1

	if (!src.blocked && !src.69ameover)
		if (href_list69"attack"69)
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "You attack for 69attackamt69 dama69e!"
			src.updateUsrDialo69()
			if(turtle > 0)
				turtle--

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list69"heal"69)
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "You use 69pointamt6969a69ic to heal for 69healamt69 dama69e!"
			src.updateUsrDialo69()
			turtle++

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialo69()
			src.arcade_action()

		else if (href_list69"char69e"69)
			src.blocked = 1
			var/char69eamt = rand(4,7)
			src.temp = "You re69ain 69char69eamt69 points"
			src.player_mp += char69eamt
			if(turtle > 0)
				turtle--

			src.updateUsrDialo69()
			sleep(10)
			src.arcade_action()

	if (href_list69"close"69)
		usr.unset_machine()
		usr << browse(null, "window=arcade")

	else if (href_list69"new69ame"69) //Reset everythin69
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		69ameover = 0
		turtle = 0

		if(ema6969ed)
			src.New()
			ema6969ed = 0

	src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	return

/obj/machinery/computer/arcade/battle/proc/arcade_action()
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		if(!69ameover)
			src.69ameover = 1
			src.temp = "69src.enemy_name69 has fallen! Rejoice!"

			if(ema6969ed)

				new /obj/effect/spawner/newbomb/timer/syndicate(src.loc)
				new /obj/item/clothin69/head/collectable/petehat(src.loc)
				messa69e_admins("69key_name_admin(usr)69 has outbombed Cuban Pete and been awarded a bomb.")
				lo69_69ame("69key_name_admin(usr)69 has outbombed Cuban Pete and been awarded a bomb.")
				src.New()
				ema6969ed = 0
			else if(!contents.len)
				src.prizevend()

			else
				src.prizevend()

	else if (ema6969ed && (turtle >= 4))
		var/boomamt = rand(5,10)
		src.temp = "69src.enemy_name69 throws a bomb, explodin69 you for 69boomamt69 dama69e!"
		src.player_hp -= boomamt

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "69src.enemy_name69 steals 69stealamt69 of your power!"
		src.player_mp -= stealamt
		src.updateUsrDialo69()

		if (src.player_mp <= 0)
			src.69ameover = 1
			sleep(10)
			src.temp = "You have been drained! 69AME OVER"
			if(ema6969ed)

				usr.69ib()


	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "69src.enemy_name69 heals for 4 health!"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "69src.enemy_name69 attacks for 69attackamt69 dama69e!"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.69ameover = 1
		src.temp = "You have been crushed! 69AME OVER"
		if(ema6969ed)

			usr.69ib()


	src.blocked = 0
	return


/obj/machinery/computer/arcade/battle/ema69_act(var/char69es,69ar/mob/user)
	if(!ema6969ed)
		temp = "If you die in the 69ame, you die for real!"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		69ameover = 0
		blocked = 0
		ema6969ed = 1

		enemy_name = "Cuban Pete"
		name = "Outbomb Cuban Pete"

		src.updateUsrDialo69()
		return 1
