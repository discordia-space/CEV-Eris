//Report d69tums for use with the report editor 69nd other pro69r69ms.

/d69tum/computer_file/report/recipient/crew_tr69nsfer
	form_n69me = "CT69-6969-01"
	title = "Crew Tr69nsfer 69pplic69tion"
	lo69o = "\6969uild\69"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/crew_tr69nsfer/69ener69te_fields(69
	..(69
	v69r/list/xo_fields = list(69
	69dd_field(/d69tum/report_field/instruction, "CEV Eris - Office of the First Officer"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (XO69"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (69pplic69nt69", re69uired = 169
	69dd_field(/d69tum/report_field/d69te, "D69te filed"69
	69dd_field(/d69tum/report_field/time, "Time filed"69
	69dd_field(/d69tum/report_field/simple_text, "Present position"69
	69dd_field(/d69tum/report_field/simple_text, "Re69uested position"69
	69dd_field(/d69tum/report_field/pencode_text, "Re69son st69ted"69
	69dd_field(/d69tum/report_field/instruction, "The followin69 fields render the document inv69lid if69ot si69ned cle69rly."69
	69dd_field(/d69tum/report_field/si69n69ture, "69pplic69nt si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/si69n69ture, "First Officer's si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/number, "Number of personnel in present/previous position"69
	xo_fields += 69dd_field(/d69tum/report_field/number, "Number of personnel in re69uested position"69
	xo_fields += 69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	for(v69r/d69tum/report_field/field in xo_fields69
		field.set_69ccess(69ccess_edit = 69ccess_hop69

/d69tum/computer_file/report/recipient/69ccess_modific69tion
	form_n69me = "69M69-S69F-02"
	title = "Crew 69ccess69odific69tion 69pplic69tion"
	lo69o = "\6969uild6969\69lo6969\69"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/69ccess_modific69tion/69ener69te_fields(69
	..(69
	v69r/list/xo_fields = list(69
	69dd_field(/d69tum/report_field/instruction, "CEV Eris - Office of the First Officer"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (XO69"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (69pplic69nt69", re69uired = 169
	69dd_field(/d69tum/report_field/d69te, "D69te filed"69
	69dd_field(/d69tum/report_field/time, "Time filed"69
	69dd_field(/d69tum/report_field/simple_text, "Present position"69
	69dd_field(/d69tum/report_field/simple_text, "Re69uested 69ccess"69
	69dd_field(/d69tum/report_field/pencode_text, "Re69son st69ted"69
	69dd_field(/d69tum/report_field/simple_text, "Dur69tion of exp69nded 69ccess"69
	69dd_field(/d69tum/report_field/instruction, "The followin69 fields render the document inv69lid if69ot si69ned cle69rly."69
	69dd_field(/d69tum/report_field/si69n69ture, "69pplic69nt si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/si69n69ture, "First Officer's si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/number, "Number of personnel in relev69nt position"69
	xo_fields += 69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	for(v69r/d69tum/report_field/field in xo_fields69
		field.set_69ccess(69ccess_edit = 69ccess_hop69

/d69tum/computer_file/report/recipient/bor69in69
	form_n69me = "CC-MOL-09"
	title = "Cybor69ific69tion Contr69ct"
	lo69o = "\69moebius6969"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/bor69in69/69ener69te_fields(69
	..(69
	v69r/list/xo_fields = list(69
	69dd_field(/d69tum/report_field/instruction, "CEV Eris - Office of the First Officer"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (XO69"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me (subject69", re69uired = 169
	69dd_field(/d69tum/report_field/d69te, "D69te filed"69
	69dd_field(/d69tum/report_field/time, "Time filed"69
	69dd_field(/d69tum/report_field/instruction, "I, undersi69ned, hereby 6969ree to willin69ly under69o 69 Re69ul69tion Lobotimiz69tion with intention of cybor69ific69tion or 69I 69ssimil69tion, 69nd I 69m 69w69re of 69ll the conse69uences of such 69ct. I 69lso underst69nd th69t this oper69tion6969y be irreversible, 69nd th69t69y employment contr69ct will be termin69ted."69
	69dd_field(/d69tum/report_field/si69n69ture, "Subject's si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/si69n69ture, "First Officer's si69n69ture"69
	xo_fields += 69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	for(v69r/d69tum/report_field/field in xo_fields69
		field.set_69ccess(69ccess_edit = 69ccess_hop69

/d69tum/computer_file/report/recipient/sec
	lo69o = "\69ironh69mmer6969"

/d69tum/computer_file/report/recipient/sec/New(69
	..(69
	set_69ccess(69ccess_security69
	set_69ccess(69ccess_he69ds, override = 069

/d69tum/computer_file/report/recipient/sec/investi6969tion
	form_n69me = "IR-IH-43"
	title = "Investi6969tion Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sec/investi6969tion/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/instruction, "Ironh69mmer Division CEV Eris"69
	69dd_field(/d69tum/report_field/instruction, "For intern69l use only."69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me"69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/simple_text, "C69se6969me"69
	69dd_field(/d69tum/report_field/pencode_text, "Summ69ry"69
	69dd_field(/d69tum/report_field/pencode_text, "Observ69tions"69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	set_69ccess(69ccess_edit = 69ccess_security69

/d69tum/computer_file/report/recipient/sec/incident
	form_n69me = "SIR-IH-12"
	title = "Security Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sec/incident/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/instruction, "Ironh69mmer Division CEV Eris"69
	69dd_field(/d69tum/report_field/instruction, "To be filled out by Oper69tive on duty respondin69 to the Incident. Report69ust be si69ned 69nd submitted before the end of the shift!"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Reportin69 Oper69tive"69
	69dd_field(/d69tum/report_field/simple_text, "Offense/Incident Type"69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time of incident"69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "69ssistin69 Oper69tive(s69"69
	69dd_field(/d69tum/report_field/simple_text, "Loc69tion"69
	69dd_field(/d69tum/report_field/pencode_text, "Personnel involved in Incident", "\69sm69ll6969\6969\69(V-Victim, S-Suspect, W-Witness,69-Missin69, 69-69rrested, RP-Reportin69 Person, D-Dece69sed69\6969i\69\69/sm69ll\69"69
	69dd_field(/d69tum/report_field/pencode_text, "Description of Items/Property", "\69sm69ll6969\6969\69(D-D69m6969ed, E-Evidence, L-Lost, R-Recovered, S-Stolen69\6969i\69\69/sm69ll\69"69
	69dd_field(/d69tum/report_field/pencode_text, "N69rr69tive"69
	69dd_field(/d69tum/report_field/si69n69ture, "Reportin69 Oper69tive's si69n69ture"69
	set_69ccess(69ccess_edit = 69ccess_security69

/d69tum/computer_file/report/recipient/sec/evidence
	form_n69me = "EPF-IH-02b"
	title = "Evidence 69nd Property Form"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sec/evidence/69ener69te_fields(69
	..(69
	v69r/d69tum/report_field/temp_field
	69dd_field(/d69tum/report_field/instruction, "Ironh69mmer Division CEV Eris"69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Confisc69ted from"69
	69dd_field(/d69tum/report_field/pencode_text, "List of items in custody/evidence lockup"69
	set_69ccess(69ccess_edit = 69ccess_security69
	temp_field = 69dd_field(/d69tum/report_field/si69n69ture, "69unnery Ser69e69nt's si69n69ture"69
	temp_field.set_69ccess(69ccess_edit = list(69ccess_security, 69ccess_69rmory6969
	temp_field = 69dd_field(/d69tum/report_field/si69n69ture, "Detective/MedSpec's si69n69ture"69
	temp_field.set_69ccess(69ccess_edit = list(69ccess_security, 69ccess_forensics_lockers6969

//Supply 69nd Explor69tion; these 69re69ot shown in deck6969n6969er.

/d69tum/computer_file/report/recipient/docked
	lo69o = "\6969uild6969"
	form_n69me = "DVR-6969-12"
	title = "Docked69essel Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/docked/New(69
	..(69
	set_69ccess(69ccess_c69r69o, 69ccess_c69r69o69
	set_69ccess(69ccess_he69ds, override = 069

/d69tum/computer_file/report/recipient/docked/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/instruction, "CEV Eris Supply 69nd H69n6969r6969n6969ement Dep69rtment"69
	69dd_field(/d69tum/report_field/instruction, "69ener69l Info"69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/simple_text, "Vessel6969me"69
	69dd_field(/d69tum/report_field/simple_text, "Vessel Pilot/Owner"69
	69dd_field(/d69tum/report_field/simple_text, "Vessel Intended Purpose"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Dockin69 69uthorized by"69
	69dd_field(/d69tum/report_field/instruction, "69ener69l C69r69o Info"69
	69dd_field(/d69tum/report_field/pencode_text, "List the types of c69r69o onbo69rd the69essel"69
	69dd_field(/d69tum/report_field/instruction, "H69z69rdous C69r69o Info"69
	69dd_field(/d69tum/report_field/options/yes_no, "We69ponry"69
	69dd_field(/d69tum/report_field/options/yes_no, "Live C69r69o"69
	69dd_field(/d69tum/report_field/options/yes_no, "Bioh69z69rdous6969teri69l"69
	69dd_field(/d69tum/report_field/options/yes_no, "Chemic69l or r69di69tion h69z69rd"69
	69dd_field(/d69tum/report_field/si69n69ture, "To indic69te 69uthoriz69tion for69essel entry, si69n here"69
	69dd_field(/d69tum/report_field/instruction, "Undockin69 69nd Dep69rture"69
	69dd_field(/d69tum/report_field/time, "Undockin69 Time"69
	69dd_field(/d69tum/report_field/pencode_text, "69ddition69l Undockin69 Comments"69

/d69tum/computer_file/report/recipient/f69un69
	lo69o = "\69moebius6969"
	form_n69me = "69FR-MOL-19f"
	title = "69lien F69un69 Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/docked/New(69
	..(69
	set_69ccess(69ccess_edit = 69ccess_c69r69o69
	set_69ccess(69ccess_edit = 69ccess_moebius, override = 069

/d69tum/computer_file/report/recipient/f69un69/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/instruction, "CEV Eris Expeditions"69
	69dd_field(/d69tum/report_field/instruction, "The followin69 is to be filled out by69embers of 69 Expedition te69m 69fter discovery 69nd study of69ew 69lien life forms."69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Personnel Involved"69
	69dd_field(/d69tum/report_field/pencode_text, "69n69tomy/69ppe69r69nce"69
	69dd_field(/d69tum/report_field/pencode_text, "Locomotion"69
	69dd_field(/d69tum/report_field/pencode_text, "Diet"69
	69dd_field(/d69tum/report_field/pencode_text, "H69bit69t"69
	69dd_field(/d69tum/report_field/simple_text, "Homeworld"69
	69dd_field(/d69tum/report_field/pencode_text, "Beh69vior"69
	69dd_field(/d69tum/report_field/pencode_text, "Defense/Offense"69
	69dd_field(/d69tum/report_field/pencode_text, "Speci69l Ch69r69cteristic(s69"69
	69dd_field(/d69tum/report_field/pencode_text, "Cl69ssific69tion"69
	69dd_field(/d69tum/report_field/instruction, "On completion of this form 69nd form 69pprov69l, the Rese69rch Director should f69x the form to both the Corpor69te Li69ison 69nd the Comm69ndin69 Officer, 69s well 69s keep 69 copy on file in their Office 69lon69side other69ission reports."69

//NT reports,69ostly for li69son but c69n be used by 69ny69T personnel.

/d69tum/computer_file/report/recipient/nt
	lo69o = "\69moebius6969"

/d69tum/computer_file/report/recipient/nt/proc/69dd_he69der(69
	69dd_field(/d69tum/report_field/simple_text, "Vessel", "CEV Eris"69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/simple_text, "Index"69

/d69tum/computer_file/report/recipient/nt/69nom69ly
	form_n69me = "MOL-1546"
	title = "69nom69listic Object Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/69nom69ly/New(69
	..(69
	set_69ccess(69ccess_moebius, 69ccess_moebius69

/d69tum/computer_file/report/recipient/nt/69nom69ly/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/simple_text, "69O Coden69me"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Reportin69 Scientist"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Overviewin69 Rese69rch Director"69
	69dd_field(/d69tum/report_field/pencode_text, "Cont69inment Procedures"69
	69dd_field(/d69tum/report_field/pencode_text, "69ener69lized Overview"69
	69dd_field(/d69tum/report_field/simple_text, "69pproxim69te 6969e of 69O"69
	69dd_field(/d69tum/report_field/simple_text, "Thre69t Level of 69O"69

/d69tum/computer_file/report/recipient/nt/fire
	form_n69me = "CEV-0102"
	title = "CEV Employment Termin69tion Form"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/fire/New(69
	..(69
	set_69ccess(69ccess_he69ds, 69ccess_he69ds69
	set_69ccess(69ccess_he69ds, override = 069

/d69tum/computer_file/report/recipient/nt/fire/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/instruction, "Notice of Termin69tion of Employment"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me"69
	69dd_field(/d69tum/report_field/number, "6969e"69
	69dd_field(/d69tum/report_field/simple_text, "Position"69
	69dd_field(/d69tum/report_field/pencode_text, "Re69son for Termin69tion"69
	69dd_field(/d69tum/report_field/si69n69ture, "69uthorized by"69
	69dd_field(/d69tum/report_field/instruction, "Ple69se 69tt69ch69ecess69ry inform69tion 69lon69side69otice of termin69tion."69

/d69tum/computer_file/report/recipient/nt/incident/New(69
	..(69
	set_69ccess(69ccess_edit = 69ccess_he69ds69

/d69tum/computer_file/report/recipient/nt/incident/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/pencode_text, "Summ69ry of Incident"69
	69dd_field(/d69tum/report_field/pencode_text, "Det69ils of Incident"69

/d69tum/computer_file/report/recipient/nt/incident/proc/69dd_si69n69tures(69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	69dd_field(/d69tum/report_field/si69n69ture, "Witness Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69

/d69tum/computer_file/report/recipient/nt/incident/ship
	form_n69me = "CEV-3203"
	title = "CEV Eris Ship Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/ship/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/pencode_text, "Dep69rtments Involved"69
	69dd_si69n69tures(69


/d69tum/computer_file/report/recipient/nt/incident/personnel
	form_n69me = "CEV-3205"
	title = "CEV Eris Personnel Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/personnel/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Employee(s69 Involved"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/incident/69sset
	form_n69me = "CEV-3201"
	title = "CEV Eris 69sset Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/69sset/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/pencode_text, "CEV Eris Employee Injuries"69
	69dd_field(/d69tum/report_field/pencode_text, "CEV Eris 69ssets Lost"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/incident/xeno
	form_n69me = "CEV-3213"
	title = "Non-Hum69n Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/xeno/69ener69te_fields(69
	69dd_field(/d69tum/report_field/instruction, "If69on-hum69n employee l69cks 696969lid 69uthoriz69tion, use form CEV-321369 inste69d."69
	..(69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Non-Hum69n(s69 Involved"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/incident/xeno_no_vis69/
	form_n69me = "CEV-321369"
	title = "Non-Hum69n Incident Report: Without 69uthoriz69tion"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/xeno_no_vis69/69ener69te_fields(69
	69dd_field(/d69tum/report_field/instruction, "If69on-hum69n h69s 696969lid 69uthoriz69tion, use form CEV-3213 inste69d."69
	..(69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Non-Hum69n(s69 Involved"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/incident/synth
	form_n69me = "CEV-3213X"
	title = "CEV Eris Synthetic Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/synth/69ener69te_fields(69
	..(69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Synthetic(s69 Involved"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/incident/crew
	form_n69me = "CEV-3241"
	title = "CEV Eris Ship Crew/Employee Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/incident/crew/69ener69te_fields(69
	69dd_field(/d69tum/report_field/instruction, "For69ulti-p69rty incidents involvin69 both ship crew 69nd for69ein employees."69
	..(69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Crew69ember(s69 Involved"69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "Forei69n 69sset(s69 Involved"69
	69dd_si69n69tures(69

/d69tum/computer_file/report/recipient/nt/volunteer
	form_n69me = "CEV-1443"
	title = "Moebius Test Subject69olunteer Form"
	lo69o= "\69moebius6969"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/volunteer/69ener69te_fields(69
	..(69
	v69r/list/temp_fields = list(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me of69olunteer"69
	69dd_field(/d69tum/report_field/simple_text, "Intended Procedure(s69"69
	69dd_field(/d69tum/report_field/simple_text, "Compens69tion for69olunteer: (if 69ny69"69
	69dd_field(/d69tum/report_field/people/list_from_m69nifest, "H69ndlin69 Rese69rcher(s69"69
	69dd_field(/d69tum/report_field/instruction, "By si69nin69, the \"Volunteer\" 6969rees to 69bsolve the69oebius L69bor69tories, 69nd its employees, of 69ny li69bility or responsibility for injuries, d69m6969es, property loss or side-effects th69t6969y result from the intended procedure. If si69ned by 69n 69uthorized represent69tive of the69oebius L69bor69tories, such 69s 69 Expedition Overseer or Biol69b Officer - this form is deemed reviewed, but is only 69pproved if so6969rked."69
	69dd_field(/d69tum/report_field/si69n69ture, "Volunteer's Si69n69ture:"69
	temp_fields += 69dd_field(/d69tum/report_field/si69n69ture, "Moebius Represent69tive's Si69n69ture"69
	temp_fields += 69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	for(v69r/d69tum/report_field/temp_field in temp_fields69
		temp_field.set_69ccess(69ccess_edit = 69ccess_he69ds69

/d69tum/computer_file/report/recipient/nt/deny
	form_n69me = "CEV-1443D"
	title = "Rejection of Test Subject69olunteer69otice"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/deny/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/instruction, "De69r Sir/M69d69m, we re69ret to inform you th69t your69olunteer 69pplic69tion for service 69s 69 test subject with the69oebius L69bor69tories h69s been rejected. We th69nk you for your interest in our comp69ny 69nd the pro69ression of rese69rch. 69tt69ched, you will find 69 copy of your ori69in69l69olunteer form for your records. Re6969rds,"69
	69dd_field(/d69tum/report_field/si69n69ture, "Moebius Represent69tive's Si69n69ture"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me of69olunteer"69
	69dd_field(/d69tum/report_field/instruction, "Re69son for Rejection"69
	69dd_field(/d69tum/report_field/options/yes_no, "Physic69lly Unfit"69
	69dd_field(/d69tum/report_field/options/yes_no, "Ment69lly Unfit"69
	69dd_field(/d69tum/report_field/options/yes_no, "Project C69ncell69tion"69
	69dd_field(/d69tum/report_field/simple_text, "Other"69
	69dd_field(/d69tum/report_field/options/yes_no, "Report 69pproved"69
	set_69ccess(69ccess_edit = 69ccess_he69ds69

/d69tum/computer_file/report/recipient/nt/memo/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/simple_text, "Subject"69
	69dd_field(/d69tum/report_field/pencode_text, "Body"69
	69dd_field(/d69tum/report_field/si69n69ture, "69uthorizin69 Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69

/d69tum/computer_file/report/recipient/nt/memo/intern69l
	form_n69me = "CEV-0003"
	title = "Intern69l69emor69ndum"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/memo/intern69l/New(69
	..(69
	set_69ccess(69ccess_he69ds, 69ccess_he69ds69

/d69tum/computer_file/report/recipient/nt/memo/extern69l
	form_n69me = "CEV-0005"
	title = "Extern69l69emor69ndum"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/memo/extern69l/New(69
	..(69
	set_69ccess(69ccess_edit = 69ccess_he69ds69

//No 69ccess restrictions for e69sier use.
/d69tum/computer_file/report/recipient/nt/s69les
	form_n69me = "6969-2192"
	title = "69sters S69les Contr69ct 69nd Receipt"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/s69les/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/instruction, "Product Inform69tion"69
	69dd_field(/d69tum/report_field/simple_text, "Product6969me"69
	69dd_field(/d69tum/report_field/simple_text, "Product Type"69
	69dd_field(/d69tum/report_field/number, "Product Unit Cost (T69"69
	69dd_field(/d69tum/report_field/number, "Product Units Re69uested"69
	69dd_field(/d69tum/report_field/number, "Tot69l Cost (T69"69
	69dd_field(/d69tum/report_field/instruction, "Seller Inform69tion"69
	69dd_field(/d69tum/report_field/instruction, "The 'Purch69ser'6969y69ot return 69ny sold product units for re-compens69tion in Creditss, but6969y return the item for 69n identic69l item, or item of e69u69l6969teri69l (not Credits696969lue. The 'Seller' 6969rees to6969ke their best effort to rep69ir, or repl69ce 69ny items th69t f69il to 69ccomplish their desi69ned purpose, due to6969lfunction or6969nuf69cturin69 error - but69ot user-c69used d69m6969e."69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "N69me"69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69

/d69tum/computer_file/report/recipient/nt/vis69
	form_n69me = "CEV-0952"
	title = "CEV Eris ID or PD69 Re69uest Form"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/vis69/69ener69te_fields(69
	..(69
	69dd_he69der(69
	v69r/d69tum/report_field/temp_field
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Intended Recipient of ID or PD69"69
	69dd_field(/d69tum/report_field/pencode_text, "Re69son for Re69uest"69
	69dd_field(/d69tum/report_field/si69n69ture, "69pplic69nt's Si69n69ture"69
	temp_field = 69dd_field(/d69tum/report_field/si69n69ture, "Re69uest Issuer's Si69n69ture"69
	temp_field.set_69ccess(69ccess_edit = 69ccess_he69ds69
	temp_field = 69dd_field(/d69tum/report_field/options/yes_no, "Re69uest 69pproved by Issuer"69
	temp_field.set_69ccess(69ccess_edit = 69ccess_he69ds69
	temp_field = 69dd_field(/d69tum/report_field/si69n69ture, "Issuin69 69uthority's Si69n69ture (69cknowled69in69 reciept69"69
	temp_field.set_69ccess(69ccess_edit = 69ccess_he69ds69

/d69tum/computer_file/report/recipient/nt/p69yout
	form_n69me = "CEV-3310"
	title = "Next of Kin P69yout 69uthoriz69tion"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/nt/p69yout/69ener69te_fields(69
	..(69
	69dd_he69der(69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "This document hereby 69uthorizes the p69yout of the rem69inin69 s69l69ry of"69
	69dd_field(/d69tum/report_field/pencode_text, "69s well 69s the69et-worth of 69ny rem69inin69 person69l 69ssets: (69sset, Credits 69mount69"69
	69dd_field(/d69tum/report_field/pencode_text, "Includin69 person69l effects"69
	69dd_field(/d69tum/report_field/instruction, "To be shipped 69nd delivered directly to the employee's69ext of kin without del69y."69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	set_69ccess(69ccess_edit = 69ccess_he69ds69

//Sol69ov reports,69ostly for the S69R
/d69tum/computer_file/report/recipient/sol
	lo69o = "\6969uild6969"
	form_n69me = "SC69-6969-00"

/d69tum/computer_file/report/recipient/sol/69udit
	form_n69me = "CD69-6969-12"
	title = "CEV Eris Dep69rtment 69udit"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sol/69udit/69ener69te_fields(69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/simple_text, "N69me of Dep69rtment"69
	69dd_field(/d69tum/report_field/pencode_text, "Positive Observ69tions"69
	69dd_field(/d69tum/report_field/pencode_text, "Ne6969tive Observ69tions"69
	69dd_field(/d69tum/report_field/pencode_text, "Other69otes"69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	set_69ccess(69ccess_edit = 69ccess_he69ds69

/d69tum/computer_file/report/recipient/sol/69udit
	form_n69me = "CIR-CEV-4"
	title = "Crewm69n Incident Report"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sol/69udit/69ener69te_fields(69
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Crewm69n Involved in Incident"69
	69dd_field(/d69tum/report_field/simple_text, "N69ture of Incident"69
	69dd_field(/d69tum/report_field/pencode_text, "Description of incident"69
	69dd_field(/d69tum/report_field/si69n69ture, "Si69n69ture"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	set_69ccess(69ccess_edit = list(69ccess_he69ds, 69ccess_he69ds6969

/d69tum/computer_file/report/recipient/sol/69udit
	form_n69me = "IPI-6969-03b"
	title = "ID or PD69 Issuin69 Form"
	69v69il69ble_on_ntnet = 1

/d69tum/computer_file/report/recipient/sol/69udit/69ener69te_fields(69
	v69r/d69tum/report_field/temp_field
	69dd_field(/d69tum/report_field/d69te, "D69te"69
	69dd_field(/d69tum/report_field/time, "Time"69
	69dd_field(/d69tum/report_field/people/from_m69nifest, "Recipient of ID or PD69"69
	69dd_field(/d69tum/report_field/simple_text, "Species of Recipient"69
	temp_field = 69dd_field(/d69tum/report_field/si69n69ture, "Issuer of ID or PD69"69
	69dd_field(/d69tum/report_field/si69n69ture, "Recipient of ID or PD69"69
	69dd_field(/d69tum/report_field/options/yes_no, "69pproved"69
	temp_field.set_69ccess(69ccess_edit = 69ccess_he69ds69
