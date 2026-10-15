#pragma context server

// Converted from monsters/orc_cata_winder.script by msc_transpiler.
// Orc catapult winder just winds catapults, firing them if uninterupted for long enough
// - hope is to set it up to fire map event by the name of the params passed to it, so mappers can setup multiples of them
// - it does not have the full AI, as it only responds to being struck by turning and kicking players once in awhile

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/orc_cata_winder"]
class OrcCataWinder : BaseNpcScript
{
	// Constants
	string ANIM_IDLE = "idle1";
	string ANIM_ATTACK = "kick";
	string ANIM_WIND = "turn_valve";
	string FLINCH_CHANCE = "50";
	int KICK_RANGE = 180;
	string DMG_KICK = "80";
	string ATTACK_HITCHANCE = "90";
	float FREQ_KICK = 7.0f;
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_HIT = "voices/orc/hit.wav";
	string SOUND_HIT2 = "voices/orc/hit2.wav";
	string SOUND_HIT3 = "voices/orc/hit3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string SOUND_WARCRY1 = "monsters/orc/battlecry.wav";
	string SOUND_HELP = "voices/orc/help.wav";
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	bool WIND_ON = false;
	float MY_YAW = 0.0f;
	string TRIG_PREFIX = "TRIG_PREFIX";
	bool KICK_DELAY = false;
	CBaseEntity@ FINAL_KICK_TARG = null;

	// Variables declared by included files, with the value they start with in this script
	OrcCataWinder()
	{
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void OrcCataWinder_FirstThink()
	{
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die_fallback";
	}

	// game_dodamage
	string OrcCataWinder_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 64, 1, 1);

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);

		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 800)));
		return result;
	}

	// unnamed block (timer)
	void OrcCataWinder_Timer()
	{
		CallEventDelayed(7.0f, "OrcCataWinder_Timer");

		if (!IsAlive(ENT_ME))
			return;

		if (!WIND_ON)
			OnWindToggle();
		OnFaceCata();
		PlayAnim("once", ANIM_WIND);
		SetIdleAnim(ANIM_WIND);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc

		string trigString = TRIG_PREFIX + "_died";
		UseTrigger(trigString);

		if (WIND_ON)
			OnWindToggle();
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = params string
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc

		NEW_NAME = title;
		if (NEW_NAME != "default")
			SetName(NEW_NAME);
		NPC_DMG_MULTI = 1.0f;
		if (Float(damageMultiplier) > 1.0f)
		{
			NPC_DMG_MULTI += Float(damageMultiplier);
			SetDamageMultiplier(Float(damageMultiplier));
		}

		NPC_HP_MULTI = 1.0f;
		if (Float(healthMultiplier) > 1.0f)
		{
			float myHp = MaxHealthOf(ENT_ME) * Float(healthMultiplier);
			SetHealth(myHp);
		}

		TRIG_PREFIX = params;
	}

	// game_struck
	// PARAM1 = damage
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc

		if (!IsAlive(ENT_ME))
			return;

		if (damage > 20.0f && RandomInt(1, 100) < Float(FLINCH_CHANCE))
			PlayAnim("critical", ANIM_FLINCH);

		if (KICK_DELAY)
			return;
		KICK_DELAY = true;
		CallEventDelayed(FREQ_KICK, "reset_kick_delay");

		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");

		if (!(damage > 20.0f))
			return;
		CBaseEntity@ kickTarg = EntityOf(ENT_LASTSTRUCK);
		if (!(RangeTo(kickTarg) < KICK_RANGE))
			return;

		SetMoveDest(@kickTarg, 9999);
		@FINAL_KICK_TARG = kickTarg;
		PlayAnim("critical", ANIM_ATTACK);
		CallEventDelayed(2.0f, "face_cata");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Orc Catapult Winder");
		SetRace("orc");

		SetModel("monsters/orc_big.mdl");
		SetWidth(38);
		SetHeight(72);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
		SetModelBody(0, 2); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		SetSkillLevel(80);
		SetGold(RandomInt(10, 30));
		SetHealth(2000);
		SetDamageTaken("all", 0.5f);
		SetStat("parry", 40);

		SetDamageTaken("stun", 0);

		WIND_ON = false;

		CallEventDelayed(1.0f, "get_yaw");
	}

	// get_yaw
	void OnGetYaw()
	{
		MY_YAW = Float(Eval("game.monster.angles.yaw"));
		MY_YAW += -90.0f;
		SetAngle("face", Vector3(0, MY_YAW, 0));
		LegacyCommand("setorigin", RelativePosition(Vector3(0, -18, 0)));
	}

	// face_cata
	void OnFaceCata()
	{
		// resume winding
		SetAngle("face", Vector3(0, MY_YAW, 0));
	}

	// reset_kick_delay
	void OnResetKickDelay()
	{
		KICK_DELAY = false;
	}

	// kick_land
	void OnKickLand()
	{
		DebugPrint("kick_landed: " + NameOf(FINAL_KICK_TARG) + " " + Text(RangeTo(FINAL_KICK_TARG)));
		OnBaseorcYell();
		// if $get(FINAL_KICK_TARG,range) < KICK_RANGE
		DoDamage(FINAL_KICK_TARG, KICK_RANGE, DMG_KICK, "100%", "blunt"); // <target> <range> <dmg> <cth> [type]
	}

	// baseorc_yell
	void OnBaseorcYell()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return OrcCataWinder_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// fire_cata
	// model event
	void OnFireCata()
	{
		if (!IsAlive(ENT_ME))
			return;

		string trigString = TRIG_PREFIX + "_fire";
		UseTrigger(trigString);
		SetIdleAnim(ANIM_IDLE);

		if (WIND_ON)
			CallEventDelayed(2.0f, "wind_toggle");
	}

	// wind_toggle
	void OnWindToggle()
	{
		if (!WIND_ON)
			WIND_ON = true;
		else
			WIND_ON = false;

		string trigString = TRIG_PREFIX + "_wind";
		UseTrigger(trigString);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqKick() {} // FREQ_KICK

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc_big.mdl");
		CallEventDelayed(7.0f, "OrcCataWinder_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcCataWinder_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "baseorc_yell") { OnBaseorcYell(); return true; }
		if (name == "face_cata") { OnFaceCata(); return true; }
		if (name == "fire_cata") { OnFireCata(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_yaw") { OnGetYaw(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "reset_kick_delay") { OnResetKickDelay(); return true; }
		if (name == "wind_toggle") { OnWindToggle(); return true; }
		if (name == "OrcCataWinder_Timer") { OrcCataWinder_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
