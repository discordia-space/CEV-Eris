/// Only permits mob to buckle
#define BUCKLE_MOB_ONLY 1<<0
/// Forces the buckled to lie if its a mob
#define BUCKLE_FORCE_LIE 1<<1
/// Forces the buckled to stand if its a mob
#define BUCKLE_FORCE_STAND 1<<2
/// Forces the dir of the buckled if its a mob
#define BUCKLE_FORCE_DIR 1<<3
/// Relays any move attempts of the buckled if its a mob to the owner
#define BUCKLE_MOVE_RELAY 1<<4
/// Wheter the component should handle the layer
#define BUCKLE_HANDLE_LAYER 1<<5
/// Wheter the buckled atom gets pixel shifted
#define BUCKLE_PIXEL_SHIFT 1<<6
/// Only permitted to be done if the target is restrained
#define BUCKLE_REQUIRE_RESTRAINTED 1<<7
/// Doesn't permit buckling if the size of the buckler is the smaller than that of the buckled
#define BUCKLE_REQUIRE_BIGGER_BUCKLER 1<<8
/// Wheter we require the target is not buckle to something else.
#define BUCKLE_REQUIRE_NOT_BUCKLED 1<<9
// For breakng whenever we fall z-levels
#define BUCKLE_BREAK_ON_FALL 1<<10
/// For letting the owner handle all unbuckling behavior
#define BUCKLE_CUSTOM_UNBUCKLE 1<<11
/// For letting the owner handle all buckling behavior
#define BUCKLE_CUSTOM_BUCKLE 1<<12
/// For calling  proc on the owner after buckling/unbuckling
#define BUCKLE_SEND_UPDATES 1<<13
