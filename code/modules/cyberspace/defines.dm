#define CYBERSPACE_MAIN_COLOR_raw		0, 221, 255
#define CYBERSPACE_SHADOW_COLOR_raw		0, 21, 55
#define CYBERSPACE_BLUESPACE_raw		0, 150, 255
#define CYBERSPACE_SECURITY_raw			255, 50, 100

#define CYBERSPACE_TECHNOMANSERS_raw	240, 143, 24
#define CYBERSPACE_NT_raw				222, 182, 61
#define CYBERSPACE_MOEBIUS_raw			146, 79, 205
#define CYBERSPACE_IRONHAMMER_raw		208, 231, 234

#define CYBERSPACE_MAIN_COLOR			rgb(CYBERSPACE_MAIN_COLOR_raw)
#define CYBERSPACE_SHADOW_COLOR			rgb(CYBERSPACE_SHADOW_COLOR_raw)
#define CYBERSPACE_BLUESPACE			rgb(CYBERSPACE_BLUESPACE_raw)
#define CYBERSPACE_SECURITY				rgb(CYBERSPACE_SECURITY_raw)

#define CYBERSPACE_TECHNOMANSERS		rgb(CYBERSPACE_TECHNOMANSERS_raw)
#define CYBERSPACE_NT					rgb(CYBERSPACE_NT_raw)
#define CYBERSPACE_MOEBIUS				rgb(CYBERSPACE_MOEBIUS_raw)
#define CYBERSPACE_IRONHAMMER			rgb(CYBERSPACE_IRONHAMMER_raw)

#define SUBROUTINE_FAILED_TO_BREAK	"Failed to Break"
#define SUBROUTINE_BUMPED			"Bumped"
#define SUBROUTINE_SPOTTED			"Someone in range!!!"
#define SUBROUTINE_ATTACK			"Die!"

//A must be /atom variable
#define IsCyberspaced(A) (istype(A) && istype(A.CyberAvatar) && A.CyberAvatar.enabled)
#define CYBERAVATAR_INITIALIZATION(typeOfAtom, DefaultColor) ##typeOfAtom/CyberAvatar = DefaultColor
#define CYBERAVATAR_CUSTOM_TYPE(typeOfAtom, avatarPrefab) ##typeOfAtom/CyberAvatar_prefab = ##avatarPrefab

#define STATE_ICON_COLOR(state, _color) new/image{icon_state=state;color=_color}()
#define ICE_STANCE_OVERWATCH "Overwatch"
#define ICE_STANCE_ATTACK "Attack!"
#define ICE_STANCE_ATTACKING "Diediedie"
#define ICE_STANCE_DEAD "Dead"

