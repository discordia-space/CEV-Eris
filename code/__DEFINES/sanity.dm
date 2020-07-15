//for style
#define MAX_HUMAN_STYLE 14
#define MIN_HUMAN_SYLE -10

//for desires
#define TASTE_SOUR "sour drink"
#define TASTE_BITTER "bitter drink"
#define TASTE_SWEET "sweet drink"
#define TASTE_STRONG "strong drink"
#define TASTE_LIGHT	"light drink"
#define TASTE_BUBBLY "bubbly drink"
#define TASTE_SPICY "spicy drink"
#define TASTE_SALTY "salty drink"

var/global/list/all_taste_drinks = list(TASTE_SOUR,
								 TASTE_BITTER,
								 TASTE_SWEET,
								 TASTE_STRONG,
								 TASTE_LIGHT,
								 TASTE_BUBBLY,
								 TASTE_SPICY,
								 TASTE_SALTY
											)

#define SWEET_FOOD "sweet food"
#define MEAT_FOOD "meat food"
#define COCO_FOOD "chocolate"
#define	VEGAN_FOOD "vegan food"
#define	VEGETARIAN_FOOD "vegetarian food"
#define	CHEESE_FOOD "cheese"
#define	INSECTS_FOOD "insects"
#define	BLAND_FOOD "bland food"

var/global/list/all_types_food = list(SWEET_FOOD,
									MEAT_FOOD,
									COCO_FOOD,
									VEGAN_FOOD,
									VEGETARIAN_FOOD,
									CHEESE_FOOD,
									BLAND_FOOD)
