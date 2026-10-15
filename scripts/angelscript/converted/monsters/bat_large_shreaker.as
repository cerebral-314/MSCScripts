#pragma context server

// Converted from monsters/bat_large_shreaker.script by msc_transpiler.
// Shreaker Bat by Thothie - most of this is from monsters/bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

[script "monsters/bat_large_shreaker"]
class BatLargeShreaker : BatBaseScript
{
	// Constants
	bool BAT_NO_FAKE_DEATH = true;
	int DMG_SHREAK = 150;
	float FREQ_SHREAK = 5.0f;
	string SOUND_SHREAK = "monsters/bat/zoobat.wav";
	string ANIM_SHREAK = "ANIM_SHREAK";
	string ANIM_HOVER = "IdleFlyFace";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_IDLE = "monsters/rat/squeak2.wav";
	string SOUND_ALERT = "monsters/bat/alert.wav";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_RETREAT = 0.0f;
	float NEXT_SHREAK = 0.0f;
	bool MOVE_MODE = false;

	// Variables declared by included files, with the value they start with in this script
	BatLargeShreaker()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
		ATTACK_DAMAGE = "50";
	}

	// unnamed block (first think)
	void BatLargeShreaker_FirstThink()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_RUN = ANIM_WALK;
		ANIM_ATTACK = "bite";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		ANIM_DEATH = "IdleFlyNormal"; // use normal flight for death anim (see end of script)

		MOVE_RANGE = "128";
		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "80%";
		NPC_GIVE_EXP = 75.0f;
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		SetBoundingBox("animsize");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (NPCATK_TARGET == "unset")
			return;
		if (RangeTo(NPCATK_TARGET) < 256.0f)
		{
			SetMoveAnim(ANIM_HOVER);
			PlayAnim("once", ANIM_HOVER);
			SetAnimMoveSpeed(0);
			MOVE_MODE = false;
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 0)));
			AS_ATTACKING = GameTime() + 2.0f;
		}
		else
		{
			SetAnimMoveSpeed(1);
			SetMoveAnim(ANIM_WALK);
			if (!MOVE_MODE)
			{
				PlayAnim("break");
				MOVE_MODE = true;
			}
		}
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BatBase_OnNpcTargetsighted(target); // monsters/bat_base
		if (!(RangeTo(NPCATK_TARGET) < 256.0f))
			return;
		if (!(GameTime() > NEXT_SHREAK))
			return;
		NEXT_SHREAK = GameTime();
		if (I_R_FROZEN)
			LegacyCommand("removeeffect", ENT_ME, "debuff_frozen");
		NEXT_SHREAK += FREQ_SHREAK;
		PlaySound(2, 10, SOUND_SHREAK, 0.8f, 200);
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 32, 3.0f, 2.0f);
		ClientEvent("new", "all", "effects/sfx_pulse_sphere", OriginOf(ENT_ME), 10.0f, IndexOf(ENT_ME), 2, 2, 0);
		CallEventDelayed(0.5f, "shreak_blast");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 512, 90, 3.0f, 512); // screenshake <position> <amplitude> <frequency> <duration> <radius>
	}

	// bat_spawn
	void OnBatSpawn()
	{
		SetName("Shrieker Bat");
		SetHealth(300);
		SetWidth(32);
		SetHeight(32);
		SetHearingSensitivity(3.5f);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
		SetModel("monsters/bat_large.mdl");
		SetProp(ENT_ME, "skin", 2);
	}

	// bat_drop_down
	// Drop down from the ceiling
	void OnBatDropDown()
	{
		CAN_HUNT = "1";
		BAT_STATUS = (BAT_FLYING ? 1 : 0);
		SetIdleAnim(ANIM_IDLE_FLY);
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		DoDamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME, "pierce");
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);

		if (!(GameTime() > NEXT_RETREAT))
			return;
		NEXT_RETREAT = GameTime() + Random(3, 5);
		float rndLr = Random(-300, 300);
		float rndFb = Random(-1500, 500);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, rndFb, 0)));
	}

	// shreak_blast
	void OnShreakBlast()
	{
		DoDamageEx(OriginOf(ENT_ME), 256, DMG_SHREAK, 0.1f, ENT_ME, ENT_ME, "none", "magic_effect", "dmgevent:shreak");
	}

	// shreak_dodamage
	void OnShreakDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// npc_death
	void OnNpcDeath()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("new", "all", "monsters/bat_large_corpse_cl", OriginOf(ENT_ME), 2);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/zubat_sphere.mdl");
		Precache("monsters/bat_large.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatLargeShreaker_FirstThink();
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bat_drop_down") { OnBatDropDown(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "shreak_blast") { OnShreakBlast(); return true; }
		if (name == "shreak_dodamage") { OnShreakDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BatBaseScript::DispatchEvent(name, params);
	}
}
