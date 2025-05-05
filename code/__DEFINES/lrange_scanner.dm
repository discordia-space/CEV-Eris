#define ENERGY_UPKEEP_SCANNER (350 KILOWATTS)	// Base upkeep
#define ENERGY_PER_SCAN (500 MEGAWATTS)	// Energy cost to launch a scan (yes it's in Watt and not in Joules...)

#define SCANNER_OFF 0				// The shield is offline
#define SCANNER_DISCHARGING 1		// The shield is shutting down and discharging.
#define SCANNER_RUNNING 2			// The shield is running
