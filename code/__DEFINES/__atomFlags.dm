/// This ATOM gets its proper icon after update icon / new has been called . This makes path2icon instantiate it and grab it from there
#define AF_ICONGRABNEEDSINSTANTATION 1<<1
/// This atom's layer shouldn't adjust itself
#define AF_LAYER_UPDATE_HANDLED 1<<2
/// This atom's plane shouldn't adjust itself
#define AF_PLANE_UPDATE_HANDLED 1<<3
