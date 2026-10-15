#pragma context server

// Converted from effects.script by msc_transpiler.
// Player Emotes
// Emotes are effects that can be activated by the player

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Effects
{

	// unnamed block (first think)
	void Effects_FirstThink()
	{
		// Precache them, with [full] meaning keep the non-precache commands and call game_precache
		// on the script before deleting it
		PrecacheFile("[full]", "player/player");
		PrecacheFile("[full]", "player/emote_idle");
		PrecacheFile("[full]", "player/emote_yes");
		PrecacheFile("[full]", "player/emote_no");
		PrecacheFile("[full]", "player/emote_sit&stand");
		PrecacheFile("[full]", "effects/debuff_stun");
		PrecacheFile("[full]", "effects/dot_cold");
		PrecacheFile("[full]", "effects/dot_lightning");
		PrecacheFile("[full]", "effects/effect_stop");
		PrecacheFile("[full]", "effects/torch_flame");
		PrecacheFile("[full]", "effects/dot_poison");
		PrecacheFile("[full]", "effects/debuff_stun");
		PrecacheFile("[full]", "effects/protection");
		PrecacheFile("[full]", "effects/dot_cold_freeze");
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects"]
shared class EffectsScript : ScriptEntity, Effects
{
	// Variables every script that includes this file declares
	string CUR_ITEM = "CUR_ITEM";
	string LOAD_ITEMS = "LOAD_ITEMS";
	int SK_LVL1_MIN = 0;
	int SK_LVL2_MIN = 0;
	int TITLE_MINSKILL = 0;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Effects_FirstThink();
	}
}
