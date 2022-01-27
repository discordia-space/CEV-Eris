// For convenience and easier comparing and69aintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in credits. atom/movable so we can also assign a price to animals and other things.
// /atom/movable/var/price_tag atoms_movable.dm line: 2269ar/price_tag = 0

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost(export)
	. = price_tag


//***************//
//---Beverages---//
//***************//

/datum/reagent/var/price_tag


// Juices, soda and similar //

/datum/reagent/water
	price_tag = 20

/datum/reagent/drink/juice
	price_tag = 20

/datum/reagent/toxin/poisonberryjuice
	price_tag = 20

/datum/reagent/drink/milk
	price_tag = 20

/datum/reagent/drink/soda
	price_tag = 20

/datum/reagent/drink/doctor_delight
	price_tag = 20

/datum/reagent/drink/nothing
	price_tag = 20

/datum/reagent/drink/milkshake
	price_tag = 20

/datum/reagent/drink/roy_rogers
	price_tag = 20

/datum/reagent/drink/shirley_temple
	price_tag = 20

/datum/reagent/drink/arnold_palmer
	price_tag = 20

/datum/reagent/drink/collins_mix
	price_tag = 20


// Beer //

/datum/reagent/alcohol/ale
	price_tag = 20

/datum/reagent/alcohol/beer
	price_tag = 20


// Hot Drinks //

/datum/reagent/drink/rewriter
	price_tag = 10

/datum/reagent/drink/tea
	price_tag = 10

/datum/reagent/drink/coffee
	price_tag = 10

/datum/reagent/drink/hot_coco
	price_tag = 10

/obj/item/reagent_containers/food
	price_tag = 10

/obj/item/reagent_containers/food/drinks/coffee
	price_tag = 10

/obj/item/reagent_containers/food/drinks/tea
	price_tag = 10

/obj/item/reagent_containers/food/drinks/h_chocolate
	price_tag = 10


// Spirituous liquors //

/datum/reagent/alcohol/irish_cream
	price_tag = 50

/datum/reagent/alcohol/absinthe
	price_tag = 50

/datum/reagent/alcohol/bluecuracao
	price_tag = 50

/datum/reagent/alcohol/deadrum
	price_tag = 50

/datum/reagent/alcohol/gin
	price_tag = 50

/datum/reagent/alcohol/coffee/kahlua
	price_tag = 50

/datum/reagent/alcohol/melonliquor
	price_tag = 50

/datum/reagent/alcohol/rum
	price_tag = 5

/datum/reagent/alcohol/tequilla
	price_tag = 50

/datum/reagent/alcohol/thirteenloko
	price_tag = 50

/datum/reagent/alcohol/vodka
	price_tag = 50

/datum/reagent/alcohol/whiskey
	price_tag = 50

/datum/reagent/alcohol/specialwhiskey
	price_tag = 50

/datum/reagent/alcohol/patron
	price_tag = 50

/datum/reagent/alcohol/goldschlager
	price_tag = 50

/datum/reagent/alcohol/coffee/brave_bull // Not an original liquor in its own. But since it's a69ix of purely Tequila
	price_tag = 50						 // and Kahlua, it's basically just another one and gets the same price.


// Wines //

/datum/reagent/alcohol/wine
	price_tag = 80

/datum/reagent/alcohol/cognac
	price_tag = 80

/datum/reagent/alcohol/sake
	price_tag = 80

/datum/reagent/alcohol/vermouth
	price_tag = 80

/datum/reagent/alcohol/pwine
	price_tag = 80


// Cocktails //
/*
/datum/reagent/alcohol/acid_spit
	price_tag = 40

/datum/reagent/alcohol/alliescocktail
	price_tag = 40

/datum/reagent/alcohol/aloe
	price_tag = 4

/datum/reagent/alcohol/amasec
	price_tag = 4

/datum/reagent/alcohol/andalusia
	price_tag = 4

/datum/reagent/alcohol/antifreeze
	price_tag = 4

/datum/reagent/alcohol/atomicbomb
	price_tag = 4

/datum/reagent/alcohol/coffee/b52
	price_tag = 4

/datum/reagent/alcohol/bahama_mama
	price_tag = 4

/datum/reagent/alcohol/barefoot
	price_tag = 4

/datum/reagent/alcohol/beepsky_smash
	price_tag = 4

/datum/reagent/alcohol/bilk
	price_tag = 4

/datum/reagent/alcohol/black_russian
	price_tag = 4

/datum/reagent/alcohol/bloody_mary
	price_tag = 4

/datum/reagent/alcohol/booger
	price_tag = 4

/datum/reagent/alcohol/brave_bull
	price_tag = 4

/datum/reagent/alcohol/changeling_sting
	price_tag = 4

/datum/reagent/alcohol/martini
	price_tag = 4

/datum/reagent/alcohol/cuba_libre
	price_tag = 4

/datum/reagent/alcohol/demonsblood
	price_tag = 4

/datum/reagent/alcohol/devilskiss
	price_tag = 4

/datum/reagent/alcohol/driestmartini
	price_tag = 4

/datum/reagent/alcohol/ginfizz
	price_tag = 4

/datum/reagent/alcohol/grog
	price_tag = 4

/datum/reagent/alcohol/erikasurprise
	price_tag = 4

/datum/reagent/alcohol/gargle_blaster
	price_tag = 4

/datum/reagent/alcohol/gintonic
	price_tag = 4

/datum/reagent/alcohol/hippies_delight
	price_tag = 4

/datum/reagent/alcohol/hooch
	price_tag = 4

/datum/reagent/alcohol/iced_beer
	price_tag = 4

/datum/reagent/alcohol/irishcarbomb
	price_tag = 4

/datum/reagent/alcohol/coffee/irishcoffee
	price_tag = 4

/datum/reagent/alcohol/longislandicedtea
	price_tag = 4

/datum/reagent/alcohol/manhattan
	price_tag = 4

/datum/reagent/alcohol/manhattan_proj
	price_tag = 4

/datum/reagent/alcohol/manly_dorf
	price_tag = 4

/datum/reagent/alcohol/margarita
	price_tag = 4

/datum/reagent/alcohol/mead
	price_tag = 4

/datum/reagent/alcohol/moonshine
	price_tag = 4

/datum/reagent/alcohol/neurotoxin
	price_tag = 4

/datum/reagent/alcohol/red_mead
	price_tag = 4

/datum/reagent/alcohol/sbiten
	price_tag = 4

/datum/reagent/alcohol/screwdrivercocktail
	price_tag = 4

/datum/reagent/alcohol/silencer
	price_tag = 4

/datum/reagent/alcohol/singulo
	price_tag = 4

/datum/reagent/alcohol/snowwhite
	price_tag = 4

/datum/reagent/alcohol/suidream
	price_tag = 4

/datum/reagent/alcohol/syndicatebomb
	price_tag = 4

/datum/reagent/alcohol/tequillasunrise
	price_tag = 4

/datum/reagent/alcohol/threemileisland
	price_tag = 4

/datum/reagent/alcohol/toxins_special
	price_tag = 4

/datum/reagent/alcohol/vodkamartini
	price_tag = 4

/datum/reagent/alcohol/vodkatonic
	price_tag = 4

/datum/reagent/alcohol/white_russian
	price_tag = 4

/datum/reagent/alcohol/whiskey_cola
	price_tag = 4

/datum/reagent/alcohol/whiskeysoda
	price_tag = 4


// Cocktails without alcohol //

/datum/reagent/alcohol/bananahonk
	price_tag = 3

*/

// From the69achine //

/obj/item/reagent_containers/food/drinks/cans/cola
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/starkist
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	price_tag = 15

/obj/item/reagent_containers/food/drinks/cans/space_up
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	price_tag = 10

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	price_tag = 10


//***************//
//----Bottles----//
//***************//

// Juices, soda and similar //

/obj/item/reagent_containers/food/drinks/bottle/cola
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/space_up
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/cream
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	price_tag = 60

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	price_tag = 60


// Beer //

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	price_tag = 80

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	price_tag = 80


// Spirituous Liquors //

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/gin
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/rum
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/tequilla
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/vodka
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	price_tag = 150


/obj/item/reagent_containers/food/drinks/bottle/patron
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	price_tag = 150

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	price_tag = 150


// Wines //

/obj/item/reagent_containers/food/drinks/bottle/wine
	price_tag = 250

/obj/item/reagent_containers/food/drinks/bottle/cognac
	price_tag = 250

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	price_tag = 250

/obj/item/reagent_containers/food/drinks/bottle/pwine
	price_tag = 250


//***************//
//---Foodstuff---//
//***************//

// Snacks //
/obj/item/reagent_containers/food/snacks
	price_tag = 30

/obj/item/reagent_containers/food/snacks/shokoloud
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sosjerky
	price_tag = 20

/obj/item/reagent_containers/food/snacks/unajerky
	price_tag = 120

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	price_tag = 10

/obj/item/reagent_containers/food/snacks/tastybread
	price_tag = 20

/obj/item/reagent_containers/food/snacks/no_raisin
	price_tag = 10

/obj/item/reagent_containers/food/snacks/spacetwinkie
	price_tag = 10


/obj/item/reagent_containers/food/snacks/chips
	price_tag = 10

/obj/item/reagent_containers/food/drinks/dry_ramen
	price_tag = 50


// Burger //

/obj/item/reagent_containers/food/snacks/brainburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/ghostburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/human/burger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/cheeseburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/monkeyburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/fishburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/tofuburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/roburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/roburgerbig
	price_tag = 20

/obj/item/reagent_containers/food/snacks/xenoburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/clownburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/mimeburger
	price_tag = 20

/obj/item/reagent_containers/food/snacks/spellburger
	price_tag = 49.9

/obj/item/reagent_containers/food/snacks/jellyburger
	price_tag = 35

/obj/item/reagent_containers/food/snacks/bigbiteburger
	price_tag = 89.9

/obj/item/reagent_containers/food/snacks/superbiteburger
	price_tag = 139


// Sandwiches //

/obj/item/reagent_containers/food/snacks/sandwich
	price_tag = 15

/obj/item/reagent_containers/food/snacks/toastedsandwich
	price_tag = 15

/obj/item/reagent_containers/food/snacks/grilledcheese
	price_tag = 15

/obj/item/reagent_containers/food/snacks/jellysandwich
	price_tag = 15


// Cookies and Candies //

/obj/item/reagent_containers/food/snacks/cookie
	price_tag = 10

/obj/item/reagent_containers/food/snacks/chocolatebar
	price_tag = 10

/obj/item/reagent_containers/food/snacks/chocolateegg
	price_tag = 10

/obj/item/reagent_containers/food/snacks/candy_corn
	price_tag = 10

/obj/item/reagent_containers/food/snacks/donut
	price_tag = 10

/obj/item/reagent_containers/food/snacks/donut/chaos
	price_tag = 25

/obj/item/reagent_containers/food/snacks/popcorn
	price_tag = 15

/obj/item/reagent_containers/food/snacks/fortunecookie
	price_tag = 10

/obj/item/reagent_containers/food/snacks/candiedapple
	price_tag = 20

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	price_tag = 10

/obj/item/reagent_containers/food/snacks/chawanmushi
	price_tag = 20

/obj/item/reagent_containers/food/snacks/cracker
	price_tag = 10


// Full69eals //

/obj/item/reagent_containers/food/snacks/friedegg
	price_tag = 25

/obj/item/reagent_containers/food/snacks/tofurkey
	price_tag = 25

/obj/item/reagent_containers/food/snacks/meat/carp
	price_tag = 200
/obj/item/reagent_containers/food/snacks/meat
	price_tag = 100
/obj/item/reagent_containers/food/snacks/meat/corgi
	price_tag = 500
/obj/item/reagent_containers/food/snacks/fishfingers
	price_tag = 25

/obj/item/reagent_containers/food/snacks/omelette
	price_tag = 25

/obj/item/reagent_containers/food/snacks/berryclafoutis
	price_tag = 25

/obj/item/reagent_containers/food/snacks/waffles
	price_tag = 25

/obj/item/reagent_containers/food/snacks/eggplantparm
	price_tag = 25

/obj/item/reagent_containers/food/snacks/soylentgreen
	price_tag = 25

/obj/item/reagent_containers/food/snacks/soylenviridians
	price_tag = 25

/obj/item/reagent_containers/food/snacks/wingfangchu
	price_tag = 25

/obj/item/reagent_containers/food/snacks/kabob
	price_tag = 25

/obj/item/reagent_containers/food/snacks/monkeykabob
	price_tag = 25

/obj/item/reagent_containers/food/snacks/tofukabob
	price_tag = 25

/obj/item/reagent_containers/food/snacks/cubancarp
	price_tag = 25

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	price_tag = 25

/obj/item/reagent_containers/food/snacks/fries
	price_tag = 25

/obj/item/reagent_containers/food/snacks/spagetti
	price_tag = 25

/obj/item/reagent_containers/food/snacks/cheesyfries
	price_tag = 25

/obj/item/reagent_containers/food/snacks/enchiladas
	price_tag = 25

/obj/item/reagent_containers/food/snacks/taco
	price_tag = 25

/obj/item/reagent_containers/food/snacks/monkeysdelight
	price_tag = 25

/obj/item/reagent_containers/food/snacks/fishandchips
	price_tag = 40

/obj/item/reagent_containers/food/snacks/rofflewaffles
	price_tag = 25

/obj/item/reagent_containers/food/snacks/stew
	price_tag = 25

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	price_tag = 25

/obj/item/reagent_containers/food/snacks/boiledspagetti
	price_tag = 25

/obj/item/reagent_containers/food/snacks/boiledrice
	price_tag = 25

/obj/item/reagent_containers/food/snacks/ricepudding
	price_tag = 25

/obj/item/reagent_containers/food/snacks/pastatomato
	price_tag = 25

/obj/item/reagent_containers/food/snacks/meatballspagetti
	price_tag = 25

/obj/item/reagent_containers/food/snacks/spesslaw
	price_tag = 25

/obj/item/reagent_containers/food/snacks/carrotfries
	price_tag = 25

/obj/item/reagent_containers/food/snacks/appletart
	price_tag = 25

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	price_tag = 25

/obj/item/reagent_containers/food/snacks/slice/margherita
	price_tag = 10

/obj/item/reagent_containers/food/snacks/slice/meatpizza
	price_tag = 10

/obj/item/reagent_containers/food/snacks/slice/mushroompizza
	price_tag = 10

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	price_tag = 10


// Baked Goods //

/obj/item/reagent_containers/food/snacks/poppypretzel
	price_tag = 20

/obj/item/reagent_containers/food/snacks/baguette
	price_tag = 20

/obj/item/reagent_containers/food/snacks/jelliedtoast
	price_tag = 10

/obj/item/reagent_containers/food/snacks/twobread
	price_tag = 20

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/meatbread
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/xenomeatbread
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/bananabread
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/tofubread
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/bread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/bread
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	price_tag = 50

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	price_tag = 10


// Soups //

/obj/item/reagent_containers/food/snacks/meatballsoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/slimesoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/bloodsoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/clownstears
	price_tag = 30

/obj/item/reagent_containers/food/snacks/vegetablesoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/nettlesoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/mysterysoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/wishsoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/hotchili
	price_tag = 30

/obj/item/reagent_containers/food/snacks/coldchili
	price_tag = 30

/obj/item/reagent_containers/food/snacks/tomatosoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/milosoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/mushroomsoup
	price_tag = 30

/obj/item/reagent_containers/food/snacks/beetsoup
	price_tag = 30


// Pies //

/obj/item/reagent_containers/food/snacks/pie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/meatpie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/tofupie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/plump_pie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/xemeatpie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/applepie
	price_tag = 40

/obj/item/reagent_containers/food/snacks/cherrypie
	price_tag = 40


// Cakes //
/obj/item/reagent_containers/food/snacks/slice
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sliceable/get_item_cost(export)
	. = ..() + SStrade.get_import_cost(slice_path) * slices_num

//69isc //
/obj/item/reagent_containers/food/snacks/egg
	price_tag = 5
/obj/item/reagent_containers/food/snacks/boiledegg
	price_tag = 5

/obj/item/reagent_containers/food/snacks/donkpocket
	price_tag = 10

/obj/item/reagent_containers/food/snacks/sausage
	price_tag = 20

/obj/item/reagent_containers/food/snacks/muffin
	price_tag = 20

/obj/item/reagent_containers/food/snacks/tossedsalad
	price_tag = 20

/obj/item/reagent_containers/food/snacks/validsalad
	price_tag = 20

/obj/item/reagent_containers/food/snacks/dionaroast
	price_tag = 250

/obj/item/reagent_containers/food/snacks/csandwich
	price_tag = 50

/obj/item/pizzabox/get_item_cost()
	. = pizza?.get_item_cost()


//***************//
//----Smokes-----//
//***************//

/obj/item/clothing/mask/smokable
	price_tag = 5 //cigarette69onopoly no69ore

/obj/item/flame/lighter
	price_tag = 20

/obj/item/flame/lighter/zippo
	price_tag = 50

/obj/item/bluespace_crystal
	price_tag = 500

/obj/item/storage/get_item_cost(export)
	. = ..()
	for(var/atom/movable/i in src)
		. += SStrade.get_new_cost(i)

/obj/machinery
	price_tag = 100

/obj/machinery/get_item_cost(export)
	. = ..()
	for(var/atom/movable/i in component_parts)
		. += SStrade.get_new_cost(i)

/obj/machinery/portable_atmospherics
	price_tag = 200

/obj/machinery/power/emitter/price_tag = 2000
/obj/machinery/power/supermatter
	price_tag = 10000

/obj/machinery/portable_atmospherics/canister/get_item_cost(export)
	. = price_tag + (price_tag * log(10, air_contents.volume)) //todo, prices of gases

/obj/structure/reagent_dispensers/price_tag = 5
/obj/structure/reagent_dispensers/get_item_cost()
	var/ratio = reagents.total_volume / reagents.maximum_volume

	return ..() + round(contents_cost * ratio)


/obj/item/tank
	price_tag = 50
/obj/item/tank/plasma
	price_tag = 75
/obj/item/tank/get_item_cost(export)
	. = price_tag + (price_tag * log(10, air_contents.volume)) //todo, prices of gases

/obj/item/electronics/circuitboard
	price_tag = 150

/obj/item/electronics/circuitboard/get_item_cost(export)
	. = ..()
	for(var/atom/movable/i in req_components)
		if(ispath(i))
			. += SStrade.get_new_cost(i) * log(10, price_tag / 2)

/obj/item/stock_parts
	price_tag = 100

/obj/item/stock_parts/get_item_cost(export)
	. = ..() * rating

/obj/item/organ
	price_tag = 500

/mob/living/exosuit/get_item_cost(export)
	. = ..() + SStrade.get_import_cost(body)

/obj/item/stack/get_item_cost(export)
	return amount * ..()

/obj/item/ammo_magazine/price_tag = 60

/obj/item/ammo_magazine/ammobox/price_tag = 40

/obj/item/ammo_magazine/get_item_cost(export)
	. = ..()
	for(var/obj/item/ammo_casing/i in stored_ammo)
		. += i.get_item_cost(export)

/obj/item/ammo_casing/price_tag = 0.2
/obj/item/ammo_casing/shotgun/price_tag = 1

/obj/item/ammo_casing/get_item_cost(export)
	. = round(..() * amount)
/obj/item/tool/price_tag = 20

// This one is exploitable as fuck. I say should be removed or nerfed hard.
///obj/item/tool/get_item_cost(export)
//	. = 1
//	for(var/i in tool_qualities)
//		. += tool_qualities69i69 / 5
//	. *= ..()

/obj/structure/medical_stand/price_tag = 100
/obj/item/virusdish/price_tag = 300

/obj/item/reagent_containers/price_tag = 20
/obj/item/reagent_containers/glass/beaker/bluespace/price_tag = 300
/obj/item/reagent_containers/get_item_cost(export)
	. = ..()
	. += reagents?.get_price() //TODO assign an apprpriate price_per_unit

/obj/item/reagent_containers/blood
	price_tag = 50

/obj/item/clothing/price_tag = 30

/obj/item/solar_assembly/price_tag = 100
/obj/item/tracker_electronics/price_tag = 150
/obj/item/electronics/tracker/price_tag = 120
/obj/item/handcuffs/price_tag = 30
/obj/item/handcuffs/get_item_cost(export)
	. = ..()
	. += breakouttime / 20

/obj/item/grenade/price_tag = 50

/obj/item/robot_parts/price_tag = 100
/obj/item/robot_parts/robot_component/armour/exosuit/plain/price_tag = 300
/obj/item/robot_parts/robot_component/armour/exosuit/radproof/price_tag = 500
/obj/item/robot_parts/robot_component/armour/exosuit/ablative/price_tag = 550
/obj/item/robot_parts/robot_component/armour/exosuit/combat/price_tag = 1000

/obj/item/mech_component/price_tag = 150
/obj/item/mech_equipment/price_tag = 200

/obj/item/inflatable/price_tag = 40

/obj/item/tool/knife/dagger/bluespace/price_tag = 400

/obj/item/reagent_containers/food/snacks/meat/roachmeat/price_tag = 75
/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche/price_tag = 100
/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk/price_tag = 100
/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager/price_tag = 125

/obj/item/toy/price_tag = 40
/obj/item/device/toner/price_tag = 50

/obj/item/device/camera_film/price_tag = 25

/obj/item/device/camera/price_tag = 50
/obj/item/storage/photo_album/price_tag = 50

/obj/item/wrapping_paper/price_tag = 20
/obj/item/packageWrap/price_tag = 20
/obj/item/mop/price_tag = 15
/obj/item/caution/price_tag = 10
/obj/item/storage/bag/trash/price_tag = 25

/obj/item/storage/lunchbox/price_tag = 25

/obj/item/storage/briefcase/price_tag = 50
/obj/item/soap/nanotrasen/price_tag = 60
/obj/item/storage/pouch/price_tag = 100
/obj/item/storage/pouch/ammo/price_tag = 200
/obj/item/storage/pouch/tubular/price_tag = 140
/obj/item/storage/pouch/medium_generic/price_tag = 255
/obj/item/storage/pouch/large_generic/price_tag = 410

/obj/item/rig/price_tag = 150
/obj/item/rig/industrial/price_tag = 350
/obj/item/rig/hazmat/price_tag = 350
/obj/item/rig/combat/price_tag = 500
/obj/item/rig_module/price_tag = 500
//***************//
//----ORES-----//
//***************//
/obj/item/ore/price_tag = 1
/obj/item/ore/uranium/price_tag = 10
/obj/item/ore/iron/price_tag = 2
/obj/item/ore/coal/price_tag = 2
/obj/item/ore/glass/price_tag = 1
/obj/item/ore/plasma/price_tag = 5
/obj/item/ore/silver/price_tag = 5
/obj/item/ore/gold/price_tag = 5
/obj/item/ore/diamond/price_tag = 20
/obj/item/ore/osmium/price_tag = 5
/obj/item/ore/hydrogen/price_tag = 5
/obj/item/ore/slag/price_tag = 1

