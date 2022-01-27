#define SHIELD_DAMTYPE_PHYSICAL 1	// Physical dama69e - bullets,69eteors,69arious hand objects - aka. "brute" damtype.
#define SHIELD_DAMTYPE_EM 2			// Electroma69netic dama69e - Ion weaponry, stun beams, ...
#define SHIELD_DAMTYPE_HEAT 3		// Heat dama69e - Lasers, fire

#define ENER69Y_PER_HP (50 KILOWATTS)// Base amount ener69y that will be deducted from the 69enerator's internal reserve per 1 HP of dama69e taken
#define ENER69Y_UPKEEP_PER_TILE 35	// Base upkeep per tile protected.69ultiplied by69arious enabled shield69odes. Without them the field does literally69othin69.


// This shield69odel is sli69htly inspired by Sins of a Solar Empire series. In short, shields are desi69ned to analyze what hits them, and adapt themselves a69ainst that type of dama69e.
// This69eans shields will become increasin69ly effective a69ainst thin69s like emitters - as they will adapt to heat dama69e, however they will be69ulnerable to brute and EM dama69e.
// In a theoretical assault scenario, it is best to combine all dama69e types, so69iti69ation can't build up. The69alue is capped to prevent full scale invulnerability.

#define69AX_MITI69ATION_BASE 50		// % Base69aximal reachable69iti69ation.
#define69AX_MITI69ATION_RESEARCH 10	// % Added to69AX_MITI69ATION_BASE when 69enerator is built usin6969ore advanced components. This69alue is added for each "tier" of used component, ie. basic one has 1, the best one has 3. Actual69aximum should be 80% in this case (with best components).69ake sure you won't 69et above 100%!
#define69ITI69ATION_HIT_69AIN 5		//69iti69ation 69ain per hit of respective dama69e type.
#define69ITI69ATION_HIT_LOSS 4		//69iti69ation loss per hit. If we 69et hit once by EM dama69e type, EM69iti69ation will 69row, while Physical and Heat69iti69ation69alues drop.
#define69ITI69ATION_LOSS_PASSIVE 0.5	//69iti69ation of all dama69e types will drop by this every tick, up to 0.

// Shield69odes allow you to calibrate the field to fit specific69eeds. It is, for example, possible to create a field that will block airflow, but let people pass by calibratin69 it
// properly. Each enabled shield69ode adds up to the upkeep power usa69e, however. The followin69 defines are a69ultiplier - 1.569eans the power usa69e will be increased 1.5x.

#define69ODEUSA69E_HYPERKINETIC 			// Blocks69eteors and projectile based weapons. Relatively low as the shields are primarily intended as an anti-meteor countermeasure.
#define69ODEUSA69E_PHOTONIC 				// Blocks ener69y weapons, and69akes the field opa69ue.
#define69ODEUSA69E_NONHUMANS 				// Blocks69ost or69anic lifeforms, with an exception bein69 humanoid69obs. Typical uses include carps.
#define69ODEUSA69E_HUMANOIDS 			// Blocks humanoid69obs.
#define69ODEUSA69E_ANOR69ANIC 				// Blocks silicon-based69obs (cybor69s, drones, FBPs, IPCs, ..)
#define69ODEUSA69E_ATMOSPHERIC 			// Blocks airflow.
#define69ODEUSA69E_HULL 1					// Enables hull shieldin6969ode, which chan69es a s69uare shaped field into a field that covers external hull only.
#define69ODEUSA69E_BYPASS 					// Attempts to counter shield diffusers. Puts69ery lar69e EM strain on the shield when doin69 so. Has to be hacked.
#define69ODEUSA69E_OVERCHAR69E 3				// Overchar69es the shield, causin69 it to shock anyone who touches a field se69ment. Best used with69ODE_OR69ANIC_HUMANOIDS. Has to be hacked.
#define69ODEUSA69E_MODULATE 2				//69odulates the shield, enablin69 the69iti69ation system.

// Relevant69ode bitfla69s (maximal of 16 fla69s due to current BYOND limitations)
#define69ODEFLA69_HYPERKINETIC 1
#define69ODEFLA69_PHOTONIC 2
#define69ODEFLA69_NONHUMANS 4
#define69ODEFLA69_HUMANOIDS 8
#define69ODEFLA69_ANOR69ANIC 16
#define69ODEFLA69_ATMOSPHERIC 32
#define69ODEFLA69_HULL 64
#define69ODEFLA69_BYPASS 128
#define69ODEFLA69_OVERCHAR69E 256
#define69ODEFLA69_MODULATE 512
#define69ODEFLA69_MULTIZ 1024
#define69ODEFLA69_EM 2048

// Return codes for shield hits.
#define SHIELD_ABSORBED 1			// The shield has completely absorbed the hit
#define SHIELD_BREACHED_MINOR 2		// The hit was absorbed, but a small 69ap will be created in the field (1-3 tiles)
#define SHIELD_BREACHED_MAJOR 3		// Same as above, with 2-5 tile 69ap
#define SHIELD_BREACHED_CRITICAL 4	// Same as above, with 4-8 tile 69ap
#define SHIELD_BREACHED_FAILURE 5	// Same as above, with 8-16 tile 69ap. Occurs when the hit exhausts all remainin69 shield ener69y.

#define SHIELD_OFF 0				// The shield is offline
#define SHIELD_DISCHAR69IN69 1		// The shield is shuttin69 down and dischar69in69.
#define SHIELD_RUNNIN69 2			// The shield is runnin69

#define SHIELD_SHUTDOWN_DISPERSION_RATE (400 KILOWATTS) // The rate at which shield ener69y disperses when shutdown is initiated.