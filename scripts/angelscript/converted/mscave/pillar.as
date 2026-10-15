#pragma context server

// Converted from mscave/pillar.script by msc_transpiler.
// Thothie - crashes when given wrong object, attempting to fix
// - Issue: You cannot use null.mdl on an NPC like this - it causes mad animation errors.
// - This quests requires that you kill GhorAsh in Heras (who never spawned due to bug, nor dropped his item due to another bug)
// - Then you must take the item GhorAsh was *supposed* to drop to Sembelbinin Edana, except that, he's also bugged (won't accept it)
// - The idea being, he would then convert it into a token for this pillar. Which even if all that went well, STILL wouldn't work, as this pillar didn't precache Shadahar
// - As such, I feel it is time to simplify this quest, rather than fix that entire chain of scripts. Plus figure a way to make this accept random items. (which may not be possible)
// - I may come back later and get it to work proper... Meanwhile:
// - New quest: Kill GhorAsh (fixed), get 'Ring with Urdualian Runes XYPHEMOX'
// - Say XYPHEMOX to edana/masterp and Sembelbinin will tell you that the ring belonged to
// - the legendary Priest Zahlon Erste who imprisoned Shadahar in an epic battle ages ago.
// - Speaking Zahlon's last name to the pillar releases Shadahr.
// - New new quest: ^_^
// - Kill GhorAsh, get ring, take to Sembelin, mention the ruins, he will charge ring and give related story, bring to pillar to use.
// Spawn properties

#include "runtime/ScriptEntity.as"

[script "mscave/pillar"]
class Pillar : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;
	bool GOT_RING = false;
	bool SHAD_SPAWN = false;

	// unnamed block (first think)
	void Pillar_FirstThink()
	{
		// ALL media used by spawned monster MUST be precached individually (precache file only catches non-vars/const)
		PrecacheFile("mscave/Shadahar");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetName("The Enchanted Pillar");
		SetWidth(32);
		SetHeight(32);
		SetRoam(false);
		SetRace("neutral");
		SetModel("props/skullprop.mdl");
		CANCHAT = 1;
		SetInvincible(true);
		CatchSpeech("say_release", "erste");
		CatchSpeech("say_hail", "hail", "hey", "j0", "hello", "hi", "greetings", "gweets", "waddup", "yo");

		SetMenuAutoOpen(true);
	}

	// say_release
	void OnSayRelease()
	{
		SayText("The name is not what I require, but the light of the ring, this is what I desire!");
	}

	// say_hail
	void OnSayHail()
	{
		bool exitSub = false;

		if (Truthy(ItemExists(ENT_LASTSPOKE, "item_runicsymbol2")))
		{
			SayText("Come hither, closer to me! You have that which will set me free!");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(ItemExists(ENT_LASTSPOKE, "item_runicsymbol")))
		{
			SayText("Too soon, you have come, your journey, it is not done.");
			exitSub = true;
		}
		if (exitSub)
			return;

		SayText("Mortal, speak warily unto me, you have not that which sets me free.");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (GOT_RING)
			return;

		SetSayTextRange(1024);

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			CallEventDelayed(5.0f, "gave_ring");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			return;

		// dbg This guy get here honestly? ( LEG $get_map_legit(PARAM1) LAST $get_lastmap(PARAM1) )
		if (Truthy(ItemExists(player, "item_runicsymbol2")))
		{
			menuItem.title = "Insert the Urdualian Ring";
			menuItem.type = "payment_silent";
			menuItem.data = "item_runicsymbol2";
			menuItem.callback = "gave_ring";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "item_runicsymbol")))
		{
			menuItem.title = "Insert the Expended Ring";
			menuItem.type = "payment_silent";
			menuItem.data = "item_runicsymbol";
			menuItem.callback = "wrong_ring";
			RegisterMenuItem(menuItem);
		}
	}

	// wrong_ring
	void OnWrongRing(CBasePlayer@ player = null)
	{
		SayText("This ring, it shines not, therefore no evil, shall it wrought.");
		Offer(player, "item_runicsymbol");
	}

	// gave_ring
	void OnGaveRing(CBasePlayer@ ringBearer = null)
	{
		SetModelBody(0, 1); // eyes gow red (not that you can tell)
		GOT_RING = true;
		UseTrigger("mm_shad");
		CallEventDelayed(0.0f, "4");
		SayText("At last! I shall be freed! ...and upon you, first shall I feed!");
	}

	// spawnage
	void OnSpawnage()
	{
		if (SHAD_SPAWN)
			return;
		// Again, highly recommend calling map events to make these things more dynamic
		// -Also more stable, as createnpc doesn't clear memory the same way msmonster does
		UseTrigger("spawn_shad");

		// -At least switching to relitive position to make this a more dynamic
		// -Pillar position in mscave: -549 -674 1219
		// -original Shadahar position: (-791,-674,1232) //not working either ><
		// - $relpos(-242,0,13) ? Not working - original pos is wrong. :/
		// createnpc mscave/Shadahar $relpos(0,-128,0)
		// Deleting instantly seems to be causing npc not to spawn/event trigger
		CallEventDelayed(0.0f, "2");
		SHAD_SPAWN = true;
	}

	// gobyebye
	void OnGobyebye()
	{
		UseTrigger("pillar_removed");
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		Precache("weapons/magic/seals.mdl");
		Precache("skull.spr");
		Precache("props/skullprop.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Pillar_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "gave_ring") { OnGaveRing(PlayerParam(params, 0)); return true; }
		if (name == "gobyebye") { OnGobyebye(); return true; }
		if (name == "say_hail") { OnSayHail(); return true; }
		if (name == "say_release") { OnSayRelease(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "spawnage") { OnSpawnage(); return true; }
		if (name == "wrong_ring") { OnWrongRing(PlayerParam(params, 0)); return true; }
		return false;
	}
}
