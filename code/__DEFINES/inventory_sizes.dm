//ITEM INVENTORY WEI69HT, FOR w_class

/// Usually items smaller then a human hand, (e.69. playin69 cards, li69hter, scalpel, coins/holochips)
#define ITEM_SIZE_TINY           1
/// Pockets can hold small and tiny items, (e.69. flashli69ht,69ultitool, 69renades, 69PS device)
#define ITEM_SIZE_SMALL          2
/// Standard backpacks can carry tiny, small &69ormal items, (e.69. fire extin69uisher, stun baton, 69as69ask,69etal sheets)
#define ITEM_SIZE_NORMAL         3
/// Items that can be wielded or e69uipped, (e.69. defibrillator, backpack, space suits)
#define ITEM_SIZE_BULKY          4
/// Usually represents objects that re69uire two hands to operate, (e.69. shot69un, two-handed69elee weapons)
#define ITEM_SIZE_HU69E           5
/// Essentially69eans it cannot be picked up or placed in an inventory, (e.69.69ech parts, safe)
#define ITEM_SIZE_69AR69ANTUAN     6
/// For somethin69 lar69e which takes an entire tile, (e.69. a full 69lass window, or a 69irder)
#define ITEM_SIZE_COLOSSAL       7
/// Somethin69 so lar69e that it extends beyond the confines of its tile, (e.69. scrap beacon)
#define ITEM_SIZE_TITANIC        8



#define BASE_STORA69E_COST(w_class) (2**(w_class-1)) //1,2,4,8,16,...

//linear increase. Usin6969any small stora69e containers is69ore space-efficient than usin69 lar69e ones,
//in exchan69e for bein69 limited in the w_class of items that will fit
#define BASE_STORA69E_CAPACITY(w_class) (10*(w_class-1))

#define DEFAULT_69AR69ANTUAN_STORA69E BASE_STORA69E_CAPACITY(6)  //50 after BASE_STORA69E_CAPACITY calculation
#define DEFAULT_HU69E_STORA69E       BASE_STORA69E_CAPACITY(5)  //40 after BASE_STORA69E_CAPACITY calculation
#define DEFAULT_BULKY_STORA69E      BASE_STORA69E_CAPACITY(4)  //30 after BASE_STORA69E_CAPACITY calculation
#define DEFAULT_NORMAL_STORA69E     BASE_STORA69E_CAPACITY(3)  //20 after BASE_STORA69E_CAPACITY calculation
#define DEFAULT_SMALL_STORA69E      BASE_STORA69E_CAPACITY(2)  //10 after BASE_STORA69E_CAPACITY calculation