//ITEM INVENTORY WEIGHT, FOR volumeClass
// Repurposed for volume.

/// Usually items smaller then a human hand, (e.g. playing cards, lighter, scalpel, coins/holochips)
#define ITEM_SIZE_TINY           1
/// Pockets can hold small and tiny items, (e.g. flashlight, multitool, grenades, GPS device)
#define ITEM_SIZE_SMALL          2
/// Standard backpacks can carry tiny, small & normal items, (e.g. fire extinguisher, stun baton, gas mask, metal sheets)
#define ITEM_SIZE_NORMAL         3
/// Items that can be wielded or equipped, (e.g. defibrillator, backpack, space suits)
#define ITEM_SIZE_BULKY          4
/// Usually represents objects that require two hands to operate, (e.g. shotgun, two-handed melee weapons)
#define ITEM_SIZE_HUGE           5
/// Essentially means it cannot be picked up or placed in an inventory, (e.g. mech parts, safe)
#define ITEM_SIZE_GARGANTUAN     6
/// For something large which takes an entire tile, (e.g. a full glass window, or a girder)
#define ITEM_SIZE_COLOSSAL       7
/// Something so large that it extends beyond the confines of its tile, (e.g. scrap beacon)
#define ITEM_SIZE_TITANIC        8



#define BASE_STORAGE_COST(volumeClass) (2**(volumeClass-1)) //1,2,4,8,16,...

//linear increase. Using many small storage containers is more space-efficient than using large ones,
//in exchange for being limited in the volumeClass of items that will fit
#define BASE_STORAGE_CAPACITY(volumeClass) (10*(volumeClass-1))

#define DEFAULT_GARGANTUAN_STORAGE BASE_STORAGE_CAPACITY(6)  //50 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_HUGE_STORAGE       BASE_STORAGE_CAPACITY(5)  //40 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_BULKY_STORAGE      BASE_STORAGE_CAPACITY(4)  //30 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_NORMAL_STORAGE     BASE_STORAGE_CAPACITY(3)  //20 after BASE_STORAGE_CAPACITY calculation
#define DEFAULT_SMALL_STORAGE      BASE_STORAGE_CAPACITY(2)  //10 after BASE_STORAGE_CAPACITY calculation
