
//// .35 ////
/obj/item/ammo_kit
	name = "scrap ammo kit"
	desc = "A somewhat jank looking crafting kit. It has a can of single-use tools, cheap pliers and a box of bullet making materials."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "ammo_kit-1"
	flags = CONDUCT
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	rarity_value = 10
	spawn_tags = SPAWN_TAG_AMMO_COMMON

/obj/item/ammo_kit/Initialize()
	. = ..()
	icon_state = "ammo_kit-[rand(1,5)]"

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/attack_self(mob/living/user as mob)

	var/cog_stat = user.stats.getStat(STAT_COG)

	if(!isliving(loc))
		return

	var/list/options = list()
	options[".20 Rifle"] = "srifle"
	options[".25 Caseless Rifle"] = "clrifle"
	options[".30 Rifle"] = "lrifle"
	options[".35 Auto"] = "pistol"
	options[".40 Magnum"] = "magnum"
	options[".50 Shotgun Buckshot"] = "shot"
	options[".50 Shotgun Beanbag"] = "bean"
	options[".50 Shotgun Slug"] = "slug"
	options[".60 Anti-Material"] = "antim"

	var/choice = input(user,"What ammo do you want to make?") as null|anything in options

	var/ammo_type = options[choice]

	var/dice_roll = (rand(0,20)*(1+cog_stat/20))	//0 cog means you get between 0 and 20, negative means you only over get minimum
	if(user.stats.getPerk(PERK_GUNMASTER))
		dice_roll = dice_roll * 2
	switch(ammo_type)
		if("pistol")
			spawn_pistol(dice_roll,user)
		if("magnum")
			spawn_magnum(dice_roll,user)
		if("srifle")
			spawn_rifle(dice_roll,user,1)	//same table, different spawns for all normal rifles
		if("clrifle")
			spawn_rifle(dice_roll,user,2)
		if("lrifle")
			spawn_rifle(dice_roll,user,3)
		if("antim")
			spawn_antim(dice_roll,user)
		if("shot")
			spawn_shotgun(dice_roll,user,1)
		if("bean")
			spawn_shotgun(dice_roll,user,2)
		if("slug")
			spawn_shotgun(dice_roll,user,3)
	if(choice)
		user.visible_message("[user] makes some [choice] rounds out of [src], using up all the materials in it.")
		qdel(src)	//All used up
	else
		to_chat(user, "You reconsider the path of gunsmith.")

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_pistol(dice = 0, mob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 10)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(10 to 20)
			mags = 1
		if(20 to 30)
			boxxes = 1
			mags = 1
		if(30 to 40)
			boxxes = 1
			mags = 2
		if(40 to 50)
			piles = 1
			boxxes = 2
			mags = 1
		else
			boxxes = 3+ round(dice/10-5,1)	//rich get richer

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/pistol/scrap/prespawned(user.loc)
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/pistol/scrap(user.loc)
	if(mags)
		for(var/j = 1 to mags)
			if(prob(50))
				new /obj/item/ammo_magazine/pistol/scrap(user.loc)
			else
				new /obj/item/ammo_magazine/smg/scrap(user.loc)

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_magnum(dice = 0, mob/user)

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 8)
			piles = 2
		if(8 to 16)
			piles = 2
			mags = 1
		if(16 to 24)
			boxxes = 1
		if(24 to 32)
			boxxes = 1
			mags = 1
		if(32 to 40)
			piles = 2
			boxxes = 1
			mags = 1
		if(40 to 48)
			boxxes = 1
			mags = 3
		else
			boxxes = 3 + round(dice/10-5,1)

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/magnum/scrap/prespawned(user.loc)
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/magnum/scrap(user.loc)
	if(mags)
		for(var/j = 1 to mags)
			if(prob(50))
				new /obj/item/ammo_magazine/magnum/scrap(user.loc)
			else
				new /obj/item/ammo_magazine/msmg/scrap(user.loc)

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_rifle(dice = 0, mob/user,rifle=1)	//All rifles use same spawning stats

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 6)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(6 to 12)
			piles = 2
		if(12 to 18)
			piles = 1
			mags = 1
		if(18 to 24)
			piles = 2
			mags = 1
		if(24 to 30)
			boxxes = 1
		if(30 to 42)
			boxxes = 1
			mags = 1
		if(42 to 48)
			boxxes = 1
			piles = 2
			mags = 1
		else
			boxxes = 2 + round(dice/10-5,1)

	if(rifle==1) //srifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/srifle/scrap/prespawned(user.loc)
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/srifle_small/scrap(user.loc)
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/srifle/scrap(user.loc)

	if(rifle==2) //clrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/clrifle/scrap/prespawned(user.loc)
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/clrifle_small/scrap(user.loc)
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/ihclrifle/scrap(user.loc)

	if(rifle==3) //lrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/lrifle/scrap/prespawned(user.loc)
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/lrifle_small/scrap(user.loc)
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/lrifle/scrap(user.loc)
//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_antim(dice = 0, mob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0

	switch(dice)
		if(-99 to 10)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(10 to 20)
			piles = 2
		if(20 to 30)
			piles = 3
		if(30 to 40)
			piles = 4
		if(40 to 50)
			piles = 5
		else
			boxxes = 1
			piles = round(dice/10-6,1)

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/antim/scrap/prespawned(user.loc)
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/antim/scrap(user.loc)

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_shotgun(dice = 0, mob/user,shotgun=1)	//All rifles use same spawning stats

	var/piles = 0

	switch(dice)
		if(-99 to 0)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		else
			piles = 1 + round(dice/7-1,1)	//We can use math here because it's just piles

	if(shotgun==1) //shot
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/pellet/scrap/prespawned(user.loc)

	if(shotgun==2) //bean
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned(user.loc)

	if(shotgun==3) //slug
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/scrap/prespawned(user.loc)
