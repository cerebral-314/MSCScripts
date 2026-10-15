#pragma context server

// Converted from items/blunt_snake_staff.script by msc_transpiler.
// Snakestaff by Thothie from Hammer
// - Todos:
// - Secondary attack summons snake but poisons owner
// - Convert Model

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_snake_staff"]
class BluntSnakeStaff : BluntBaseOnehandedScript
{
	// Constants
	int MODEL_VIEW_IDX = 4;
	string MODEL_PLAYER = "weapons/staff/snake_staff_player.mdl";
	int SECONDARY_DMG = 0;
	string SOUND_SUMMON = "magic/spawn.wav";
	string SOUND_BITE = "bullchicken/bc_bite2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	bool BLUNT_NO_STUN = true;

	// Variables (an unset .script variable reads as its own name)
	float SNAKES_CREATED = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntSnakeStaff()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "58";
		ANIM_PREFIX = "khopesh";
		MELEE_STAT = "spellcasting.affliction";
		MELEE_DMG_TYPE = "poison";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.3f;
		MELEE_ATK_DURATION = 0.6f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 30;
		MELEE_DMG_RANGE = 60;
		MELEE_ACCURACY = "65%";
	}

	// unnamed block (first think)
	void BluntSnakeStaff_FirstThink()
	{
		PrecacheFile("monsters/summon/snake_cursed");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Snake Staff");
		SetDescription("A magic staff used by snake charmers");
		SetWeight(10);
		SetValue(500);
		SetHudSprite("hand", "79");
		SetHudSprite("trade", "79");
	}

	// melee_strike
	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (!(RangeTo(ENT_LASTSTRUCKBYME) < 100.0f))
			return;

		int random = RandomInt(1, 100);
		if (!(random < 15))
			return;
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", RandomInt(3, 6), @EntityOf(ENT_OWNER), Random(3, 10), "spellcasting.affliction");
		PlaySound(0, 10, SOUND_BITE);
		CallEventDelayed(0.1f, "second_sound");
	}

	// second_sound
	void OnSecondSound()
	{
		PlaySound(0, 10, SOUND_POISON);
	}

	// melee_start
	void OnMeleeStart()
	{
		int vattackAnim = 0;

		int vattack = RandomInt(1, 3);
		if (vattack == 1)
			vattackAnim = Int(ANIM_ATTACK1);
		if (vattack == 2)
			vattackAnim = Int(ANIM_ATTACK2);
		if (vattack == 3)
			vattackAnim = Int(ANIM_ATTACK3);
		PlayViewAnim(vattackAnim);
		if (PLAYERANIM_SWING != "PLAYERANIM_SWING")
			PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	// special_02_start
	void OnSpecial02Start()
	{
		PlayViewAnim(5);

		if (SNAKES_CREATED >= 20.0f)
			OwnerMessage("The staffs magic is depleted, it may recharge in time.");
		if (!(SNAKES_CREATED < 20.0f))
			return;

		SNAKES_CREATED += 1.0f;
		ApplyEffect(ENT_OWNER, "effects/dot_poison_blind", 5, self, Random(1, 5), "none");
		OwnerMessage("You have been poisoned by your snake staff!");
		float ncharges = 20.0f - SNAKES_CREATED;
		ncharges = int(ncharges);
		OwnerMessage("Staff has " + Text(ncharges) + " charges remaining");
		PlaySound(0, 10, SOUND_SUMMON);
		Vector3 spawnPos = RelativePosition(Vector3(0, 60, 0)); // surprised this works
		spawnPos.z = GroundHeight(spawnPos);
		CreateNpc("monsters/summon/snake_cursed", RelativePosition(Vector3(0, 60, 0)), @EntityOf(ENT_OWNER));
		Effect("glow", ENT_LASTCREATED, Vector3(0, 255, 0), 100, 1, 1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BluntSnakeStaff_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "second_sound") { OnSecondSound(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
