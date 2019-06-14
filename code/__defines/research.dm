//#define SHEET_MATERIAL_AMOUNT 1

#define TECH_MATERIAL "materials"
#define TECH_ENGINEERING "engineering"
#define TECH_PLASMA "plasmatech"
#define TECH_POWER "powerstorage"
#define TECH_BLUESPACE "bluespace"
#define TECH_BIO "biotech"
#define TECH_COMBAT "combat"
#define TECH_MAGNET "magnets"
#define TECH_DATA "programming"
#define TECH_ILLEGAL "syndicate"
#define TECH_ARCANE "arcane"

//used in design to specify which machine can build it
#define IMPRINTER		(1<<0)	//For circuits. Uses glass/chemicals.
#define PROTOLATHE		(1<<1)	//New stuff. Uses glass/metal/chemicals
#define AUTOLATHE		(1<<2)

#define MECHFAB			(1<<4)

#define ORGAN_GROWER	(1<<6)
