#pragma context server

// Converted from items/blunt_staff_i.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_staff_i"]
class BluntStaffI : BluntBaseTwohandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "25";
	bool ICEMAN_MP = true;
	float DOT_RATIO = 0.5f;
	float DEMON_DMG_DELAY = 0.25f;
	float DEMON_ATK_DURATION = 0.7f;
	int MODEL_VIEW_IDX = 11;
	string SPECIAL_02_MP = "30";
	bool CUSTOM_REGISTER_CHARGE1 = true;

	// Variables (an unset .script variable reads as its own name)
	float CONSEC_ATTACKS = 0.0f;
	int GAME_PVP = 0;
	float OWNER_SKILL = 0.0f;
	bool MELEE_ATTACK = false;
	CBaseEntity@ MELEE_TARG = null;
	CBaseEntity@ OLD_MELEE_TARG = null;
	float NEXT_ICEMAN = 0.0f;
	bool ICEMAN_ON = false;
	string CL_ICEMAN_FX_INDEX = "CL_ICEMAN_FX_INDEX";
	float ICEMAN_YAW = 0.0f;
	bool SLOW_LOOP_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	BluntStaffI()
	{
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.4f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 200;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_AUGMENT = "20%";
		MELEE_DMG_TYPE = "cold";
		MELEE_STAT = "spellcasting.ice";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "25";
		ANIM_PREFIX = "standard";
		SPECIAL_02_CALLBACK = "attack_lance";
		SPECIAL_02_DELAY_STRIKE = 0.4f;
		SPECIAL_02_DELAY_END = 0.9f;
		SPECIAL_02_RANGE = "0";
		MELEE_CALLBACK = "attack_bolt";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "pole_swing";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		CONSEC_ATTACKS = 0.0f;
		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_SKILL = SkillOf(ENT_OWNER, "spellcasting.ice");
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		if (!ICEMAN_ON)
			return;
		OnEndIceman();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Ice Staff");
		SetDescription("A staff of elemental ice");
		SetWeight(30);
		SetValue(5000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "48");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee

		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "attack2_bolt");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// attack_bolt_start
	void OnAttackBoltStart()
	{
		bool exitSub = false;

		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);

		CBaseEntity@ ownerTarget = TargetOf(ENT_OWNER);
		if (IsAlive(ownerTarget) && RangeTo(ownerTarget) <= Float(MELEE_RANGE))
		{
			DebugPrint("attack_bolt_start " + EntityId(TargetOf(ENT_OWNER)) + " " + Text(RangeTo(ownerTarget)));
			MELEE_ATTACK = true;
			PlayItemViewAnim(ENT_ME, 2);
			exitSub = true;
		}
		if (exitSub)
			return;
		if (BITEM_UNDERSKILLED)
		{
			MELEE_ATTACK = true;
			PlayItemViewAnim(ENT_ME, 2);
			exitSub = true;
		}
		if (exitSub)
			return;
		MELEE_ATTACK = false;
		PlayItemViewAnim(ENT_ME, 9);
	}

	// attack_bolt_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnAttackBoltStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		float dot = 0.0f;

		if (!(OWNER_SKILL > Float(BASE_LEVEL_REQ)))
			return;

		if (!MELEE_ATTACK)
		{
			if (IsAlive(hitEntity) && RangeTo(hitEntity) < 150.0f)
				exitSub = true;
			if (!exitSub)
			{
				PlaySound(0, 10, "magic/ice_strike.wav");

				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
				CallExternal(ENT_OWNER, "ext_tossprojectile", "proj_staff_ice_bolt", "view", "none", 400, 0, 0, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
			}
		}
		else if (IsAlive(hitEntity))
		{
			@MELEE_TARG = hitEntity;
			if (IsPlayer(MELEE_TARG) && GAME_PVP == 0)
				exitSub = true;
			if (!exitSub && RelationshipOf(MELEE_TARG, ENT_OWNER) == "enemy")
			{
				if (MELEE_TARG is OLD_MELEE_TARG)
					CONSEC_ATTACKS += 1.0f;
				else
					CONSEC_ATTACKS = 0.0f;
				@OLD_MELEE_TARG = MELEE_TARG;
				if (CONSEC_ATTACKS == 5.0f)
				{
					if (Truthy(ScriptVarOf(hitEntity, "I_R_FROZEN")))
					{
						CONSEC_ATTACKS = 0.0f;
						dot = OWNER_SKILL * DOT_RATIO;
						ApplyEffect(hitEntity, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
						exitSub = true;
					}
					if (!exitSub)
					{
						float maxHp = MaxHealthOf(ENT_OWNER) * 3.0f;
						if (maxHp < 2000.0f)
							maxHp = 2000.0f;
						if (HealthOf(hitEntity) < maxHp && ManaOf(ENT_OWNER) > 30.0f)
						{
							GiveMana(ENT_OWNER, -30);
							ApplyEffect(hitEntity, "effects/dot_cold_freeze", 5.0f, @EntityOf(ENT_OWNER), 0, "spellcasting.ice", maxHp);
							CONSEC_ATTACKS = 0.0f;
						}
					}
				}
				else
				{
					dot = OWNER_SKILL * DOT_RATIO;
					ApplyEffect(hitEntity, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
					if (Truthy(ScriptVarOf(hitEntity, "I_R_FROZEN")))
						CONSEC_ATTACKS = 0.0f;
				}

				DebugPrint("attack_bolt_strike " + Text(CONSEC_ATTACKS));
			}
		}
		MELEE_ATTACK = false;
	}

	// attack_lance_start
	void OnAttackLanceStart()
	{
		PlayViewAnim(9);
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
	}

	// attack_lance_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnAttackLanceStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		if (IsAlive(hitEntity) && RangeTo(hitEntity) < 150.0f)
			exitSub = true;
		if (exitSub)
			return;
		PlaySound(0, 10, "magic/ice_strike.wav");

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		CallExternal(ENT_OWNER, "ext_tossprojectile", "proj_staff_icelance", "view", "none", 400, 0, 0, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;
		if (!(OWNER_SKILL > Float(BASE_LEVEL_REQ)))
			return;
		if (!CanAttack(ENT_OWNER))
			return;
		if (ICEMAN_ON)
			return;
		if (!(GameTime() > NEXT_ICEMAN))
			return;
		NEXT_ICEMAN = GameTime() + 0.25f;
		ICEMAN_ON = true;
		if (ManaOf(ENT_OWNER) < (ICEMAN_MP ? 1.0f : 0.0f))
		{
			PlayerMessageDark(ENT_OWNER, "Ice Staff: Not enough MP for Ice Slide ( " + Text(ICEMAN_MP) + " )");
			exitSub = true;
		}
		if (exitSub)
			return;

		PlaySound(0, 10, "magic/frost_pulse.wav");
		CallExternal(ENT_OWNER, "ext_ice_staff_on");
		ClientEvent("new", "all", "items/blunt_staff_i_cl", IndexOf(ENT_OWNER));
		CL_ICEMAN_FX_INDEX = LastClientScriptId();
		ICEMAN_YAW = AnglesOf(ENT_OWNER).y;
		CallExternal(ENT_OWNER, "ext_removed_effects", "nojump");
		ApplyEffect(ENT_OWNER, "effects/effect_nojump", @EntityOf(ENT_OWNER));
		PlayOwnerAnim("hold", "nod_yes", 0, 3);
		// callexternal ent_owner ext_leg_lock 1 //no workie
		OnDoIcemanLoop();
	}

	// do_iceman_loop
	void OnDoIcemanLoop()
	{
		Vector3 orgVel = Vec("ORG_VEL");
		string curVel = "CUR_VEL";
		if (!ICEMAN_ON)
			return;
		if (ManaOf(ENT_OWNER) > (ICEMAN_MP ? 1.0f : 0.0f))
		{
			if (IsInHand(ENT_ME))
				CallEventDelayed(0.1f, "do_iceman_loop");
			else
				OnEndIceman();
		}
		else
		{
			OnEndIceman();
		}

		if (!IsOnGround(ENT_OWNER))
		{
			// local CUR_VEL $get(ent_owner,velocity)
			// vectormultiply CUR_VEL 0.5
			// setvelocity ent_owner CUR_VEL
			orgVel = VelocityOf(ENT_OWNER);
			curVel = Text(orgVel);
			curVel = Text(Vec(curVel) * 0.75f);
			if (orgVel.z < 0.0f)
				curVel = Text(WithZ(Vec(curVel), orgVel.z));
			SetVelocity(ENT_OWNER, Vec(curVel));
		}
		else
		{
			float lastPush = Float(ScriptVarOf(ENT_OWNER, "PLR_LAST_PUSH"));
			lastPush += 3.0f;
			DebugPrint("do_iceman_loop " + Text(lastPush));
			if (GameTime() < lastPush)
			{
				orgVel = VelocityOf(ENT_OWNER);
				curVel = Text(orgVel);
				curVel = Text(Vec(curVel) * 0.25f);
				if (orgVel.z < 0.0f)
					curVel = Text(WithZ(Vec(curVel), orgVel.z));
				SetVelocity(ENT_OWNER, Vec(curVel));
			}
			else
			{
				GiveMana(ENT_OWNER, -(ICEMAN_MP ? 1.0f : 0.0f));
				AddVelocity(ENT_OWNER, RelativeVelocity(Vector3(0, ICEMAN_YAW, 0), Vector3(0, 1000, 0)));
			}
		}
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		if (!ICEMAN_ON)
			return;
		OnEndIceman();
	}

	// end_iceman
	void OnEndIceman()
	{
		// callexternal ent_owner ext_leg_lock 0 //no workie
		PlayOwnerAnim("break", "nod_yes", "global.anim.combatwalk", 3);
		CallExternal(ENT_OWNER, "ext_ice_staff_off");
		ICEMAN_ON = false;
		ClientEvent("update", "all", CL_ICEMAN_FX_INDEX, "end_fx");
		LegacyCommand("removeeffect", ENT_OWNER, "effect_nojump");
		if (!IsAlive(ENT_OWNER))
			return;
		SLOW_LOOP_ACTIVE = true;
		OnSlowDown();
		CallEventDelayed(1.0f, "end_slow_down");
	}

	// slow_down
	void OnSlowDown()
	{
		bool slowDown = false;
		if (ICEMAN_ON)
			return;
		if (!SLOW_LOOP_ACTIVE)
			return;
		CallEventDelayed(0.1f, "slow_down");

		float lastPush = Float(ScriptVarOf(ENT_OWNER, "PLR_LAST_PUSH"));
		lastPush += 3.0f;
		if (GameTime() < lastPush)
			slowDown = true;
		if (!IsOnGround(ENT_OWNER))
			slowDown = true;

		if (slowDown)
		{
			Vector3 orgVel = VelocityOf(ENT_OWNER);
			string curVel = Text(orgVel);
			curVel = Text(Vec(curVel) * 0.75f);
			if (orgVel.z < 0.0f)
				curVel = Text(WithZ(Vec(curVel), orgVel.z));
			SetVelocity(ENT_OWNER, Vec(curVel));
		}
	}

	// end_slow_down
	void OnEndSlowDown()
	{
		SLOW_LOOP_ACTIVE = false;
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (EntityOf(ENT_OWNER) !is deadPlayer)
			return;
		if (!ICEMAN_ON)
			return;
		OnEndIceman();
	}

	// attack2_bolt_start
	void OnAttack2BoltStart()
	{
		bool exitSub = false;

		DebugPrint("attack2_bolt_start");

		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);

		CBaseEntity@ ownerTarget = TargetOf(ENT_OWNER);
		if (IsAlive(ownerTarget) && RangeTo(ownerTarget) <= Float(MELEE_RANGE))
		{
			DebugPrint("attack_bolt_start " + EntityId(TargetOf(ENT_OWNER)) + " " + Text(RangeTo(ownerTarget)));
			MELEE_ATTACK = true;
			PlayItemViewAnim(ENT_ME, 2);
			exitSub = true;
		}
		if (exitSub)
			return;
		if (BITEM_UNDERSKILLED)
		{
			MELEE_ATTACK = true;
			PlayItemViewAnim(ENT_ME, 2);
			exitSub = true;
		}
		if (exitSub)
			return;
		MELEE_ATTACK = false;
		PlayItemViewAnim(ENT_ME, 9);
	}

	// attack2_bolt_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnAttack2BoltStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		float dot = 0.0f;

		if (!(OWNER_SKILL > Float(BASE_LEVEL_REQ)))
			return;

		if (!MELEE_ATTACK)
		{
			if (IsAlive(hitEntity) && RangeTo(hitEntity) < 150.0f)
				exitSub = true;
			if (!exitSub)
			{
				PlaySound(0, 10, "magic/ice_strike.wav");

				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
				CallExternal(ENT_OWNER, "ext_tossprojectile", "proj_staff_ice_bolt2", "view", "none", 400, 0, 0, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
			}
		}
		else if (IsAlive(hitEntity))
		{
			@MELEE_TARG = hitEntity;
			if (IsPlayer(MELEE_TARG) && GAME_PVP == 0)
				exitSub = true;
			if (!exitSub && RelationshipOf(MELEE_TARG, ENT_OWNER) == "enemy")
			{
				if (MELEE_TARG is OLD_MELEE_TARG)
					CONSEC_ATTACKS += 1.0f;
				else
					CONSEC_ATTACKS = 0.0f;
				@OLD_MELEE_TARG = MELEE_TARG;
				if (CONSEC_ATTACKS == 5.0f)
				{
					if (Truthy(ScriptVarOf(hitEntity, "I_R_FROZEN")))
					{
						CONSEC_ATTACKS = 0.0f;
						dot = OWNER_SKILL * DOT_RATIO;
						ApplyEffect(hitEntity, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
						exitSub = true;
					}
					if (!exitSub)
					{
						float maxHp = MaxHealthOf(ENT_OWNER) * 3.0f;
						if (maxHp < 2000.0f)
							maxHp = 2000.0f;
						if (HealthOf(hitEntity) < maxHp && ManaOf(ENT_OWNER) > 30.0f)
						{
							GiveMana(ENT_OWNER, -30);
							ApplyEffect(hitEntity, "effects/dot_cold_freeze", 5.0f, @EntityOf(ENT_OWNER), 0, "spellcasting.ice", maxHp);
							CONSEC_ATTACKS = 0.0f;
						}
					}
				}
				else
				{
					dot = OWNER_SKILL * DOT_RATIO;
					ApplyEffect(hitEntity, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
					if (Truthy(ScriptVarOf(hitEntity, "I_R_FROZEN")))
						CONSEC_ATTACKS = 0.0f;
				}

				DebugPrint("attack_bolt_strike " + Text(CONSEC_ATTACKS));
			}
		}
		MELEE_ATTACK = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack2_bolt_start") { OnAttack2BoltStart(); return true; }
		if (name == "attack2_bolt_strike") { OnAttack2BoltStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "attack_bolt_start") { OnAttackBoltStart(); return true; }
		if (name == "attack_bolt_strike") { OnAttackBoltStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "attack_lance_start") { OnAttackLanceStart(); return true; }
		if (name == "attack_lance_strike") { OnAttackLanceStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "do_iceman_loop") { OnDoIcemanLoop(); return true; }
		if (name == "end_iceman") { OnEndIceman(); return true; }
		if (name == "end_slow_down") { OnEndSlowDown(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "slow_down") { OnSlowDown(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
