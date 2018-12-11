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
	flags = TURF_HAS_CORNERS
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



/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/techmaint

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon_state = "techfloor_gray"
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /decl/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "monotile"
	initial_flooring = /decl/flooring/tiling/monotile



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

/turf/simulated/floor/reinforced/plasma
	oxygen = 0
	nitrogen = 0
	plasma = ATMOSTANK_PLASMA

/turf/simulated/floor/reinforced/carbon_dioxide
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = ATMOSTANK_CO2

/turf/simulated/floor/reinforced/n20
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/engine
	oxygen = 825
	nitrogen = 0
	plasma = 2500
	temperature = 374

/turf/simulated/floor/reinforced/n20/New()
	..()
	sleep(-1)
	if(!air) make_air()
	air.adjust_gas("sleeping_agent", ATMOSTANK_NITROUSOXIDE)

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

