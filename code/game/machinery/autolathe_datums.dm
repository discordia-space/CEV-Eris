/var/global/list/autolathe_recipes

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes[recipe.type] = recipe

		if(!recipe.path)
			continue

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/reagent
	var/reagent_amount = 0

/datum/autolathe/recipe/corrupted
	name = "ERROR"

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/weapon/reagent_containers/glass/bucket


/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/lighting/toggleable/flashlight


/datum/autolathe/recipe/secflashlight
	name = "security flashlight"
	path = /obj/item/device/lighting/toggleable/flashlight/seclite


/datum/autolathe/recipe/heavyflashlight
	name = "heavy duty flashlight"
	path = /obj/item/device/lighting/toggleable/flashlight/heavy


/datum/autolathe/recipe/penflashlight
	name = "penlight"
	path = /obj/item/device/lighting/toggleable/flashlight/pen


/datum/autolathe/recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light


/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/weapon/extinguisher


/datum/autolathe/recipe/jar
	name = "jar"
	path = /obj/item/glass_jar


/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/weapon/tool/crowbar


/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/weapon/tool/multitool


/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner


/datum/autolathe/recipe/weldertool
	name = "welding tool"
	path = /obj/item/weapon/tool/weldingtool


/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/weapon/tool/screwdriver


/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/weapon/tool/wirecutters


/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/weapon/tool/wrench


/datum/autolathe/recipe/hatchet
	name = "hatchet"
	path = /obj/item/weapon/material/hatchet


/datum/autolathe/recipe/minihoe
	name = "mini hoe"
	path = /obj/item/weapon/material/minihoe


/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset


/datum/autolathe/recipe/radio_bounced
	name = "station bounced radio"
	path = /obj/item/device/radio/off


/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding


/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/weapon/material/knife


/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder


/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/weapon/airlock_electronics


/datum/autolathe/recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/weapon/airalarm_electronics


/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/weapon/firealarm_electronics


/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/weapon/circuitboard/apc

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/weapon/rcd_ammo


/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/weapon/tool/scalpel


/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/weapon/tool/saw/circular


/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/weapon/tool/surgicaldrill


/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/weapon/tool/retractor


/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/weapon/tool/cautery


/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/weapon/tool/hemostat


/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker


/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/large


/datum/autolathe/recipe/vial
	name = "glass vial"
	path = /obj/item/weapon/reagent_containers/glass/beaker/vial


/datum/autolathe/recipe/syringe
	name = "syringe"
	path = /obj/item/weapon/reagent_containers/syringe


/datum/autolathe/recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/weapon/syringe_cartridge


/datum/autolathe/recipe/shotgun_blanks
	name = "ammunition (shotgun, blank)"
	path = /obj/item/ammo_casing/shotgun/blank


/datum/autolathe/recipe/shotgun_beanbag
	name = "ammunition (shotgun, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag


/datum/autolathe/recipe/shotgun_flash
	name = "ammunition (shotgun, flash)"
	path = /obj/item/ammo_casing/shotgun/flash


/datum/autolathe/recipe/magazine_rubber
	name = "ammunition (.45, rubber)"
	path = /obj/item/ammo_magazine/c45m/rubber


/datum/autolathe/recipe/magazine_flash
	name = "ammunition (.45, flash)"
	path = /obj/item/ammo_magazine/c45m/flash


/datum/autolathe/recipe/magazine_smg_rubber
	name = "ammunition (9mm rubber top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber


/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/weapon/stock_parts/console_screen


/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter


/datum/autolathe/recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler


/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra


/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer


/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor


/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/weapon/light/tube


/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/weapon/light/bulb


/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/weapon/material/ashtray/glass


/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/weapon/camera_assembly


/datum/autolathe/recipe/weldinggoggles
	name = "welding goggles"
	path = /obj/item/clothing/glasses/welding


/datum/autolathe/recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/weapon/flamethrower/full


/datum/autolathe/recipe/magazine_revolver_1
	name = "ammunition (.357)"
	path = /obj/item/ammo_magazine/sl357


/datum/autolathe/recipe/magazine_revolver_2
	name = "ammunition (.45)"
	path = /obj/item/ammo_magazine/c45m


/datum/autolathe/recipe/magazine_stetchkin
	name = "ammunition (9mm)"
	path = /obj/item/ammo_magazine/mc9mm


/datum/autolathe/recipe/magazine_stetchkin_flash
	name = "ammunition (9mm, flash)"
	path = /obj/item/ammo_magazine/mc9mm/flash


/datum/autolathe/recipe/magazine_c20r
	name = "ammunition (10mm)"
	path = /obj/item/ammo_magazine/a10mm


/datum/autolathe/recipe/magazine_arifle
	name = "ammunition (7.62mm)"
	path = /obj/item/ammo_magazine/c762


/datum/autolathe/recipe/magazine_smg
	name = "ammunition (9mm top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt


/datum/autolathe/recipe/magazine_carbine
	name = "ammunition (5.56mm)"
	path = /obj/item/ammo_magazine/a556


/datum/autolathe/recipe/shotgun
	name = "ammunition (slug, shotgun)"
	path = /obj/item/ammo_casing/shotgun


/datum/autolathe/recipe/shotgun_pellet
	name = "ammunition (shell, shotgun)"
	path = /obj/item/ammo_casing/shotgun/pellet


/datum/autolathe/recipe/tacknife
	name = "tactical knife"
	path = /obj/item/weapon/material/hatchet/tacknife


/datum/autolathe/recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell


/datum/autolathe/recipe/rcd
	name = "rapid construction device"
	path = /obj/item/weapon/rcd


/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack


/datum/autolathe/recipe/beartrap
	name = "mechanical trap"
	path = /obj/item/weapon/beartrap



/datum/autolathe/recipe/flash
	name = "flash"
	path = /obj/item/device/flash


/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/weapon/handcuffs


/datum/autolathe/recipe/oshoes
	name = "orange shoes"
	path = /obj/item/clothing/shoes/color/orange


/datum/autolathe/recipe/mg_a50_rubber
	name = "magazine (.50 rubber)"
	path = /obj/item/ammo_magazine/a50/rubber


/datum/autolathe/recipe/mg_a50
	name = "magazine (.50)"
	path = /obj/item/ammo_magazine/a50


/datum/autolathe/recipe/SMG_sol_rubber
	name = "magazine (9mm rubber)"
	path = /obj/item/ammo_magazine/sol65/rubber


/datum/autolathe/recipe/SMG_sol_brute
	name = "magazine (9mm hollow point)"
	path = /obj/item/ammo_magazine/sol65


/datum/autolathe/recipe/sl_cl44_rubber
	name = "speed loader (.44 rubber)"
	path = /obj/item/ammo_magazine/sl44/rubber


/datum/autolathe/recipe/sl_cl44_brute
	name = "speed loader (.44 hollow point)"
	path = /obj/item/ammo_magazine/sl44


/datum/autolathe/recipe/mg_cl44_rubber
	name = "magazine (.44 rubber)"
	path = /obj/item/ammo_magazine/cl44/rubber


/datum/autolathe/recipe/mg_cl44_brute
	name = "magazine (.44 hollow point)"
	path = /obj/item/ammo_magazine/cl44


/datum/autolathe/recipe/mg_cl32_rubber
	name = "magazine (.32 rubber)"
	path = /obj/item/ammo_magazine/cl32/rubber


/datum/autolathe/recipe/mg_cl32_brute
	name = "magazine (.32 hollow point)"
	path = /obj/item/ammo_magazine/cl32


