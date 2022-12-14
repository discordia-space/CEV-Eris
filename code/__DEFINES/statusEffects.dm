GLOBAL_LIST_EMPTY_TYPED(globalEffects, /datum/statusEffect)

#define SE_WEAKENED "weakened"
#define SE_STUNNED "stunned"
#define SE_PARALYZED "paralyzed"
// This makes it so trying to add a new status effect always creates a new one , instead of increasing the length of the current one
#define SE_FLAG_UNIQUE "unique"
