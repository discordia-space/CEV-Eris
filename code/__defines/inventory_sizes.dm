// The below should be used to define an item's w_class variable.
// Example: w_class = ITEM_SIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.
#define ITEM_SIZE_TINY           1
#define ITEM_SIZE_SMALL          2
#define ITEM_SIZE_NORMAL         3
#define ITEM_SIZE_LARGE          4
#define ITEM_SIZE_HUGE           5
#define ITEM_SIZE_GARGANTUAN     6
#define ITEM_SIZE_NO_CONTAINER INFINITY // Use this to forbid item from being placed in a container.

/*
	The values below are not yet in use.
*/

#define BASE_STORAGE_COST(w_class) (2**(w_class-1)) //1,2,4,8,16,...
#define REDUCED_STORAGE_COST(w_class) (2**(w_class-2)) //0.5,1,2,4,8,...

//linear increase. Using many small storage containers is more space-efficient than using large ones,
//in exchange for being limited in the w_class of items that will fit
#define BASE_STORAGE_CAPACITY(w_class) (7*(w_class-1))

#define DEFAULT_BACKPACK_STORAGE  BASE_STORAGE_CAPACITY(6) 	//35 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_BELT_STORAGE      BASE_STORAGE_CAPACITY(5)  //28 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_SATCHEL_STORAGE   BASE_STORAGE_CAPACITY(4) 	//21 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_POUCH_STORAGE     BASE_STORAGE_CAPACITY(3) 	//14 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_BOX_STORAGE       BASE_STORAGE_CAPACITY(2) 	//07 after BASE_STORAGE_CAPACITY calculation