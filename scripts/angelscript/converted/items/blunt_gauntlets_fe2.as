#pragma context server

// Converted from items/blunt_gauntlets_fe2.script by msc_transpiler.
// Greater Flesheater Gauntlets by CrazyMonkeyDude
// Greaters do more damage, have a poison burst on right-click, and have a small lifesteal on regular attack.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_gauntlets_fe1.as"

[script "items/blunt_gauntlets_fe2"]
class BluntGauntletsFe2 : BluntGauntletsFe1Script
{
	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsFe2()
	{
		MELEE_DMG = 250;
		MELEE_ACCURACY = "85%";
		MELEE_AFFLIC_RATIO = 0.8f;
		MELEE_AFFLICDMG_MIN = 20;
		GOUGE_MPDRAIN = 40;
		GOUGE_MPSTEAL = 30;
		GOUGE_LIFESTEAL_RATIO = 0.17f;
		AURA_DOT_RATIO = 0.6f;
		AURA_RADIUS = 100;
		SOUND_GROWL1 = "monsters/zombie1/zo_pain1.wav";
		SOUND_GROWL2 = "monsters/zombie1/zo_pain3.wav";
		SOUND_GROWL3 = "monsters/gonome/gonome_pain1.wav";
		SOUND_GROWL4 = "monsters/gonome/gonome_pain2.wav";
		SOUND_GROWL5 = "monsters/gonome/gonome_pain3.wav";
		SOUND_GROWL6 = "monsters/gonome/gonome_pain4.wav";
		NOVA_SCRIPT = "monsters/summon/poison_burst";
		DMG_NOVA = 50;
		NOVA_MPDRAIN = 60;
		NOVA_ATKDELAY = 8.0f;
	}

	// game_precache
	void BluntGauntletsFe2_OnGamePrecache()
	{
		PrecacheFile(NOVA_SCRIPT);
	}

	// game_precache
	void OnGamePrecache()
	{
		BluntGauntletsFe2_OnGamePrecache();
		BluntGauntletsFe1_OnGamePrecache(); // items/blunt_gauntlets_fe1
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsFe1_OnWeaponSpawn(); // items/blunt_gauntlets_fe1
		BluntGauntletsFe1_OnWeaponSpawn_2(); // items/blunt_gauntlets_fe1

		SetName("Greater Venom Claws");
		SetDescription("Vicious claws have burst from your hands!");

		CallEventDelayed(0.1f, "growl_noises");
	}

	// do_special_damage
	void OnDoSpecialDamage(CBaseEntity@ target = null)
	{
		BluntGauntletsFe1_OnDoSpecialDamage(target); // items/blunt_gauntlets_fe1
		float lifeStolen = 0.0f * DamageTakenOf(target, "acid") * 0.01f;
		string lifeStolenText = Text(lifeStolen);
		OnTryVampireTarget(EntityOf(ENT_OWNER), target, lifeStolenText);
	}

	// growl_noises
	void OnGrowlNoises()
	{
		CallEventDelayed(RAND_GROWL, "growl_noises");
		PlayRandomSound(0, 8, SOUND_GROWL1, SOUND_GROWL2, SOUND_GROWL3, SOUND_GROWL4, SOUND_GROWL5, SOUND_GROWL6);
		Effect("glow", ENT_OWNER, Vector3(0, 255, 0), 256, 1.9f, 1.9f);
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;
		if (!CanAttack(ENT_OWNER))
			return;

		if (GameTime() < DELAY_NOVA)
		{
			exitSub = true;
			if (GameTime() > LAST_ERR)
			{
				PlayerMessageDark(ENT_OWNER, "Too soon to use Poison Burst again!");
				LAST_ERR = GameTime() + 2.0f;
			}
		}
		if (exitSub)
			return;

		if (ManaOf(ENT_OWNER) < NOVA_MPDRAIN)
		{
			PlayerMessageDark(ENT_OWNER, "Greater Flesheater Gauntlets: Insufficient mana for Poison Burst.");
			exitSub = true;
		}
		if (exitSub)
			return;

		DELAY_NOVA = GameTime() + NOVA_ATKDELAY;
		float dotPoison = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.5f;
		CreateNpc(NOVA_SCRIPT, RelativePosition(Vector3(0, 0, 0)), @EntityOf(ENT_OWNER), 86, 1, DMG_NOVA, dotPoison);

		GiveMana(ENT_OWNER, -NOVA_MPDRAIN);
		CallExternal(ENT_OWNER, "mana_drain");

		LAST_ERR = GameTime() + 2.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnRandGrowl() {} // RAND_GROWL

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_special_damage") { OnDoSpecialDamage(EntityParam(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "growl_noises") { OnGrowlNoises(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntGauntletsFe1Script::DispatchEvent(name, params);
	}
}
