//for style
#define MAX_HUMAN_STYLE 10
#define MIN_HUMAN_STYLE -10
#define STYLE_MODIFIER 0.20

//for desires
#define TASTE_SOUR "sour drink"
#define TASTE_BITTER "bitter drink"
#define TASTE_SWEET "sweet drink"
#define TASTE_STRONG "strong drink"
#define TASTE_LIGHT	"light drink"
#define TASTE_BUBBLY "bubbly drink"
#define TASTE_SPICY "spicy drink"
#define TASTE_SALTY "salty drink"
#define TASTE_SLIMEY "creamy drink"
#define TASTE_REFRESHING "refreshing drink"
#define TASTE_DRY "dry drink"
var/global/list/all_taste_drinks = list(TASTE_SOUR,
								 TASTE_BITTER,
								 TASTE_SWEET,
								 TASTE_STRONG,
								 TASTE_LIGHT,
								 TASTE_BUBBLY,
								 TASTE_SPICY,
								 TASTE_SALTY,
								 TASTE_SLIMEY, //for dense,creamy, solid stuff
								 TASTE_REFRESHING,
								 TASTE_DRY) //for stuff like martinis

#define SWEET_FOOD "sweet food"
#define MEAT_FOOD "meat food"
#define COCO_FOOD "chocolate"
#define	VEGAN_FOOD "vegan food"
#define	VEGETARIAN_FOOD "vegetarian food"
#define	CHEESE_FOOD "cheese"
#define	INSECTS_FOOD "insects"
#define	BLAND_FOOD "bland food"
#define SALTY_FOOD "salty food"
#define SPICY_FOOD "spicy food"
#define FLOURY_FOOD "baked good"
#define UMAMI_FOOD "umami food"

var/global/list/all_types_food = list(SWEET_FOOD,
									MEAT_FOOD,
									COCO_FOOD,
									VEGAN_FOOD,
									VEGETARIAN_FOOD,
									CHEESE_FOOD,
									SALTY_FOOD,
									SPICY_FOOD, // more about well spiced not necessarely HOT spicy
									FLOURY_FOOD, //baked goods
									UMAMI_FOOD, //mostly for shrroms but also some fried and other small foods
									BLAND_FOOD)
