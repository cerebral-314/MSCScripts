#pragma context server

// Converted from items/base_kick.script by msc_transpiler.
// Megafootz by Thothie
// - To be added to fisted/gauntlet attacks
// - Assumes base_mele is included with above weapon

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseKick
{
	// Constants
	string ANIM_KICK = "1";
	string ANIM_FOOT_IDLE = "idle";
	string OWNANIM_KICK = "stance_normal_highkick_r1";
	string KICK_VIEW = "weapons/martialarts/foot.mdl";
	string SOUND_KICKHIT = "SOUND_KICKHIT";

	// Variables (an unset .script variable reads as its own name)
	bool DOING_KICK = false;

	// register_charge1
	void BaseKick_OnRegisterCharge1()
	{
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 100);
		SetLocal("reg.attack.dmg", 200);
		SetLocal("reg.attack.dmg.range", 10);
		SetLocal("reg.attack.dmg.type", "blunt");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "martialarts");
		SetLocal("reg.attack.hitchance", "90%");
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "kickatk");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 5);

		RegisterAttack();
	}

	// kickatk_start
	void BaseKick_OnKickatkStart()
	{
		DOING_KICK = true;
		SetViewModel(KICK_VIEW);
		CallEventDelayed(0.1f, "kick_go");
		ServerPlaySound(0, 8, ScriptVarOf(ENT_OWNER, "PLR_SOUND_JAB2"));
	}

	// kick_go
	void BaseKick_OnKickGo()
	{
		PlayViewAnim(Int(ANIM_KICK));
		PlayOwnerAnim("critical", "stance_normal_highkick_r1");
		CallEventDelayed(0.5f, "restore_hands");
	}

	// game_dodamage
	string BaseKick_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		if (!DOING_KICK)
			return result;

		DOING_KICK = false;

		if (!IsPvp() && IsPlayer(target))
			return result;

		PlaySound(0, 8, "weapons/cbar_hitbod1.wav");

		float maSkill = SkillOf(ENT_OWNER, "martialarts");
		if (maSkill >= 10.0f && RangeTo(target) < 100.0f && MaxHealthOf(target) < 1250.0f && RelationshipOf(target, ENT_ME) != "ally")
		{
			if (IsAlive(target)) // MAR2010_24 attempts to prevent kicking buttons off map
			{
				if (RaceOf(target) != "0") // MAR2010_24 ditto
				{
					float pushStrLr = maSkill * 15.0f;
					float pushStrF = maSkill;
					string pushStrFText;
					pushStrF *= 20.0f;
					float pushStrV = maSkill;
					string pushStrVText;
					pushStrV *= 5.0f;

					// dbg temp strlr PUSH_STR_LR f PUSH_STR_F u PUSH_STR_V
					// caps
					if (pushStrLr > 300.0f)
						pushStrLr = 300.0f;
					if (pushStrF > 400.0f)
						pushStrF = 400.0f;
					if (pushStrV > 100.0f)
						pushStrV = 100.0f;
					float r = RandomInt(50, int(pushStrLr));
					if (RandomInt(1, 2) == 1)
						r = -r;

					Vector3 pushVel = RelativeVelocity(Vector3(r, pushStrF, pushStrV));
					AddVelocity(target, pushVel);
				}
			}
		}
		if (maSkill >= 20.0f)
		{
			float stunDur = maSkill;
			string stunDurText;
			stunDur = Divide(stunDur, 3.0f);
			stunDurText = Text(stunDur);
			if (stunDur > 20.0f)
			{
				stunDur = 20.0f;
				stunDurText = Text(stunDur);
			}
			float targHp = HealthOf(target);
			if (targHp > 1000.0f)
			{
				int failRatio = RandomInt(1, 9999);
				if (failRatio < targHp)
					exitSub = true;
			}
			if (!exitSub)
				ApplyEffect(target, "effects/debuff_stun", stunDurText, self);
		}
		return result;
	}

	// restore_hands
	void BaseKick_OnRestoreHands()
	{
		DOING_KICK = false;
		SetViewModel(MODEL_VIEW);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnRegisterCharge1() { BaseKick_OnRegisterCharge1(); } // register_charge1
	void OnKickatkStart() { BaseKick_OnKickatkStart(); } // kickatk_start
	void OnKickGo() { BaseKick_OnKickGo(); } // kick_go
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseKick_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnRestoreHands() { BaseKick_OnRestoreHands(); } // restore_hands

	// This file's events and timers by their .script names
	bool BaseKick_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "kick_go") { OnKickGo(); return true; }
		if (name == "kickatk_start") { OnKickatkStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "restore_hands") { OnRestoreHands(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_kick"]
shared class BaseKickScript : ScriptEntity, BaseKick
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	int ANIM_HANDS_DOWN = 0;
	string ANIM_IDLE1 = "ANIM_IDLE1";
	string ANIM_IDLE2 = "ANIM_IDLE2";
	string ANIM_IDLE3 = "ANIM_IDLE3";
	int ANIM_IDLE4 = 0;
	int ANIM_IDLE5 = 0;
	int ANIM_IDLE_DELAY_HIGH = 0;
	int ANIM_IDLE_DELAY_LOW = 0;
	int ANIM_IDLE_TOTAL = 0;
	int ANIM_LIFT1 = 0;
	string ANIM_LOWER = "ANIM_LOWER";
	string ANIM_PREFIX = "ANIM_PREFIX";
	int ANIM_SHEATH = 0;
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	bool BITEM_UNDERSKILLED = false;
	float BI_IDLE_PENDING = 0.0f;
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	float BWEAPON_CHARGE_PERCENT = 0.0f;
	float BWEAPON_DBL_CHARGE_ADJ = 0.0f;
	float FISTS_LAST_ATTACK = 0.0f;
	float FREQ_NUB = 0.0f;
	bool IS_RESERVED = false;
	bool IS_WEAPON = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	float MELEE_ATK_DURATION = 0.0f;
	string MELEE_CALLBACK = "MELEE_CALLBACK";
	string MELEE_CALLBACK_CHARGED = "MELEE_CALLBACK_CHARGED";
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "MELEE_DMG_TYPE";
	int MELEE_NOISE = 0;
	string MELEE_PARRY_CHANCE = "MELEE_PARRY_CHANCE";
	string MELEE_RANGE = "MELEE_RANGE";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_STAT = "MELEE_STAT";
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	string MODEL_WORLD = "MODEL_WORLD";
	bool NOOB_LOOP = false;
	float PARRY_MULTI_OUT = 0.0f;
	string PARRY_VALUE = "PARRY_VALUE";
	string PLAYERANIM_AIM = "PLAYERANIM_AIM";
	int PUNCH_ATTACK = 0;
	string SOUND_HITWALL1 = "SOUND_HITWALL1";
	string SOUND_HITWALL2 = "SOUND_HITWALL2";
	string SOUND_SWIPE = "SOUND_SWIPE";
	string SPECIAL01_SND = "SPECIAL01_SND";
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/martialarts/foot.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseKick_DispatchEvent(name, params);
	}
}
