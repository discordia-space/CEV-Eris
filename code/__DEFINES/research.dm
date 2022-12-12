#define TECH_MATERIAL "materials"
#define TECH_ENGINEERING "engineering"
#define TECH_PLASMA "plasmatech"
#define TECH_POWER "powerstorage"
#define TECH_BLUESPACE "bluespace"
#define TECH_BIO "biotech"
#define TECH_COMBAT "combat"
#define TECH_MAGNET "magnets"
#define TECH_DATA "programming"
#define TECH_COVERT "covert"
#define TECH_ARCANE "arcane"

//used in design to specify which machine can build it
#define IMPRINTER		(1<<0)	//For circuits. Uses glass/chemicals.
#define PROTOLATHE		(1<<1)	//New stuff. Uses glass/metal/chemicals
#define AUTOLATHE		(1<<2)
#define BIOPRINTER		(1<<3)

#define MECHFAB			(1<<4)

#define ORGAN_GROWER	(1<<6)


#define RESEARCH_ENGINEERING   /datum/tech/engineering
#define RESEARCH_BIOTECH       /datum/tech/biotech
#define RESEARCH_COMBAT        /datum/tech/combat
#define RESEARCH_POWERSTORAGE  /datum/tech/powerstorage
#define RESEARCH_BLUESPACE     /datum/tech/bluespace
#define RESEARCH_ROBOTICS      /datum/tech/robotics
#define RESEARCH_COVERT        /datum/tech/covert


// Design categories
#define CAT_MISC        "Misc"
#define CAT_COMP        "Computers"
#define CAT_AI          "AI"
#define CAT_POWER       "Power"
#define CAT_MACHINE     "Machines"
#define CAT_TCOM        "Telecommunications"
#define CAT_BLUE        "Bluespace"
#define CAT_WEAPON      "Weapons"
#define CAT_ROBOT       "Robot"
#define CAT_STOCKPARTS  "Stock Parts"
#define CAT_PROSTHESIS  "Prosthesis"
#define CAT_MINING      "Mining"
#define CAT_MECH        "Exosuits"
#define CAT_MODCOMP     "Modular Computers"
#define CAT_CIRCUITS    "Circuits"
#define CAT_MEDI        "Medical"
#define CAT_TOOLMODS    "Toolmods"
#define CAT_GUNMODS     "Gunmods"

//Autolathe defines
#define ERR_OK 0
#define ERR_NOTFOUND "not found"
#define ERR_NOMATERIAL "no material"
#define ERR_NOREAGENT "no reagent"
#define ERR_NOLICENSE "no license"
#define ERR_PAUSED "paused"
#define ERR_NOINSIGHT "no insight"
#define ERR_NOODDITY "no oddity"
