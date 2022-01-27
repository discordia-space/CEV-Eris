//Weapon Stashes
//Weapons are 69uite69aried that there are69o base items for this stash type
/datum/stash/weapon
	base_type = /datum/stash/weapon
	loot_type = "Weapons"
	contents_list_base = list()
	contents_list_extra = list()
	contents_list_random = list()
	weight = 0.5
	nonmaint_reroll = 95


//Contains boomsticks, ie, shotguns
/datum/stash/weapon/mutiny_boomstick
	story_type = STORY_MUTINY
	directions = DIRECTION_COORDS | DIRECTION_LANDMARK
	contents_list_base = list(/obj/spawner/gun/shotgun = 2,
	/obj/spawner/ammo/shotgun = 2, /obj/spawner/ammo = 2)
	contents_list_random = list(/obj/spawner/ammo/shotgun = 60,
	/obj/spawner/ammo = 80,
	/obj/spawner/ammo = 80,
	/obj/spawner/ammo = 80,
	/obj/spawner/ammo = 80,
	/obj/spawner/ammo = 80,
	/obj/spawner/gun_upgrade = 50,
	/obj/spawner/gun_upgrade = 50,
	/obj/spawner/gun/shotgun = 50)
	lore = "MUTINY TOMORROW 030069EET AT %D <br><br>BRING YOUR OWN BOOMSTICK ONLY A FEW SPARES"

//because this one is styled like a telegram, lets capitalise the directions
/datum/stash/weapon/mutiny_boomstick/create_direction_string(var/data)
	. = ..()
	direction_string = capitalize(direction_string)



//Some crewmembers stockpiled anti-synthetic weapons in preparation for overthrowing some69ad intelligence
/datum/stash/weapon/mutiny_AI
	story_type = STORY_MALFUNCTION
	lore = "AI ACTING UP. GO HERE, %D BRING OTHERS. RADIO SILENCE."
	contents_list_base = list(/obj/item/gun/energy/ionrifle = 1,
	/obj/item/storage/box/emps = 1,
	/obj/item/clothing/gloves/insulated = 1,
	/obj/item/storage/toolbox/emergency = 1,
	/obj/spawner/powercell = 4)

	contents_list_random = list(/obj/item/storage/box/explosive = 40,
	/obj/item/tool/fireaxe = 70,
	/obj/item/clothing/gloves/insulated = 50,
	/obj/item/storage/box/emps = 30,
	/obj/item/gun/energy/ionrifle = 70,
	/obj/spawner/powercell = 70,
	/obj/item/storage/toolbox/emergency = 50,
	/obj/item/clothing/suit/armor/laserproof = 30,
	/obj/item/clothing/suit/armor/laserproof = 30,
	/obj/item/storage/belt/utility/full = 70,
	/obj/item/storage/belt/utility/full = 70)

//Variant of the above with slightly deeper story
/datum/stash/weapon/mutiny_AI/robots

	lore = "THE ROBOTS ARE USING THE INTERCOMM69ICROPHONES<br>\
	 okay got it<br>\
 WE HAVE TO STOP THEM<br>\
 got any ideas?<br>\
 FUCK I DON'T KNOW, CUT POWER TO THE AI CORE?<br>\
 sounds good but the core has turrets<br>\
 I CAN PRINT SOME GUNS FOR US<br>\
 we better69ot be seen together69uch longer<br>\
 OKAY JUST69EET69E AT %D"




//Crew get69ad and69utiny for69arious reasons. Stockpile a broad69ariety of weapons and ammo
//There are sooo69any69utiny stories
/datum/stash/weapon/mutiny
	story_type = STORY_MUTINY
	contents_list_base = list(/obj/spawner/gun/cheap = 3,
	/obj/spawner/ammo = 8,
	/obj/spawner/cloth/armor = 1)
	contents_list_random = list(/obj/spawner/gun/normal = 70,
	/obj/spawner/gun/energy_cheap = 50,
	/obj/spawner/voidsuit = 70,
	/obj/spawner/knife = 70,
	/obj/spawner/knife = 50,
	/obj/spawner/knife = 60,
	/obj/spawner/cloth/armor = 60,
	/obj/spawner/cloth/armor = 60)
	lore = "Logbook:<br>\
	 Half-rations unless we want roachmeat? What69ext, ship's biscuit and weevils? I'll choose the lesser of two weevils, black bloody69utiny.<br>\
 To hell with this half-assed aristocrat and his lording over us because he was born wearing a powdered wig. A69illennium late, you poser.<br>\
 Jellico slipped69e this with a wink and a69od. The Captain wants to play by old rules, we'll stick a plank out the airlock.<br>\
69eet at %D"


//Another69utiny, a crew enraged by atmospheric failures
/datum/stash/weapon/mutiny/overworked
	contents_list_extra = list(/obj/item/clothing/mask/gas = 3)
	lore = "Logbook:<br>\
	 Engineering has worked for six days in pressure suits with the rest of us packed in amidships.<br>\
 The toilets don't work, the air has been rebreathed by seventy69ouths seven69illion times, and I can smell the damn cook's halitosis coming out the one working air69ent because he's sleeping69ext to the one working scrubber.<br>\
 Half of the crew wants to hit the pods, the other half wants their bonus pay. I know what half I'm in, and we're69eeting at %D. Fuck this captain. Once we find some softsuits, that is."

/*
/datum/stash/weapon/mutiny/warden
	contents_list_extra = list(/obj/spawner/gun/normal = 3, /obj/spawner/ammo = 6)
	directions = DIRECTION_IMAGE
	lore = "Warden,<br>\
 You and I both know this rubber buckshot bullshit is going to get us all killed when the convicts realize they outnumber us sixty to one.<br>\
 Sarish tells69e there's a stash of real heaters wherever the hell this is.<br>\
 Crazy bitch sends a picture instead of a fucking coordinate. %D"
*/


/datum/stash/weapon/mutiny/starvation
 	//Make sure there's a shotgun with slugs in the stash, as described in the text.
 	//Also the wardens were hoarding food
 	contents_list_extra = list(/obj/spawner/gun/shotgun = 1, /obj/item/ammo_magazine/ammobox/shotgun = 1, /obj/spawner/rations = 6)
 	lore = "Convicts figured out the starvation rations are69either accidental69or temporary.<br>\
 Plan B is to shoot troublemakers until we balance the calorie e69uation.<br>\
 Just keep it semi-justifiable, don't leave any slugs in the walls, and stick the lethals back at %D when you're done.<br>\
 Can't have the69arshals find out we're breaking those precious regulations."