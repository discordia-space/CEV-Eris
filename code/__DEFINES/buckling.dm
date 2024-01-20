/// Only permits mob to buckle  1
#define BUCKLE_MOB_ONLY 1<<0
/// Forces the buckled to lie if its a mob 2
#define BUCKLE_FORCE_LIE 1<<1
/// Forces the buckled to stand if its a mob 4
#define BUCKLE_FORCE_STAND 1<<2
/// Forces the dir of the buckled if its a mob 8
#define BUCKLE_FORCE_DIR 1<<3
/// Relays any move attempts of the buckled if its a mob to the owner 16
#define BUCKLE_MOVE_RELAY 1<<4
/// Wheter the component should handle the layer 32
#define BUCKLE_HANDLE_LAYER 1<<5
/// Wheter the buckled atom gets pixel shifted 64
#define BUCKLE_PIXEL_SHIFT 1<<6
/// Only permitted to be done if the target is restrained 128
#define BUCKLE_REQUIRE_RESTRAINTED 1<<7
/// Doesn't permit buckling if the size of the buckler is the smaller than that of the buckled 256
#define BUCKLE_REQUIRE_BIGGER_BUCKLER 1<<8
/// Wheter we require the target is not buckle to something else. 512
#define BUCKLE_REQUIRE_NOT_BUCKLED 1<<9
// For breakng whenever we fall z-levels 1024
#define BUCKLE_BREAK_ON_FALL 1<<10
/// For letting the owner handle all unbuckling behavior 2024
#define BUCKLE_CUSTOM_UNBUCKLE 1<<11
/// For letting the owner handle all buckling behavior 4048
#define BUCKLE_CUSTOM_BUCKLE 1<<12
/// For calling  proc on the owner after buckling/unbuckling 8096
#define BUCKLE_SEND_UPDATES 1<<13
/// For letting the buckled know this buckle moves. Prevents resist attempts on move relay 16192
#define BUCKLE_MOVING 1<<14
