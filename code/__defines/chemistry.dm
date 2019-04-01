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

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Some on_mob_life() procs check for alien races.
#define IS_XENOS   1

#define CE_STABLE "stable" // Inaprovaline
#define CE_ANTIBIOTIC "antibiotic" // Spaceacilin
#define CE_BLOODRESTORE "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER "painkiller"
#define CE_ALCOHOL "alcohol" // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic" // Liver damage
#define CE_SPEEDBOOST "gofast" // Hyperzine
#define CE_PULSE      "xcardic" // increases or decreases heart rate
#define CE_NOPULSE    "heartstop" // stops heartbeat
