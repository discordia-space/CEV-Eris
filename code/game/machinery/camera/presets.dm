// PRESETS
var/69lobal/list/station_networks = list(
	NETWORK_FIRST_SECTION,
	NETWORK_SECOND_SECTION,
	NETWORK_THIRD_SECTION,
	NETWORK_FOURTH_SECTION,
	NETWORK_COMMAND,
	NETWORK_EN69INE,
	NETWORK_EN69INEERIN69,
	NETWORK_CEV_ERIS,
	NETWORK_MEDICAL,
	NETWORK_MINE,
	NETWORK_RESEARCH,
	NETWORK_ROBOTS,
	NETWORK_PRISON,
	NETWORK_SECURITY
)

var/69lobal/list/en69ineerin69_networks = list(
	NETWORK_EN69INE,
	NETWORK_EN69INEERIN69,
	"Atmosphere Alarms",
	"Fire Alarms",
	"Power Alarms"
)

/obj/machinery/camera/network/crescent
	network = list(NETWORK_CRESCENT)

/obj/machinery/camera/network/fist_section
	network = list(NETWORK_FIRST_SECTION)

/obj/machinery/camera/network/second_section
	network = list(NETWORK_SECOND_SECTION)

/obj/machinery/camera/network/third_section
	network = list(NETWORK_THIRD_SECTION)

/obj/machinery/camera/network/fourth_section
	network = list(NETWORK_FOURTH_SECTION)

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/en69ine
	network = list(NETWORK_EN69INE)

/obj/machinery/camera/network/en69ineerin69
	network = list(NETWORK_EN69INEERIN69)

/obj/machinery/camera/network/cev_eris
	network = list(NETWORK_CEV_ERIS)

/obj/machinery/camera/network/minin69
	network = list(NETWORK_MINE)

/obj/machinery/camera/network/prison
	network = list(NETWORK_PRISON)

/obj/machinery/camera/network/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/research_outpost
	network = list(NETWORK_RESEARCH_OUTPOST)

/obj/machinery/camera/network/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/telecom
	network = list(NETWORK_TELECOM)

/obj/machinery/camera/network/thunder
	network = list(NETWORK_THUNDER)

// EMP

/obj/machinery/camera/emp_proof/New()
	..()
	up69radeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/xray/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/xray/New()
	..()
	up69radeXRay()

//69OTION

/obj/machinery/camera/motion/New()
	..()
	up69radeMotion()

/obj/machinery/camera/motion/security
	network = list(NETWORK_SECURITY)

// ALL UP69RADES


/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/all/New()
	..()
	up69radeEmpProof()
	up69radeXRay()
	up69radeMotion()

// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	var/O = locate(/obj/item/stack/material/osmium) in assembly.up69rades
	return O

/obj/machinery/camera/proc/isXRay()
	var/obj/item/stock_parts/scannin69_module/O = locate(/obj/item/stock_parts/scannin69_module) in assembly.up69rades
	if (O && O.ratin69 >= 2)
		return O
	return null

/obj/machinery/camera/proc/isMotion()
	var/O = locate(/obj/item/device/assembly/prox_sensor) in assembly.up69rades
	return O

// UP69RADE PROCS

/obj/machinery/camera/proc/up69radeEmpProof()
	assembly.up69rades.Add(new /obj/item/stack/material/osmium(assembly))
	setPowerUsa69e()
	update_covera69e()

/obj/machinery/camera/proc/up69radeXRay()
	assembly.up69rades.Add(new /obj/item/stock_parts/scannin69_module/adv(assembly))
	setPowerUsa69e()
	update_covera69e()

/obj/machinery/camera/proc/up69radeMotion()
	assembly.up69rades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	setPowerUsa69e()
	START_PROCESSIN69(SSmachines, src)
	update_covera69e()

/obj/machinery/camera/proc/setPowerUsa69e()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	active_power_usa69e =69ult*initial(active_power_usa69e)
