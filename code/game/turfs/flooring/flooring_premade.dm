/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	icon_state = "bcarpet"
	initial_flooring = /decl/flooring/carpet/bcarpet

/turf/simulated/floor/carpet/blucarpet
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /decl/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/turcarpet
	name = "tur carpet"
	icon_state = "turcarpet"
	initial_flooring = /decl/flooring/carpet/turcarpet

/turf/simulated/floor/carpet/sblucarpet
	name = "sblue carpet"
	icon_state = "sblucarpet"
	initial_flooring = /decl/flooring/carpet/sblucarpet

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon_state = "gaycarpet"
	initial_flooring = /decl/flooring/carpet/gaycarpet

/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	icon_state = "purcarpet"
	initial_flooring = /decl/flooring/carpet/purcarpet

/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	icon_state = "oracarpet"
	initial_flooring = /decl/flooring/carpet/oracarpet

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_state = "dirt"

/turf/simulated/floor/hull
	name = "hull"
	icon = 'icons/turf/flooring/hull.dmi'
	icon_state = "hullcenter0"
	initial_flooring = /decl/flooring/hull

/turf/simulated/floor/hull/New()
	if(icon_state != "hullcenter0")
		overrided_icon_state = icon_state
	..()

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/new_tile/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /decl/flooring/tiling/tech

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /decl/flooring/tiling/new_tile
/turf/simulated/floor/tiled/old_tile/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_tile/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_tile/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_tile/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_tile/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_tile/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_tile/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_tile/green
	color = "#46725c"



/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /decl/flooring/tiling/new_tile/cargo_one
/turf/simulated/floor/tiled/old_cargo/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_cargo/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_cargo/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_cargo/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_cargo/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_cargo/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_cargo/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_cargo/green
	color = "#46725c"


/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /decl/flooring/tiling/new_tile/kafel
/turf/simulated/floor/tiled/kafel_full/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/kafel_full/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/kafel_full/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/kafel_full/gray
	color = "#687172"
/turf/simulated/floor/tiled/kafel_full/beige
	color = "#385e60"
/turf/simulated/floor/tiled/kafel_full/red
	color = "#964e51"
/turf/simulated/floor/tiled/kafel_full/purple
	color = "#906987"
/turf/simulated/floor/tiled/kafel_full/green
	color = "#46725c"


/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/tech/grid

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/airmix
	oxygen = MOLES_O2ATMOS
	nitrogen = MOLES_N2ATMOS

/turf/simulated/floor/reinforced/nitrogen
	oxygen = 0
	nitrogen = ATMOSTANK_NITROGEN

/turf/simulated/floor/reinforced/oxygen
	oxygen = ATMOSTANK_OXYGEN
	nitrogen = 0

/turf/simulated/floor/reinforced/phoron
	oxygen = 0
	nitrogen = 0
	phoron = ATMOSTANK_PHORON

/turf/simulated/floor/reinforced/carbon_dioxide
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = ATMOSTANK_CO2

/turf/simulated/floor/reinforced/n20
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/n20/New()
	..()
	sleep(-1)
	if(!air) make_air()
	air.adjust_gas("sleeping_agent", ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/steel
	name = "floor"
	icon_state = "steel_dirty"
	initial_flooring = /decl/flooring/tiling/steel

/turf/simulated/floor/tiled/steel/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/tiled/white
	name = "floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/simulated/floor/tiled/freezer
	name = "floor"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "reinforced floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/airless
	name = "plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/tiled/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	oxygen = 0

/turf/simulated/floor/tiled/white/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Placeholders
/turf/simulated/floor/airless/lava
/turf/simulated/floor/light
/turf/simulated/floor/snow
/turf/simulated/floor/beach/coastline
/turf/simulated/floor/plating/snow
/turf/simulated/floor/airless/ceiling

/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

