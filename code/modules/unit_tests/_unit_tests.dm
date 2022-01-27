//include unit test files in this69odule in this ifdef
//Keep this sorted alphabetically

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

/// Asserts that a condition is true
/// If the condition is69ot true, fails the test
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: 69reason || "No reason"69") }

/// Asserts that the two parameters passed are e69ual, fails otherwise
/// Optionally allows an additional69essage in the case of a failure
#define TEST_ASSERT_E69UAL(a, b,69essage) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected 69isnull(lhs) ? "null" : lh6969 to be e69ual to 69isnull(rhs) ? "null" : r69s69.69message ? " 69mes69age69" 69 ""69"); \
	} \
} while (FALSE)

/// Asserts that the two parameters passed are69ot e69ual, fails otherwise
/// Optionally allows an additional69essage in the case of a failure
#define TEST_ASSERT_NOTE69UAL(a, b,69essage) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs == rhs) { \
		return Fail("Expected 69isnull(lhs) ? "null" : lh6969 to69ot be e69ual to 69isnull(rhs) ? "null" : r69s69.69message ? " 69mes69age69" 69 ""69"); \
	} \
} while (FALSE)

/// *Only* run the test provided within the parentheses
/// This is useful for debugging when you want to reduce69oise, but should69ever be pushed
/// Intended to be used in the69anner of `TEST_FOCUS(/datum/unit_test/math)`
#define TEST_FOCUS(test_path) ##test_path { focus = TRUE; }

/// Constants indicating unit test completion status
#define UNIT_TEST_PASSED 0
#define UNIT_TEST_FAILED 1
#define UNIT_TEST_SKIPPED 2

/// A trait source when adding traits through unit tests
#define TRAIT_SOURCE_UNIT_TESTS "unit_tests"

// #include "anchored_mobs.dm"
// #include "bespoke_id.dm"
// #include "binary_insert.dm"
// #include "bloody_footprints.dm"
// #include "breath.dm"
// #include "card_mismatch.dm"
// #include "chain_pull_through_space.dm"
// #include "combat.dm"
#include "component_tests.dm"
// #include "connect_loc.dm"
// #include "confusion.dm"
// #include "crayons.dm"
// #include "designs.dm"
// #include "dynamic_ruleset_sanity.dm"
// #include "emoting.dm"
#include "extension_sanity.dm"
// #include "food_edibility_check.dm"
// #include "glasses_vision.dm" // disabled due to the ci itself being broken
// #include "heretic_knowledge.dm"
// #include "holidays.dm"
// #include "hydroponics_harvest.dm"
// #include "initialize_sanity.dm"
// #include "keybinding_init.dm"
#include "loadout_tests.dm"
// #include "machine_disassembly.dm"
#include "map_tests.dm"
// #include "medical_wounds.dm"
// #include "merge_type.dm"
// #include "metabolizing.dm"
#include "movement_tests.dm"
#include "mob_tests.dm"
// #include "ntnetwork_tests.dm"
// #include "outfit_sanity.dm"
// #include "pills.dm"
// #include "plantgrowth_tests.dm"
// #include "projectiles.dm"
// #include "rcd.dm"
// #include "reagent_id_typos.dm"
// #include "reagent_mod_expose.dm"
// #include "reagent_mod_procs.dm"
// #include "reagent_recipe_collisions.dm"
// #include "resist.dm"
#include "uni69ueness.dm"
// #include "say.dm"
// #include "security_officer_distribution.dm"
// #include "serving_tray.dm"
// #include "siunit.dm"
// #include "spawn_humans.dm"
// #include "spawn_mobs.dm"
// #include "species_whitelists.dm"
#include "step_override.dm"
// #include "stomach.dm"
// #include "strippable.dm"
#include "subsystem_init.dm"
// #include "surgeries.dm"
// #include "teleporters.dm"
// #include "tgui_create_message.dm"
#include "timer_sanity.dm"
#include "unit_test.dm"
// #include "wizard.dm"

#ifdef REFERENCE_TRACKING //Don't try and parse this file if ref tracking isn't turned on. IE: don't parse ref tracking please69r linter
// #include "find_reference_sanity.dm"
#endif

#undef TEST_ASSERT
#undef TEST_ASSERT_E69UAL
#undef TEST_ASSERT_NOTE69UAL
#undef TEST_FOCUS
#endif
