/datum/design/autolathe/container/drinkingglass
	name = "drinking glass"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/drinkingglass

/datum/design/autolathe/container/carafe
	name = "glass pitcher"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/carafe

/datum/design/autolathe/container/insulated_pitcher
	name = "insulated pitcher"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher

/datum/design/autolathe/container/bucket
	name = "bucket"
	build_path = /obj/item/weapon/reagent_containers/glass/bucket

/datum/design/autolathe/container/beaker
	name = "glass beaker"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker

/datum/design/autolathe/container/beaker_large
	name = "large glass beaker"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/large

/datum/design/autolathe/container/mixingbowl
	name = "mixing bowl"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bowl

/datum/design/autolathe/container/vial
	name = "glass vial"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/vial

/datum/design/autolathe/container/jar
	name = "jar"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/jar

/datum/design/autolathe/container/syringe
	name = "syringe"
	build_path = /obj/item/weapon/reagent_containers/syringe
/datum/design/autolathe/container/syringe/large
	name = "Large syringe"
	build_path = /obj/item/weapon/reagent_containers/syringe/large
/datum/design/autolathe/container/syringegun_ammo
	name = "syringe gun cartridge"
	build_path = /obj/item/weapon/syringe_cartridge

/datum/design/autolathe/container/spray
	name = "spray bottle"
	build_path = /obj/item/weapon/reagent_containers/spray

/datum/design/autolathe/container/pill_bottle
	name = "pill bottle"
	build_path = /obj/item/weapon/storage/pill_bottle

/datum/design/autolathe/container/freezer
	name = "portable freezer"
	build_path = /obj/item/weapon/storage/freezer

/datum/design/autolathe/container/freezer_medical
	name = "organ freezer"
	build_path = /obj/item/weapon/storage/freezer/medical
	
/datum/design/autolathe/container/flask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	
/datum/design/autolathe/container/vacuumflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	
/datum/design/autolathe/container/white_mug
	name = "white coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug
	
/datum/design/autolathe/container/black_mug
	name = "black coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/black
	
/datum/design/autolathe/container/green_mug
	name = "green coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/green
	
/datum/design/autolathe/container/blue_mug
	name = "blue coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/blue
	
/datum/design/autolathe/container/red_mug
	name = "red coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/red
	
/datum/design/autolathe/container/metal_mug
	name = "metal coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/metal
	
/datum/design/autolathe/container/metal_mug
	name = "metal coffee mug"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/mug/metal
	
// prefilled booze

/datum/design/autolathe/container/prefilled/beer
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer
	chemicals = list(
	"ethanol" = 5,
	"water" = 25
	)
	
/datum/design/autolathe/container/prefilled/ale
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale
	chemicals = list(
	"ethanol" = 10, // i think ale has a slightly higher alcohol content than beer
	"water" = 20
	)
	
/datum/design/autolathe/container/prefilled/wine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/wine
	chemicals = list(
	"ethanol" = 40,
	"water" = 20,
	"grapejuice" = 40
	)
	
/datum/design/autolathe/container/prefilled/vodka
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/vodka
	chemicals = list(
	"ethanol" = 50,
	"water" = 20,
	"potatojuice" = 30
	)
	
/datum/design/autolathe/container/prefilled/gin
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/gin
	chemicals = list(
	"ethanol" = 40,
	"water" = 30,
	"berryjuice" = 30 // juniper berries, i guess?
	)
	
/datum/design/autolathe/container/prefilled/rum
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/rum
	chemicals = list(
	"ethanol" = 40,
	"water" = 20,
	"sugar" = 40
	)
	
/datum/design/autolathe/container/prefilled/whiskey
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey
	chemicals = list(
	"ethanol" = 60, 
	"flour" = 40 // alright i'm totally butchering the recipe for making whiskey, please let me know if you have a better chem to use here - also, can't use water because water+flour makes dough
	)
	
// prefilled soda

/datum/design/autolathe/container/prefilled/soda
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/cola
	chemicals = list(
	"sugar" = 20, // basic, crappy cola consists of mostly sugar to imitate 'flavoring' - doesn't have a really unique taste to it
	"sodawater" = 10
	)
	
/datum/design/autolathe/container/prefilled/spacemountainwind
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	chemicals = list(
	"sugar" = 10,
	"lemonjuice" = 10, // gives the drink it's citrus-y taste
	"sodawater" = 10
	)
	
/datum/design/autolathe/container/prefilled/gibb
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	chemicals = list(
	"sugar" = 10,
	"berryjuice" = 10, // mixture of berries in the juice give gibb all it's flavors! amazing!
	"sodawater" = 10
	)
	
/datum/design/autolathe/container/prefilled/spaceup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	chemicals = list(
	"sugar" = 10,
	"limejuice" = 10, // i don't really know what tastes like a hull breach, so i'm just going to assume it's an alternate form of citric acid
	"sodawater" = 10
	)

/datum/design/autolathe/container/prefilled/lemonlime
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	chemicals = list(
	"sugar" = 10,
	"limejuice" = 5,
	"lemonjuice" = 5,
	"sodawater" = 10
	)
	
/datum/design/autolathe/container/prefilled/starkist
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	chemicals = list(
	"sugar" = 10,
	"orangejuice" = 10,
	"sodawater" = 10
	)

/datum/design/autolathe/container/prefilled/thirteenloko
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	chemicals = list(
	"sugar" = 5,
	"ethanol" = 15, // a metric shit ton of alcohol - 50% of the drink is straight booze
	"coffee" = 15, // the other half is straight-up coffee
	"sodawater" = 5
	)


// prefilled misc.

/datum/design/autolathe/container/prefilled/sodawater // mostly here so people without a dispenser can make soda
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	chemicals = list(
	"water" = 50,
	"carbon" = 5 // carbon is "lost" in this recipe, as the can only contains 50 units of soda water instead of 55
	)

/datum/design/autolathe/container/prefilled/water
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	chemicals = list(
	"water" = 30 // it's literally a bottle of mineral(?) water
	)
