
//// .35 ////
/obj/item/ammo_kit
	name = "scrap ammo kit"
	desc = "A somewhat jank looking crafting kit. It has a can of single-use tools, cheap pliers and a box of bullet69aking69aterials."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "ammo_kit-1"
	flags = CONDUCT
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	rarity_value = 10
	spawn_tags = SPAWN_TAG_AMMO_COMMON

/obj/item/ammo_kit/Initialize()
	. = ..()
	icon_state = "ammo_kit-69rand(1,5)69"

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/attack_self(mob/living/user as69ob)

	var/cog_stat = user.stats.getStat(STAT_COG)

	if(!isliving(loc))
		return

	var/list/options = list()
	options69".20 Rifle"69 = "srifle"
	options69".25 Caseless Rifle"69 = "clrifle"
	options69".30 Rifle"69 = "lrifle"
	options69".35 Auto"69 = "pistol"
	options69".4069agnum"69 = "magnum"
	options69".50 Shotgun Buckshot"69 = "shot"
	options69".50 Shotgun Beanbag"69 = "bean"
	options69".50 Shotgun Slug"69 = "slug"
	options69".60 Anti-Material"69 = "antim"

	var/choice = input(user,"What ammo do you want to69ake?") as69ull|anything in options

	var/ammo_type = options69choice69

	var/dice_roll = (rand(0,20)*(1+cog_stat/20))	//0 cog69eans you get between 0 and 20,69egative69eans you only over get69inimum
	if(user.stats.getPerk(/datum/perk/oddity/gunsmith))
		dice_roll = dice_roll * 2
	switch(ammo_type)
		if("pistol")
			spawn_pistol(dice_roll,user)
		if("magnum")
			spawn_magnum(dice_roll,user)
		if("srifle")
			spawn_rifle(dice_roll,user,1)	//same table, different spawns for all69ormal rifles
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
		user.visible_message("69user6969akes some 69choice69 rounds out of 69src69, using up all the69aterials in it.")
		69del(src)	//All used up
	else
		to_chat(user, "You reconsider the path of gunsmith.")

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_pistol(dice = 0,69ob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

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
		for(var/j = 1 to69ags)
			if(prob(50))
				new /obj/item/ammo_magazine/pistol/scrap(user.loc)
			else
				new /obj/item/ammo_magazine/smg/scrap(user.loc)

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_magnum(dice = 0,69ob/user)

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
		for(var/j = 1 to69ags)
			if(prob(50))
				new /obj/item/ammo_magazine/magnum/scrap(user.loc)
			else
				new /obj/item/ammo_magazine/msmg/scrap(user.loc)

//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_rifle(dice = 0,69ob/user,rifle=1)	//All rifles use same spawning stats

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
			for(var/j = 1 to69ags)
				new /obj/item/ammo_magazine/srifle/scrap(user.loc)

	if(rifle==2) //clrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/clrifle/scrap/prespawned(user.loc)
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/clrifle_small/scrap(user.loc)
		if(mags)
			for(var/j = 1 to69ags)
				new /obj/item/ammo_magazine/ihclrifle/scrap(user.loc)

	if(rifle==3) //lrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/lrifle/scrap/prespawned(user.loc)
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/lrifle_small/scrap(user.loc)
		if(mags)
			for(var/j = 1 to69ags)
				new /obj/item/ammo_magazine/lrifle/scrap(user.loc)
//////////////////////////////////////////////////////////////////////////////////////

/obj/item/ammo_kit/proc/spawn_antim(dice = 0,69ob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

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

/obj/item/ammo_kit/proc/spawn_shotgun(dice = 0,69ob/user,shotgun=1)	//All rifles use same spawning stats

	var/piles = 0

	switch(dice)
		if(-99 to 0)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		else
			piles = 1 + round(dice/7-1,1)	//We can use69ath here because it's just piles

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
