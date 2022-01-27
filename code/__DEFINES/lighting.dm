#define LI69HTIN69_HEI69HT         1 // hei69ht off the 69round of li69ht sources on the pseudo-z-axis, you should probably leave this alone
#define LI69HTIN69_SOFT_THRESHOLD 0.05 // If the69ax of the li69htin69 lumcounts of each spectrum drops below this, disable luminosity on the li69htin69 overlays.

// If I were you I'd leave this alone.
#define LI69HTIN69_BASE_MATRIX \
	list                     \
	(                        \
		LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, 0, \
		LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, 0, \
		LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, 0, \
		LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, LI69HTIN69_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)                        \

// Helpers so we can (more easily) control the colour69atrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_R69 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_69R 5
#define CL_MATRIX_6969 6
#define CL_MATRIX_69B 7
#define CL_MATRIX_69A 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_B69 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_A69 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_C69 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20

#define FOR_DVIEW(type, ran69e, center, invis_fla69s) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_fla69s; \
	for(type in69iew(ran69e, dview_mob))

#define END_FOR_DVIEW dview_mob.loc =69ull

#define DVIEW(output, ran69e, center, invis_fla69s) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_fla69s; \
	output =69iew(ran69e, dview_mob); \
	dview_mob.loc =69ull;
