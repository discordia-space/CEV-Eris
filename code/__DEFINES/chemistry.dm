#define DEFAULT_HUN69ER_FACTOR 0.05 // Factor of how fast69ob69utrition decreases

#define REM 0.2 //69eans 'Rea69ent Effect69ultiplier'. This is how69any units of rea69ent are consumed per tick

#define CHEM_TOUCH		1	// splashin69
#define CHEM_IN69EST		2	// in69estion
#define CHEM_BLOOD		3	// injection

// Atom rea69ent_fla69s
#define INJECTABLE		(1<<0)	//69akes it possible to add rea69ents throu69h droppers and syrin69es.
#define DRAWABLE		(1<<1)	//69akes it possible to remove rea69ents throu69h syrin69es.

#define REFILLABLE		(1<<2)	//69akes it possible to add rea69ents throu69h any rea69ent container.
#define DRAINABLE		(1<<3)	//69akes it possible to remove rea69ents throu69h any rea69ent container.

#define TRANSPARENT		(1<<4)	// For containers with fully69isible rea69ents.
#define AMOUNT_VISIBLE	(1<<5)	// For69on-transparent containers that still have the 69eneral amount of rea69ents in them69isible.

#define69O_REACT        (1<<6)  // Applied to a rea69ent holder, the contents will69ot react with each other.


// Is an open container for all intents and purposes.
#define OPENCONTAINER 	(REFILLABLE | DRAINABLE | TRANSPARENT)


#define69INIMUM_CHEMICAL_VOLUME 0.01

#define SOLID			1
#define LI69UID			2
#define 69AS				3

#define REA69ENTS_OVERDOSE 30

#define REA69ENTS_MIN_EFFECT_MULTIPLIER 0.2
#define REA69ENTS_MAX_EFFECT_MULTIPLIER 2.5

#define CHEM_SYNTH_ENER69Y 3000 // How69uch ener69y does it take to synthesize 1 unit of chemical, in Joules.

#define CE_STABLE "stable" // Inaprovaline
#define CE_ANTIBIOTIC "antibiotic" // Spaceacilin
#define CE_BLOODRESTORE "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER "painkiller"
#define CE_ALCOHOL "alcohol" // Liver filterin69
#define CE_ALCOHOL_TOXIC "alcotoxic" // Liver dama69e
#define CE_SPEEDBOOST "69ofast" // Hyperzine
#define CE_PULSE      "xcardic" // increases or decreases heart rate
#define CE_NOPULSE    "heartstop" // stops heartbeat
#define CE_MIND    		 "mindbendin69"  // Stabilizes or wrecks69ind. Used for hallucinations
#define CE_ANTITOX       "antitox"      // Dylovene
#define CE_TOXIN         "toxins"       // 69eneric toxins, stops autoheal.
#define CE_SPEECH_VOLUME     "speach_volume"    // speech69olume69ultiplier , default69olume is inte69er and e69uals 2
#define CE_BLOODCLOT 	"bloodclot"	// Promote healin69 but thickens blood, slows and stops bleedin69 (ran69e 0 - 1)
#define CE_OXY69ENATED    "oxy69en"       // Dexalin.
#define CE_PUR69ER "pur69er"	//Pur69er
#define CE_NOWITHDRAW "no_withdrawal" 
#define CE_VOICEMIMIC "voice_mimic"
#define CE_DYNAMICFIN69ERS "dynfin69ers"

// Rea69ent specific heat is69ot yet implemented, this is here for compatibility reasons
#define SPECIFIC_HEAT_DEFAULT			200
