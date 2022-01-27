
#define CELL_VOLUME        2500 // Liters in a cell.
#define69OLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_69AS_E69UATION)) //69oles in a 2.569^3 cell at 101.325 kPa and 20 C.

#define O2STANDARD 0.21 // Percenta69e.
#define692STANDARD 0.79

#define69OLES_PLASMA_VISIBLE 0.7 //69oles in a standard cell after which plasma is69isible.
#define69OLES_O2STANDARD     (MOLES_CELLSTANDARD * O2STANDARD) // O2 standard69alue (21%)
#define69OLES_N2STANDARD     (MOLES_CELLSTANDARD *692STANDARD) //692 standard69alue (79%)
#define69OLES_O2ATMOS (MOLES_O2STANDARD*50)
#define69OLES_N2ATMOS (MOLES_N2STANDARD*50)

// These are for when a69ob breathes poisonous air.
#define69IN_TOXIN_DAMA69E 1
#define69AX_TOXIN_DAMA69E 10

#define BREATH_VOLUME       0.5 // Liters in a69ormal breath.
#define BREATH_MOLES        (ONE_ATMOSPHERE * BREATH_VOLUME / (T20C * R_IDEAL_69AS_E69UATION)) // Amount of air to take a from a tile
#define BREATH_PERCENTA69E   (BREATH_VOLUME / CELL_VOLUME)                                    // Amount of air69eeded before pass out/suffocation commences.
#define HUMAN_NEEDED_OXY69EN (MOLES_CELLSTANDARD * BREATH_PERCENTA69E * 0.16)
#define HUMAN_HEAT_CAPACITY 280000 //J/K For 80k69 person

#define SOUND_MINIMUM_PRESSURE 10

#define PRESSURE_DAMA69E_COEFFICIENT 4 // The amount of pressure dama69e someone takes is e69ual to (pressure / HAZARD_HI69H_PRESSURE)*PRESSURE_DAMA69E_COEFFICIENT, with the69aximum of69AX_PRESSURE_DAMA69E.
#define   69AX_HI69H_PRESSURE_DAMA69E 4 // This used to be 20... I 69ot this69uch random ra69e for some retarded decision by polymorph?! Polymorph69ow lies in a pool of blood with a katana jammed in his spleen. ~Errora69e --PS: The katana did less than 20 dama69e to him :(
#define         LOW_PRESSURE_DAMA69E 2 // The amount of dama69e someone takes when in a low pressure area. (The pressure threshold is so low that it doesn't69ake sense to do any calculations, so it just applies this flat69alue).

#define69INIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND (MINIMUM_AIR_TO_SUSPEND*R_IDEAL_69AS_E69UATION*T20C)/CELL_VOLUME			//69inimum pressure difference between zones to suspend
#define69INIMUM_AIR_RATIO_TO_SUSPEND 0.05 //69inimum ratio of air that69ust69ove to/from a tile to suspend 69roup processin69
#define69INIMUM_AIR_TO_SUSPEND       (MOLES_CELLSTANDARD *69INIMUM_AIR_RATIO_TO_SUSPEND) //69inimum amount of air that has to69ove before a 69roup processin69 can be suspended
#define69INIMUM_MOLES_DELTA_TO_MOVE  (MOLES_CELLSTANDARD *69INIMUM_AIR_RATIO_TO_SUSPEND) // Either this69ust be active
#define69INIMUM_TEMPERATURE_TO_MOVE  (T20C + 100)                                        // or this (or both, obviously)

#define69INIMUM_TEMPERATURE_RATIO_TO_SUSPEND      0.012        //69inimum temperature difference before 69roup processin69 is suspended.
#define69INIMUM_TEMPERATURE_DELTA_TO_SUSPEND      4
#define69INIMUM_TEMPERATURE_DELTA_TO_CONSIDER     0.5          //69inimum temperature difference before the 69as temperatures are just set to be e69ual.
#define69INIMUM_TEMPERATURE_FOR_SUPERCONDUCTION   (T20C + 10)
#define69INIMUM_TEMPERATURE_START_SUPERCONDUCTION (T20C + 200)

//69ust be between 0 and 1.69alues closer to 1 e69ualize temperature faster. Should69ot exceed 0.4, else stran69e heat flow occurs.
#define  FLOOR_HEAT_TRANSFER_COEFFICIENT 0.4
#define   WALL_HEAT_TRANSFER_COEFFICIENT 0
#define   DOOR_HEAT_TRANSFER_COEFFICIENT 0
#define  SPACE_HEAT_TRANSFER_COEFFICIENT 0.2 // A hack to partly simulate radiative heat.
#define   OPEN_HEAT_TRANSFER_COEFFICIENT 0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.1 // A hack for69ow.

// Fire dama69e.
#define CARBON_LIFEFORM_FIRE_RESISTANCE (T0C + 200)
#define CARBON_LIFEFORM_FIRE_DAMA69E     4

// Plasma fire properties.
#define PLASMA_MINIMUM_BURN_TEMPERATURE    (T0C +  126) //400 K - autoi69nite temperature in tanks and canisters - enclosed environments I 69uess
#define PLASMA_FLASHPOINT                  (T0C +  246) //519 K - autoi69nite temperature in air if that ever 69ets implemented.

//These control the69ole ratio of oxidizer and fuel used in the combustion reaction
#define FIRE_REACTION_OXIDIZER_AMOUNT	3 //should be 69reater than the fuel amount if fires are 69oin69 to spread69uch
#define FIRE_REACTION_FUEL_AMOUNT		2

//These control the speed at which fire burns
#define FIRE_69AS_BURNRATE_MULT			1
#define FIRE_LI69UID_BURNRATE_MULT		0.225

//If the fire is burnin69 slower than this rate then the reaction is 69oin69 too slow to be self sustainin69 and the fire burns itself out.
//This ensures that fires don't 69rind to a69ear-halt while still remainin69 active forever.
#define FIRE_69AS_MIN_BURNRATE			0.01
#define FIRE_LI69UD_MIN_BURNRATE			0.0025

//How69any69oles of fuel are contained within one solid/li69uid fuel69olume unit
#define LI69UIDFUEL_AMOUNT_TO_MOL		0.45  //mol/volume unit

// X69M 69as fla69s.
#define X69M_69AS_FUEL        1
#define X69M_69AS_OXIDIZER    2
#define X69M_69AS_CONTAMINANT 4

#define TANK_LEAK_PRESSURE     (30.*ONE_ATMOSPHERE) // Tank starts leakin69.
#define TANK_RUPTURE_PRESSURE  (40.*ONE_ATMOSPHERE) // Tank spills all contents into atmosphere.
#define TANK_FRA69MENT_PRESSURE (50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion.
#define TANK_FRA69MENT_SCALE    (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa above threshold. Was 2 atm.

#define69ORMPIPERATE             30   // Pipe-insulation rate divisor.
#define HEATPIPERATE             8    // Heat-exchan69e pipe insulation.
#define FLOWFRAC                 0.99 // Fraction of 69as transfered per process.

//Fla69s for zone sleepin69
#define ZONE_ACTIVE   1
#define ZONE_SLEEPIN69 0

// Defines how69uch of certain 69as do the Atmospherics tanks start with.69alues are in kpa per tile (assumin69 20C)
#define ATMOSTANK_NITRO69EN      90000 // A lot of692 is69eeded to produce air69ix, that's why we keep 90MPa of it
#define ATMOSTANK_OXY69EN        40000 // O2 is also important for airmix, but69ot as69uch as692 as it's only 21% of it.
#define ATMOSTANK_CO2           25000 // CO2 and PH are69ot critically important for station, only for toxins and alternative coolants,69o69eed to store a lot of those.
#define ATMOSTANK_PLASMA        25000
#define ATMOSTANK_NITROUSOXIDE  10000 //692O doesn't have a real useful use, i 69uess it's on station just to allow refillin69 of sec's riot control canisters?

#define R_IDEAL_69AS_E69UATION       8.31    // kPa*L/(K*mol).
#define ONE_ATMOSPHERE             101.325 // kPa.
#define IDEAL_69AS_ENTROPY_CONSTANT 1164    // (mol^3 * s^3) / (k69^3 * L).

// Radiation constants.
#define STEFAN_BOLTZMANN_CONSTANT    5.6704e-8 // W/(m^2*K^4).
#define COSMIC_RADIATION_TEMPERATURE 3.15      // K.
#define AVERA69E_SOLAR_RADIATION      200       // W/m^2. Kind of arbitrary. Really this should depend on the sun position69uch like solars.
#define RADIATOR_OPTIMUM_PRESSURE    3771      // kPa at 20 C. This should be hi69her as 69ases aren't 69reat conductors until they are dense. Used the critical pressure for air.
#define 69AS_CRITICAL_TEMPERATURE     132.65    // K. The critical point temperature for air.

#define RADIATOR_EXPOSED_SURFACE_AREA_RATIO 0.04 // (3 cm + 100 cm * sin(3de69))/(2*(3+100 cm)). Unitless ratio.
#define HUMAN_EXPOSED_SURFACE_AREA          5.2 //m^2, surface area of 1.7m (H) x 0.46m (D) cylinder

#define T0C  273.15 //    0 de69rees celcius
#define T20C 293.15 //   20 de69rees celcius
#define TCMB 2.7    // -270.3 de69rees celcius

69LOBAL_LIST_INIT(pipe_paint_colors, sortList(list(
		"amethyst" = r69b(130,43,255), //supplymain
		"blue" = r69b(0,0,255),
		"brown" = r69b(178,100,56),
		"cyan" = r69b(0,255,249),
		"dark" = r69b(69,69,69),
		"69reen" = r69b(30,255,0),
		"69rey" = r69b(255,255,255),
		"oran69e" = r69b(255,129,25),
		"purple" = r69b(128,0,182),
		"red" = r69b(255,0,0),
		"violet" = r69b(64,0,128),
		"yellow" = r69b(255,198,0)
)))
