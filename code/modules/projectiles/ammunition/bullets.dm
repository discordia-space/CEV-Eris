
//// .35 ////
/obj/item/ammo_casing/pistol
	desc = "A .35 Auto bullet casing."
	icon_state = "pistol_c_l"
	spent_icon = "pistol_c_l-spent"
	shell_color = "l"
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol
	maxamount = 15

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5
	matter = list(MATERIAL_STEEL = 0.05)

/obj/item/ammo_casing/pistol/hv
	desc = "A .35 Auto high-velocity bullet casing."
	icon_state = "pistol_c_hv"
	spent_icon = "pistol_c_hv-spent"
	shell_color = "hv"
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/hv

/obj/item/ammo_casing/pistol/practice
	desc = "A .35 Auto practice bullet casing."
	icon_state = "pistol_c_p"
	spent_icon = "pistol_c_p-spent"
	shell_color = "p"
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/pistol/rubber
	desc = "A .35 Auto rubber bullet casing."
	icon_state = "pistol_c_r"
	spent_icon = "pistol_c_r-spent"
	shell_color = "r"
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/pistol/scrap
	desc = "An old .35 Auto bullet casing."
	icon_state = "pistol_c_s"
	spent_icon = "pistol_c_s-spent"
	shell_color = "s"
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/scrap

/obj/item/ammo_casing/pistol/scrap/prespawned
	amount = 15

//// .40 ////

/obj/item/ammo_casing/magnum
	desc = "A .40 Magnum hollow point bullet casing."
	caliber = CAL_MAGNUM
	icon_state = "magnum_c_l"
	spent_icon = "magnum_c_l-spent"
	shell_color = "l"
	projectile_type = /obj/item/projectile/bullet/magnum
	maxamount = 10

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5
	matter = list(MATERIAL_STEEL = 0.15)

/obj/item/ammo_casing/magnum/practice
	desc = "A .40 Magnum practice bullet casing."
	icon_state = "magnum_c_p"
	spent_icon = "magnum_c_p-spent"
	shell_color = "p"
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/practice

/obj/item/ammo_casing/magnum/hv
	desc = "A .40 Magnum high-velocity bullet casing."
	icon_state = "magnum_c_hv"
	spent_icon = "magnum_c_hv-spent"
	shell_color = "hv"
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/hv

/obj/item/ammo_casing/magnum/rubber
	desc = "A .40 Magnum rubber bullet casing."
	icon_state = "magnum_c_r"
	spent_icon = "magnum_c_r-spent"
	shell_color = "r"
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/rubber

/obj/item/ammo_casing/magnum/scrap
	desc = "An old .40 Magnum bullet casing."
	caliber = CAL_MAGNUM
	icon_state = "magnum_c_s"
	spent_icon = "magnum_c_s-spent"
	shell_color = "s"
	projectile_type = /obj/item/projectile/bullet/magnum/scrap

/obj/item/ammo_casing/magnum/scrap/prespawned
	amount = 10

//// .20 ////

/obj/item/ammo_casing/srifle
	desc = "A .20 Rifle bullet casing."
	icon_state = "srifle_c_l"
	spent_icon = "srifle_c_l-spent"
	shell_color = "l"
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle
	maxamount = 10

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5
	matter = list(MATERIAL_STEEL = 0.1)

/obj/item/ammo_casing/srifle/practice
	desc = "A .20 Rifle practice bullet casing."
	icon_state = "srifle_c_p"
	spent_icon = "srifle_c_p-spent"
	shell_color = "p"
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/practice

/obj/item/ammo_casing/srifle/hv
	desc = "A .20 Rifle high-velocity bullet casing."
	icon_state = "srifle_c_hv"
	spent_icon = "srifle_c_hv-spent"
	shell_color = "hv"
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/hv

/obj/item/ammo_casing/srifle/rubber
	desc = "A .20 Rifle rubber bullet casing."
	icon_state = "srifle_c_r"
	spent_icon = "srifle_c_r-spent"
	shell_color = "r"
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/rubber

/obj/item/ammo_casing/srifle/scrap
	desc = "An old .20 Rifle bullet casing."
	icon_state = "srifle_c_s"
	spent_icon = "srifle_c_s-spent"
	shell_color = "s"
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/scrap

/obj/item/ammo_casing/srifle/scrap/prespawned
	amount = 10

//// .25 ////

/obj/item/ammo_casing/clrifle
	desc = "A .25 Caseless Rifle bullet casing."
	icon_state = "clrifle_c_l"
	spent_icon = "clrifle_c_l-spent"
	shell_color = "l"
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle
	is_caseless = TRUE // as it is caseless, the casing costs nothing.
	maxamount = 10

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5

/obj/item/ammo_casing/clrifle/practice
	desc = "A .25 Caseless Rifle practice bullet casing."
	icon_state = "clrifle_c_p"
	spent_icon = "clrifle_c_p-spent"
	shell_color = "p"
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/practice
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/hv
	desc = "A .25 Caseless Rifle high-velocity bullet casing."
	icon_state = "clrifle_c_hv"
	spent_icon = "clrifle_c_hv-spent"
	shell_color = "hv"
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/hv
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/rubber
	desc = "A .25 Caseless Rifle rubber bullet casing."
	icon_state = "clrifle_c_r"
	spent_icon = "clrifle_c_r-spent"
	shell_color = "r"
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/rubber
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/scrap
	desc = "An old .25 Caseless Rifle bullet casing."
	icon_state = "clrifle_c_s"
	spent_icon = "clrifle_c_s-spent"
	shell_color = "s"
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/scrap

/obj/item/ammo_casing/clrifle/scrap/prespawned
	amount = 10

//// .30 ////

/obj/item/ammo_casing/lrifle
	desc = "A .30 rifle bullet casing."
	icon_state = "lrifle_c_l"
	spent_icon = "lrifle_c_l-spent"
	shell_color = "l"
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle
	maxamount = 10

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5
	matter = list(MATERIAL_STEEL = 0.15)

/obj/item/ammo_casing/lrifle/practice
	desc = "A .30 rifle practice bullet casing."
	icon_state = "lrifle_c_p"
	spent_icon = "lrifle_c_p-spent"
	shell_color = "p"
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/practice

/obj/item/ammo_casing/lrifle/hv
	desc = "A .30 Rifle high-velocity bullet casing."
	icon_state = "lrifle_c_hv"
	spent_icon = "lrifle_c_hv-spent"
	shell_color = "hv"
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/hv

/obj/item/ammo_casing/lrifle/rubber
	desc = "A .30 Rifle rubber bullet casing."
	icon_state = "lrifle_c_r"
	spent_icon = "lrifle_c_r-spent"
	shell_color = "r"
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/rubber

/obj/item/ammo_casing/lrifle/scrap
	desc = "An old .30 rifle bullet casing."
	icon_state = "lrifle_c_s"
	spent_icon = "lrifle_c_s-spent"
	shell_color = "s"
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/scrap

/obj/item/ammo_casing/lrifle/scrap/prespawned
	amount = 10

//// .60 ////

/obj/item/ammo_casing/antim
	name = "\"Penetrator\" shell casing"
	desc = "A .60 Anti-Material \"Penetrator\" shell."
	icon_state = "atmr"
	spent_icon = "atmr-spent"
	caliber = CAL_ANTIM
	projectile_type = /obj/item/projectile/bullet/antim
	matter = list(MATERIAL_PLASTEEL = 1)
	maxamount = 5

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 0.5

/obj/item/ammo_casing/antim/prespawned
	amount = 5

/obj/item/ammo_casing/antim/emp
	name = "\"Blackout\" shell casing"
	desc = "A .60 Anti-Material \"Blackout\" shell."
	icon_state = "atmr-emp"
	spent_icon = "atmr-emp-spent"
	projectile_type = /obj/item/projectile/bullet/antim/emp
	// bullet contains the iron and uranium

/obj/item/ammo_casing/antim/emp/prespawned
	amount = 5

/obj/item/ammo_casing/antim/uranium
	name = "\"Meltdown\" shell casing"
	desc = "A .60 Anti-Material \"Meltdown\" shell."
	icon_state = "atmr-DU"
	spent_icon = "atmr-DU-spent"
	projectile_type = /obj/item/projectile/bullet/antim/uranium
	// bullet contains the uranium

/obj/item/ammo_casing/antim/uranium/prespawned
	amount = 5

/obj/item/ammo_casing/antim/breach
	name = "\"Breacher\" shell casing"
	desc = "A .60 Anti-Material \"Breacher\" shell."
	icon_state = "atmr-HE"
	spent_icon = "atmr-HE-spent"
	projectile_type = /obj/item/projectile/bullet/antim/breach

/obj/item/ammo_casing/antim/breach/prespawned
	amount = 5

/obj/item/ammo_casing/antim/scrap
	name = "shell casing"
	desc = "An old .60 Anti-Material shell."
	icon_state = "atmr_s"
	spent_icon = "atmr_s-spent"
	projectile_type = /obj/item/projectile/bullet/antim/scrap
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/antim/scrap/prespawned
	amount = 5

//// .50 Shotgun ////

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A .50 slug."
	icon_state = "s-shell_hv"
	spent_icon = "s-shell_hv-spent"
	shell_color = "hv"
	caliber = CAL_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MATERIAL_STEEL = 0.5)
	maxamount = 5

	price_tag = 1

	sprite_update_spawn = TRUE
	sprite_max_rotate = 22
	sprite_scale = 0.75

/obj/item/ammo_casing/shotgun/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/scrap
	name = "old shotgun slug"
	desc = "An older .50 slug."
	icon_state = "s-shell_s"
	spent_icon = "s-shell_s-spent"
	shell_color = "scrap"
	caliber = CAL_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun/scrap
	maxamount = 5

/obj/item/ammo_casing/shotgun/scrap/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A .50 beanbag shell."
	icon_state = "s-shell_r"
	spent_icon = "s-shell_r-spent"
	shell_color = "r"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag

/obj/item/ammo_casing/shotgun/beanbag/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/beanbag/scrap
	name = "Old beanbag shell"
	desc = "An older .50 beanbag shell."
	icon_state = "s-shell_rs"
	spent_icon = "s-shell_rs-spent"
	shell_color = "scrap_r"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag/scrap

/obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A .50 shell."
	icon_state = "s-shell_l"
	spent_icon = "s-shell_l-spent"
	shell_color = "l"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/shotgun/pellet/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/pellet/scrap
	name = "old shotgun shell"
	desc = "An older .50 shell."
	icon_state = "s-shell_ss"
	spent_icon = "s-shell_ss-spent"
	shell_color = "scrap_s"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/scrap

/obj/item/ammo_casing/shotgun/pellet/scrap/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A .50 blank shell."
	icon_state = "s-shell_b"
	spent_icon = "s-shell_b-spent"
	shell_color = "b"
	projectile_type = /obj/item/projectile/bullet/blank

/obj/item/ammo_casing/shotgun/blank/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A .50 practice shell."
	icon_state = "s-shell_p"
	spent_icon = "s-shell_p-spent"
	shell_color = "p"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice

/obj/item/ammo_casing/shotgun/practice/prespawned
	amount = 5

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A .50 chemical shell used to signal distress or provide illumination."
	icon_state = "s-shell_f"
	spent_icon = "s-shell_f-spent"
	shell_color = "f"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(MATERIAL_STEEL = 0.5)// silver is inside projectile


/obj/item/ammo_casing/shotgun/flash/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "A .50 chemical shell with highly flammable load."
	icon_state = "s-shell_i"
	spent_icon = "s-shell_i-spent"
	shell_color = "i"
	projectile_type = /obj/item/projectile/bullet/shotgun/incendiary
	matter = list(MATERIAL_STEEL = 0.5) // plasma cost is inside projectile

/obj/item/ammo_casing/shotgun/incendiary/prespawned
	amount = 5

//// Grenade Shells ////

/obj/item/ammo_casing/grenade
	name = "FS SR \"Sasumata\""
	desc = "A high-grade Frozen Star sting round, for use against unruly crowds."
	icon_state = "baton-round"
	spent_icon = "grenadeshell"
	projectile_type = /obj/item/projectile/bullet/grenade/frag/sting
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 2)
	w_class = ITEM_SIZE_SMALL
	caliber = CAL_GRENADE
	is_caseless = TRUE
	maxamount = 1
	spawn_tags = SPAWN_TAG_AMMO
	rarity_value = 15

/obj/item/ammo_casing/grenade/teargas
	name = "FS TGR \"Murphy\""
	desc = "A riot-grade Frozen Star tear gas round, for use against unruly crowds."
	icon_state = "teargas"
	projectile_type = /obj/item/projectile/bullet/grenade/handgrenade/teargas
	w_class = ITEM_SIZE_SMALL
	caliber = CAL_GRENADE
	is_caseless = TRUE
	maxamount = 1
	spawn_tags = SPAWN_TAG_AMMO
	rarity_value = 15

/obj/item/ammo_casing/grenade/weak
	name = "NT SR \"Dard\""
	desc = "A standard-issue sting round for use against unruly crowds. The abbreviation \"NT\" marks its producer, but the lack of details makes it ubiquitous."
	projectile_type = /obj/item/projectile/bullet/grenade/frag/sting/weak
	matter = list(MATERIAL_STEEL = 5)
	rarity_value = 10

/obj/item/ammo_casing/grenade/blast
	name = "OR OBR \"Puff\""
	desc = "A military-grade explosive shell, designed to be fired from grenade launchers."
	icon_state = "blast"
	projectile_type = /obj/item/projectile/bullet/grenade/blast
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3)
	rarity_value = 25

/obj/item/ammo_casing/grenade/frag
	name = "NT DFR \"Pallad\""
	desc = "A military-grade grenade shell, designed to be fired from grenade launchers. The abbreviation \"NT\" marks its producer, but the lack of detatil makes it ubiquitous."
	icon_state = "frag"
	projectile_type = /obj/item/projectile/bullet/grenade/frag
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 2)
	rarity_value = 25

/obj/item/ammo_casing/grenade/emp
	name = "NT EMPR \"Remote Switch\""
	desc = "An EMP grenade shell, designed to be fired from grenade launchers. The abbreviation \"NT\" marks its producer, but the lack of detatil makes it ubiquitous."
	icon_state = "emp"
	projectile_type = /obj/item/projectile/bullet/grenade/emp // gonna keep this from being maint-lootable for now
	matter = list(MATERIAL_STEEL = 3, MATERIAL_IRON = 2, MATERIAL_URANIUM = 2)

/obj/item/ammo_casing/grenade/emp/low_yield
	name = "FS EMPR \"Short Circuit\""
	desc = "An EMP grenade shell configured with a lower radius for use on ships and stations, designed to be fired from grenade launchers. The abbreviation \"FS\" marks its producer,"
	icon_state = "emp_low"
	projectile_type = /obj/item/projectile/bullet/grenade/emp/low_yield // gonna keep this from being maint-lootable for now
	matter = list(MATERIAL_STEEL = 3, MATERIAL_IRON = 2, MATERIAL_URANIUM = 2)

/obj/item/ammo_casing/grenade/heatwave
	name = "NT HG \"Purifico\""
	desc = "A military-grade offensive heatwave grenade shell, designed to be fired from grenade launchers. \
			There\'s an inscription along the sides. \'For those who disbelieve, for them are cut out garments of fire, boiling water shall be poured over their heads.\'"
	icon_state = "incendiary"
	projectile_type = /obj/item/projectile/bullet/grenade/heatwave
	matter = list(MATERIAL_STEEL = 3, MATERIAL_BIOMATTER = 20, MATERIAL_PLASMA = 1)
	rarity_value = 40 // Neotheology

//// Other ////

/obj/item/ammo_casing/rocket
	name = "PG-7VL HE grenade"
	desc = "A high explosive warhead designed for the RPG-7 launcher. Has a tubular shape."
	description_info = "Relying purely on explosive power, HE shells provide the biggest boom on the best budget."
	icon_state = "rocketshell"
	projectile_type = /obj/item/projectile/bullet/rocket
	
	caliber = CAL_ROCKET
	maxamount = 1
	reload_delay = 15
	is_caseless = TRUE // as it is caseless, the casing costs nothing.
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/rocket/scrap
	name = "scrap rocket"
	desc = "An old improvised rocket shell for the RPG-7 launcher. Has a tubular shape."
	icon_state = "old_rocketshell"
	projectile_type = /obj/item/projectile/bullet/rocket/scrap

/obj/item/ammo_casing/rocket/hesh
	name = "PG-7V2 HESH grenade"
	desc = "A high-explosive squash head anti-vehicle warhead designed for the RPG-7 launcher. Has a tubular shape."
	description_info = "Using its blast wave, HESH warheads heavily damage the integrity of their target, causing a large amount of shrapnel to be released behind it via spalling."
	icon_state = "rocketshell_hesh"
	projectile_type = /obj/item/projectile/bullet/rocket/hesh

/obj/item/ammo_casing/rocket/heat
	name = "PG-7VL HEAT grenade"
	desc = "A high-explosive anti-tank warhead designed for the RPG-7 launcher. Has a tubular shape."
	description_info = "On impact, releases a burst of superheated air that will penetrate through even the strongest armors, causing heavy damage."
	icon_state = "rocketshell_heat"
	projectile_type = /obj/item/projectile/bullet/rocket/heat

/obj/item/ammo_casing/rocket/thermo
	name = "TBG-7V Thermobaric grenade"
	desc = "A thermobaric warhead designed for the RPG-7 launcher. Has a tubular shape."
	description_info = "A fuel air explosive, relying on the oxygen in the air to cause a sizeable, albeit weaker explosion. The chemical mix also causes a followup heatwave effect, bypassing walls and cover."
	icon_state = "rocketshell_thermo"
	projectile_type = /obj/item/projectile/bullet/rocket/thermo

/obj/item/ammo_casing/rocket/scrap/prespawned
	amount = 1

/obj/item/ammo_casing/a75
	desc = "Self-propelled explosive 'bolt' which explodes once it has penetrated its target."
	icon_state = "atmr"
	spent_icon = "atmr-spent"
	caliber = CAL_70
	projectile_type = /obj/item/projectile/bullet/gyro
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASMA = 1)

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	icon_state = "magnum_c_r"
	caliber = CAL_CAP
	color = "#FF0000"
	shell_color = "r"
	projectile_type = /obj/item/projectile/bullet/cap
	matter = list(MATERIAL_STEEL = 1, MATERIAL_CARDBOARD = 1)

/obj/item/ammo_casing/flare
	name = "AG FR \"Floodlight\""
	desc = "A chemical flare shell designed to produce a distress signal or illuminate an area."
	caliber = CAL_FLARE
	amount = 3
	icon_state = "f-shell"
	spent_icon = "f-shell-spent"
	projectile_type = /obj/item/projectile/bullet/flare
	matter = list(MATERIAL_PLASTIC = 0.5) // plasma cost is inside projectile, which does not embed.
	matter_reagents = list("phosphorus" = 3)
	rarity_value = 8

/obj/item/ammo_casing/crossbow/bolt
	name = "steel bolt"
	desc = "A steel rod worked into the shape of a crossbow bolt."
	icon_state = "CrossbowBolt"
	spent_icon = "CrossbowBolt"
	caliber = CAL_CBOLT
	projectile_type = /obj/item/projectile/bullet/bolt
	matter = list(MATERIAL_STEEL = 1)
	is_caseless = TRUE
	maxamount = 5
	sharp = TRUE

	sprite_update_spawn = TRUE
	sprite_max_rotate = 32
	sprite_scale = 1

/obj/item/ammo_casing/crossbow/bolt/prespawned
	amount = 5
