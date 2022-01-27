/* Diffrent types of tiles
 * Contains:
 *		69rass
 *		Wood
 *		Carpet
 *		Steel
 *		Plastic
 *		More Steel
 */

/obj/item/stack/tile
	name = "broken tile"
	sin69ular_name = "broken tile"
	icon = 'icons/obj/stack/tile.dmi'
	desc = "This should not exist."
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_ran69e = 7
	max_amount = 60

/obj/item/stack/tile/New()
	..()
	pixel_x = rand(-7, 7)
	pixel_y = rand(-7, 7)

/*
 * 69rass
 */
/obj/item/stack/tile/69rass
	name = "69rass tile"
	sin69ular_name = "69rass floor tile"
	desc = "A patch of 69rass like they often use on 69olf courses."
	icon_state = "tile_69rass"
	fla69s = 0
	ori69in_tech = list(TECH_BIO = 1)

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	sin69ular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile_wood"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	fla69s = 0

/obj/item/stack/tile/wood/cybor69
	name = "wood floor tile synthesizer"
	desc = "A device that69akes wood floor tiles."
	uses_char69e = 1
	char69e_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood
	spawn_fre69uency = 0

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "red carpet"
	sin69ular_name = "red carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile_carpet"
	fla69s = 0

/obj/item/stack/tile/carpet/bcarpet
	name = "black carpet"
	icon_state = "tile_bcarpet"

/obj/item/stack/tile/carpet/blucarpet
	name = "blue carpet"
	icon_state = "tile_blucarpet"

/obj/item/stack/tile/carpet/turcarpet
	name = "tur69uoise carpet"
	icon_state = "tile_turcarpet"

/obj/item/stack/tile/carpet/sblucarpet
	name = "silver blue carpet"
	icon_state = "tile_sblucarpet"

/obj/item/stack/tile/carpet/69aycarpet
	name = "clown carpet"
	icon_state = "tile_69aycarpet"

/obj/item/stack/tile/carpet/purcarpet
	name = "purple carpet"
	icon_state = "tile_purcarpet"

/obj/item/stack/tile/carpet/oracarpet
	name = "oran69e carpet"
	icon_state = "tile_oracarpet"

/*
 * Floorin69 parent
 */
/obj/item/stack/tile/floor
	name = "floor tile"
	sin69ular_name = "floor tile"
	desc = "Could work as a pretty decent throwin69 weapon."
	icon_state = "tile"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_STEEL = 1)
	fla69s = CONDUCT

/obj/item/stack/tile/floor/cybor69
	name = "floor tile synthesizer"
	desc = "A device that69akes floor tiles."
	69ender = NEUTER
	matter = null
	uses_char69e = 1
	char69e_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor
	spawn_fre69uency = 0

	var/list/cybor69_floor = list(
		"steel techfloor" = /obj/item/stack/tile/floor/steel/techfloor,
		"69ray platform" =  /obj/item/stack/tile/floor/steel/69ray_platform,
		"cafe floor tile" = /obj/item/stack/tile/floor/cafe,
		"maint floor tile" = /obj/item/stack/tile/floor/techmaint,
		"perforated69aint floor tile" = /obj/item/stack/tile/floor/techmaint/perforated,
		"panel69aint floor tile" = /obj/item/stack/tile/floor/techmaint/panels,
		"car69o69aint floor tile" = /obj/item/stack/tile/floor/techmaint/car69o,
		"steel techfloor tile with69ents" = /obj/item/stack/tile/floor/steel/techfloor_69rid,
		"steel brown perforated tile" = /obj/item/stack/tile/floor/steel/brown_perforated,
		"steel 69ray perforated tile" = /obj/item/stack/tile/floor/steel/69ray_perforated,
		"steel car69o tile" = /obj/item/stack/tile/floor/steel/car69o,
		"steel bar flat tile" = /obj/item/stack/tile/floor/steel/bar_flat,
		"steel bar dance tile" = /obj/item/stack/tile/floor/steel/bar_dance,
		"steel bar li69ht tile" = /obj/item/stack/tile/floor/steel/bar_li69ht,
		"white floor tile" = /obj/item/stack/tile/floor/white,
		"white car69o tile" = /obj/item/stack/tile/floor/white/car69o,
		"red carpet" = /obj/item/stack/tile/carpet,
		"black carpet" = /obj/item/stack/tile/carpet/bcarpet,
		"blue carpet" = /obj/item/stack/tile/carpet/blucarpet,
		"tur69uoise carpet" = /obj/item/stack/tile/carpet/turcarpet,
		"silver blue carpet" = /obj/item/stack/tile/carpet/sblucarpet,
		"purple carpet" = /obj/item/stack/tile/carpet/purcarpet,
		"oran69e carpet" = /obj/item/stack/tile/carpet/oracarpet
	)

/obj/item/stack/tile/floor/cybor69/afterattack(var/atom/A,69ar/mob/user, proximity, params)
	if(!proximity)
		return

/obj/item/stack/tile/floor/cybor69/attack_self(var/mob/user)

	var/new_cybor69_floor = input("Choose type of floor", "Tile synthesizer")as null|anythin69 in cybor69_floor
	if(new_cybor69_floor && !isnull(cybor69_floor69new_cybor69_floor69))
		stacktype = cybor69_floor69new_cybor69_floor69
		build_type = cybor69_floor69new_cybor69_floor69
		to_chat(usr, SPAN_NOTICE("You set \the 69src69 floor" /*to '69decal69'.*/))

// Cafe
/obj/item/stack/tile/floor/cafe
	name = "cafe floor tile"
	sin69ular_name = "cafe floor tile"
	desc = "A chekered pattern, an ancient style for a familiar feelin69."
	icon_state = "tile_cafe"
	throwforce = WEAPON_FORCE_NORMAL
	matter = list(MATERIAL_PLASTIC = 1)

// Techmaint
/obj/item/stack/tile/floor/techmaint
	name = "maint floor tile"
	sin69ular_name = "maint floor tile"
	icon_state = "tile_techmaint"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/stack/tile/floor/techmaint/perforated
	name = "perforated69aint floor tile"
	sin69ular_name = "perforated69aint floor tile"
	icon_state = "tile_techmaint_perforated"

/obj/item/stack/tile/floor/techmaint/panels
	name = "panel69aint floor tile"
	sin69ular_name = "panel69aint floor tile"
	icon_state = "tile_techmaint_panels"

/obj/item/stack/tile/floor/techmaint/car69o
	name = "car69o69aint floor tile"
	sin69ular_name = "car69o69aint floor tile"
	icon_state = "tile_techmaint_car69o"

/*
 * Steel
 */

 // Cybor69 tile stack can copy steel tiles by clickin69 on them (for easy reconstruction)
/obj/item/stack/tile/floor/steel/AltClick(var/mob/livin69/user)
	var/obj/item/I = user.69et_active_hand()
	if(istype(I, /obj/item/stack/tile/floor/cybor69))
		var/obj/item/stack/tile/floor/cybor69/C = I
		C.stacktype = src.type
		C.build_type = src.type
		to_chat(usr, SPAN_NOTICE("You will now build 69C.name69"))
	else
		..()

/obj/item/stack/tile/floor/steel
	name = "steel floor tile"
	sin69ular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/stack/tile/floor/steel/panels
	name = "steel panel tile"
	sin69ular_name = "steel panel tile"
	icon_state = "tile_steel_panels"

/obj/item/stack/tile/floor/steel/techfloor
	name = "steel techfloor tile"
	sin69ular_name = "steel techfloor tile"
	icon_state = "tile_steel_techfloor"

/obj/item/stack/tile/floor/steel/techfloor_69rid
	name = "steel techfloor tile with69ents"
	sin69ular_name = "steel techfloor tile with69ents"
	icon_state = "tile_steel_techfloor_69rid"

/obj/item/stack/tile/floor/steel/brown_perforated
	name = "steel brown perforated tile"
	sin69ular_name = "steel brown perforated tile"
	icon_state = "tile_steel_brownperforated"

/obj/item/stack/tile/floor/steel/69ray_perforated
	name = "steel 69ray perforated tile"
	sin69ular_name = "steel 69ray perforated tile"
	icon_state = "tile_steel_69rayperforated"

/obj/item/stack/tile/floor/steel/car69o
	name = "steel car69o tile"
	sin69ular_name = "steel car69o tile"
	icon_state = "tile_steel_car69o"

/obj/item/stack/tile/floor/steel/brown_platform
	name = "steel brown platform tile"
	sin69ular_name = "steel brown platform tile"
	icon_state = "tile_steel_brownplatform"

/obj/item/stack/tile/floor/steel/69ray_platform
	name = "steel 69ray platform tile"
	sin69ular_name = "steel 69ray platform tile"
	icon_state = "tile_steel_69rayplatform"

/obj/item/stack/tile/floor/steel/dan69er
	name = "steel dan69er tile"
	sin69ular_name = "steel dan69er tile"
	icon_state = "tile_steel_dan69er"

/obj/item/stack/tile/floor/steel/69olden
	name = "steel 69olden tile"
	sin69ular_name = "steel 69olden tile"
	icon_state = "tile_steel_69olden"

/obj/item/stack/tile/floor/steel/bluecorner
	name = "steel blue corner tile"
	sin69ular_name = "steel blue corner tile"
	icon_state = "tile_steel_bluecorner"

/obj/item/stack/tile/floor/steel/oran69ecorner
	name = "steel oran69e corner tile"
	sin69ular_name = "steel oran69e corner tilee"
	icon_state = "tile_steel_oran69ecorner"

/obj/item/stack/tile/floor/steel/cyancorner
	name = "steel cyan corner tile"
	sin69ular_name = "steel cyan corner tile"
	icon_state = "tile_steel_cyancorner"

/obj/item/stack/tile/floor/steel/violetcorener
	name = "steel69iolet corener tile"
	sin69ular_name = "steel69iolet corener tile"
	icon_state = "tile_steel_violetcorener"

/obj/item/stack/tile/floor/steel/monofloor
	name = "steel69onofloor tile"
	sin69ular_name = "steel69onofloor tile"
	icon_state = "tile_steel_monofloor"

/obj/item/stack/tile/floor/steel/bar_flat
	name = "steel bar flat tile"
	sin69ular_name = "steel bar flat tile"
	icon_state = "tile_steel_bar_flat"

/obj/item/stack/tile/floor/steel/bar_dance
	name = "steel bar dance tile"
	sin69ular_name = "steel bar dance tile"
	icon_state = "tile_steel_bar_dance"

/obj/item/stack/tile/floor/steel/bar_li69ht
	name = "steel bar li69ht tile"
	sin69ular_name = "steel bar li69ht tile"
	icon_state = "tile_steel_bar_li69ht"

/*
 * Plastic
 */
/obj/item/stack/tile/floor/white
	name = "white floor tile"
	sin69ular_name = "white floor tile"
	desc = "Appears to be69ade out of a li69hter69aterial."
	icon_state = "tile_white"
	throwforce = WEAPON_FORCE_NORMAL
	matter = list(MATERIAL_PLASTIC = 1)

/obj/item/stack/tile/floor/white/panels
	name = "white panel tile"
	sin69ular_name = "white panel tile"
	icon_state = "tile_white_panels"

/obj/item/stack/tile/floor/white/techfloor
	name = "white techfloor tile"
	sin69ular_name = "white techfloor tile"
	icon_state = "tile_white_techfloor"

/obj/item/stack/tile/floor/white/techfloor_69rid
	name = "white techfloor tile with69ents"
	sin69ular_name = "white techfloor tile with69ents"
	icon_state = "tile_white_techfloor_69rid"

/obj/item/stack/tile/floor/white/brown_perforated
	name = "white brown perforated tile"
	sin69ular_name = "white brown perforated tile"
	icon_state = "tile_white_brownperforated"

/obj/item/stack/tile/floor/white/69ray_perforated
	name = "white 69ray perforated tile"
	sin69ular_name = "white 69ray perforated tile"
	icon_state = "tile_white_69rayperforated"

/obj/item/stack/tile/floor/white/car69o
	name = "white car69o tile"
	sin69ular_name = "white car69o tile"
	icon_state = "tile_white_car69o"

/obj/item/stack/tile/floor/white/brown_platform
	name = "white brown platform tile"
	sin69ular_name = "white brown platform tile"
	icon_state = "tile_white_brownplatform"

/obj/item/stack/tile/floor/white/69ray_platform
	name = "white 69ray platform tile"
	sin69ular_name = "white 69ray platform tile"
	icon_state = "tile_white_69rayplatform"

/obj/item/stack/tile/floor/white/dan69er
	name = "white dan69er tile"
	sin69ular_name = "white dan69er tile"
	icon_state = "tile_white_dan69er"

/obj/item/stack/tile/floor/white/69olden
	name = "white 69olden tile"
	sin69ular_name = "white 69olden tile"
	icon_state = "tile_white_69olden"

/obj/item/stack/tile/floor/white/bluecorner
	name = "white blue corner tile"
	sin69ular_name = "white blue corner tile"
	icon_state = "tile_white_bluecorner"

/obj/item/stack/tile/floor/white/oran69ecorner
	name = "white oran69e corner tile"
	sin69ular_name = "white oran69e corner tilee"
	icon_state = "tile_white_oran69ecorner"

/obj/item/stack/tile/floor/white/cyancorner
	name = "white cyan corner tile"
	sin69ular_name = "white cyan corner tile"
	icon_state = "tile_white_cyancorner"

/obj/item/stack/tile/floor/white/violetcorener
	name = "white69iolet corener tile"
	sin69ular_name = "white69iolet corener tile"
	icon_state = "tile_white_violetcorener"

/obj/item/stack/tile/floor/white/monofloor
	name = "white69onofloor tile"
	sin69ular_name = "white69onofloor tile"
	icon_state = "tile_white_monofloor"

/*
 * Steel
 */
/obj/item/stack/tile/floor/dark
	name = "dark floor tile"
	sin69ular_name = "dark floor tile"
	icon_state = "tile_dark"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/stack/tile/floor/dark/panels
	name = "dark panel tile"
	sin69ular_name = "dark panel tile"
	icon_state = "tile_dark_panels"

/obj/item/stack/tile/floor/dark/techfloor
	name = "dark techfloor tile"
	sin69ular_name = "dark techfloor tile"
	icon_state = "tile_dark_techfloor"

/obj/item/stack/tile/floor/dark/techfloor_69rid
	name = "dark techfloor tile with69ents"
	sin69ular_name = "dark techfloor tile with69ents"
	icon_state = "tile_dark_techfloor_69rid"

/obj/item/stack/tile/floor/dark/brown_perforated
	name = "dark brown perforated tile"
	sin69ular_name = "dark brown perforated tile"
	icon_state = "tile_dark_brownperforated"

/obj/item/stack/tile/floor/dark/69ray_perforated
	name = "dark 69ray perforated tile"
	sin69ular_name = "dark 69ray perforated tile"
	icon_state = "tile_dark_69rayperforated"

/obj/item/stack/tile/floor/dark/car69o
	name = "dark car69o tile"
	sin69ular_name = "dark car69o tile"
	icon_state = "tile_dark_car69o"

/obj/item/stack/tile/floor/dark/brown_platform
	name = "dark brown platform tile"
	sin69ular_name = "dark brown platform tile"
	icon_state = "tile_dark_brownplatform"

/obj/item/stack/tile/floor/dark/69ray_platform
	name = "dark 69ray platform tile"
	sin69ular_name = "dark 69ray platform tile"
	icon_state = "tile_dark_69rayplatform"

/obj/item/stack/tile/floor/dark/dan69er
	name = "dark dan69er tile"
	sin69ular_name = "dark dan69er tile"
	icon_state = "tile_dark_dan69er"

/obj/item/stack/tile/floor/dark/69olden
	name = "dark 69olden tile"
	sin69ular_name = "dark 69olden tile"
	icon_state = "tile_dark_69olden"

/obj/item/stack/tile/floor/dark/bluecorner
	name = "dark blue corner tile"
	sin69ular_name = "dark blue corner tile"
	icon_state = "tile_dark_bluecorner"

/obj/item/stack/tile/floor/dark/oran69ecorner
	name = "dark oran69e corner tile"
	sin69ular_name = "dark oran69e corner tilee"
	icon_state = "tile_dark_oran69ecorner"

/obj/item/stack/tile/floor/dark/cyancorner
	name = "dark cyan corner tile"
	sin69ular_name = "dark cyan corner tile"
	icon_state = "tile_dark_cyancorner"

/obj/item/stack/tile/floor/dark/violetcorener
	name = "dark69iolet corener tile"
	sin69ular_name = "dark69iolet corener tile"
	icon_state = "tile_dark_violetcorener"

/obj/item/stack/tile/floor/dark/monofloor
	name = "dark69onofloor tile"
	sin69ular_name = "dark69onofloor tile"
	icon_state = "tile_dark_monofloor"


/obj/item/stack/tile/derelict/white_red_ed69es
	name = "one star floor tile"
	sin69ular_name = "one star floor tile"
	icon_state = "tile_derelict1"

/obj/item/stack/tile/derelict/white_small_ed69es
	name = "one star floor tile"
	sin69ular_name = "one star floor tile"
	icon_state = "tile_derelict2"

/obj/item/stack/tile/derelict/red_white_ed69es
	name = "one star floor tile"
	sin69ular_name = "one star floor tile"
	icon_state = "tile_derelict3"

/obj/item/stack/tile/derelict/white_bi69_ed69es
	name = "one star floor tile"
	sin69ular_name = "one star floor tile"
	icon_state = "tile_derelict4"
