#define DEFAULT_HUNGER_FACTOR 0.05 // Factor of how fast mob nutrition decreases

#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH		1	// splashing
#define CHEM_INGEST		2	// ingestion
#define CHEM_BLOOD		3	// injection

// Atom reagent_flags
#define INJECTABLE		(1<<0)	// Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE		(1<<1)	// Makes it possible to remove reagents through syringes.

#define REFILLABLE		(1<<2)	// Makes it possible to add reagents through any reagent container.
#define DRAINABLE		(1<<3)	// Makes it possible to remove reagents through any reagent container.

#define TRANSPARENT		(1<<4)	// For containers with fully visible reagents.
#define AMOUNT_VISIBLE	(1<<5)	// For non-transparent containers that still have the general amount of reagents in them visible.

#define NO_REACT        (1<<6)  // Applied to a reagent holder, the contents will not react with each other.


// Is an open container for all intents and purposes.
#define OPENCONTAINER 	(REFILLABLE | DRAINABLE | TRANSPARENT)


#define MINIMUM_CHEMICAL_VOLUME 0.01

#define SOLID			1
#define LIQUID			2
#define GAS				3

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 3000 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

#define CE_STABLE			"stabilization"		// Inaprovaline
#define CE_ANTIBIOTIC		"antibiotic"		// Spaceacilin
#define CE_BLOODRESTORE		"blood restoration" // Iron/nutriment
#define CE_PAINKILLER		"painkiller"
#define CE_ALCOHOL			"alcohol" 			// Liver filtering
#define CE_ALCOHOL_TOXIC	"alcohol poisoning" // Liver damage
#define CE_SPEEDBOOST		"agility augment" 	// Hyperzine
#define CE_PULSE			"heart stimulant"	// increases or decreases heart rate
#define CE_NOPULSE			"arresting agent" 	// stops heartbeat
#define CE_MIND				"mind stabilization"// Stabilizes or wrecks mind. Used for hallucinations
#define CE_ANTITOX			"antitoxin"    		// Dylovene
#define CE_TOXIN			"toxin"       		// Generic toxins, stops autoheal.
#define CE_SPEECH_VOLUME	"speech volume"    	// speech volume multiplier , default volume is integer and equals 2
#define CE_BLOODCLOT		"blood clotting"	// Promote healing but thickens blood, slows and stops bleeding (range 0 - 1)
#define CE_OXYGENATED		"oxygenation"       // Dexalin
#define CE_PURGER			"purger"			// Purger
#define CE_NOWITHDRAW 		"withdrawal suppressant"
#define CE_VOICEMIMIC		"voice mimic"
#define CE_DYNAMICFINGERS	"dynamic fingers"
#define CE_BONE_MEND		"bone mending"   	// Ossisine
#define CE_ONCOCIDAL        "anticancer"

// Chem effects for robotic/assisted organs
#define CE_MECH_STABLE 		"cooling"
#define CE_MECH_ACID 		"acid"
#define CE_MECH_LUBE		"lubrication"       // Unused
#define CE_MECH_REPAIR 		"nanite repair"     // Repair damage
#define CE_MECH_REPLENISH 	"nanite replenish"  // Replenish fluid, unused

// Reagent specific heat is not yet implemented, this is here for compatibility reasons
#define SPECIFIC_HEAT_DEFAULT			200
