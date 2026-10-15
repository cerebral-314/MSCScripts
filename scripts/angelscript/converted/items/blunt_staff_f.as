#pragma context server

// Converted from items/blunt_staff_f.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/base_weapon_new.as"

[script "items/blunt_staff_f"]
class BluntStaffF : BaseWeaponNewScript, BaseElementalResist
{
	// Constants
	int MP_VOLCANO = 100;
	int MP_METEOR = 75;
	int MP_BURST = 30;
	int STAFF_RADIUS1 = 96;
	int STAFF_RADIUS2 = 256;
	string ELM_NAME = "phlame";
	string ELM_TYPE = "cold";
	float ELM_AMT = 20.0f;
	bool ELM_WEAPON = true;
	int PMODEL_IDX_HAND_RIGHT = 29;
	int PMODEL_IDX_HAND_LEFT = 29;
	int VANIM_MELEE = 22;
	int VANIM_SPELL1 = 23;
	int VANIM_SPELL2 = 24;
	int VANIM_BURST = 25;
	string SOUND_MELEE = "weapons/cbar_miss1.wav";
	float DOT_RATIO = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	bool MELEE_ATTACK = false;
	string SPELL_POS = "SPELL_POS";
	Vector3 BURN_TARG_ORG = Vector3();
	bool VOLCANO_ON = false;
	float NEXT_BURST_ATTEMPT = 0.0f;
	float NEXT_BURST = 0.0f;
	bool IN_BURST_ATTACK = false;
	Vector3 BURST_ORG = Vector3();
	bool BURST_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	BluntStaffF()
	{
		BASE_LEVEL_REQ = "30";
		BWEAPON_NAME = "Phlame's Staff";
		BWEAPON_DESC = "A demonic staff of fire";
		BWEAPON_WEIGHT = 60;
		BWEAPON_VALUE = 7000;
		BWEAPON_INV_SPRITE_IDX = 52;
		BWEAPON_HANDS = "both";
		VMODEL_FILE = "viewmodels/v_polearms.mdl";
		VMODEL_IDX = 13;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 28;
		PMODEL_IDX_HANDS = 29;
		PANIM_IDLE = "aim_blunt";
		PANIM_EXT = "blunt";
		VANIM_IDLE = 21;
		VANIM_DRAW = 21;
		WANIM_FLOOR = "standard_floor_idle";
		WANIM_HAND = "standard_idle";
		ATK1_RANGE = 110;
		ATK1_DMG = 200;
		ATK1_DMG_RANGE = 20;
		ATK1_DMG_TYPE = "fire";
		ATK1_STAMINA = 0.0f;
		ATK1_SKILL = "spellcasting.fire";
		ATK1_ACCURACY = "80%";
		ATK1_DURATION = 1.0f;
		ATK1_CALLBACK = "spell1";
		ATK1_PANIM = "swing_blunt";
		ATK1_VANIM = 0;
		ATK2_VANIM = 0;
		ATK2_PANIM = "sword_double_swing";
		ATK2_CALLBACK = "spell2";
	}

	// game_dodamage
	// checking to see if xdodamage reports to weapon (yes it does!)
	string BluntStaffF_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		// dbg game_dodamage PARAM1 $get(PARAM2,name)
		if (hit)
		{
			if (GAME_PVP == 0 && IsPlayer(target))
				exitSub = true;
			if (!exitSub && RelationshipOf(target, ENT_OWNER) == "enemy")
			{
				float dotFire = SkillOf(ENT_OWNER, "spellcasting.fire") * DOT_RATIO;
				ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotFire, "spellcasting.fire");

				if (BURST_ATTACK)
				{
					float maxHp = Clamp(MaxHealthOf(ENT_OWNER) * 3.0f, 2000.0f, 10000.0f);
					if (HealthOf(target) < maxHp)
					{
						CBaseEntity@ curTarg = target;
						Vector3 targOrg = OriginOf(curTarg);
						Vector3 myOrg = OriginOf(ENT_OWNER);
						float newYaw = AnglesTo(myOrg, targOrg);
						AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
					}
				}
			}
		}
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseWeaponNew_OnGameDeploy(); // items/base_weapon_new

		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (BITEM_UNDERSKILLED)
			return;
		OnViewfinderLoop();
		CallEventDelayed(0.1f, "elm_activate_effect");
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		ClientEvent("update", ENT_OWNER, Eval("const.localplayer.scriptID"), "phlames_viewfinder_off");
	}

	// bitem_register_attacks
	void OnBitemRegisterAttacks()
	{
		BaseWeaponNew_OnBitemRegisterAttacks(); // items/base_weapon_new

		// yet to be tested:
		// reg.attack.aoe.range
		// reg.attack.aoe.falloff
		// reg.attack.dmg.ignore //no damage?
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.type", ATK2_TYPE);
		SetLocal("reg.attack.keys", ATK2_KEYS);
		SetLocal("reg.attack.range", ATK2_RANGE);
		SetLocal("reg.attack.dmg", ATK2_DMG);
		SetLocal("reg.attack.dmg.range", ATK2_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", ATK2_DMG_TYPE);
		SetLocal("reg.attack.energydrain", ATK2_STAMINA);
		SetLocal("reg.attack.stat", ATK2_SKILL);
		SetLocal("reg.attack.hitchance", ATK2_ACCURACY);
		SetLocal("reg.attack.delay.strike", ATK2_DELAY_STRIKE);
		SetLocal("reg.attack.delay.end", ATK2_DURATION);
		SetLocal("reg.attack.ofs.startpos", ATK2_OFS);
		SetLocal("reg.attack.ofs.aimang", ATK2_ANG);
		SetLocal("reg.attack.callback", "volcano");
		SetLocal("reg.attack.noise", ATK2_NOISE);
		SetLocal("reg.attack.mpdrain", ATK2_MPDRAIN);
		SetLocal("reg.attack.dmg.multi", ATK2_DMG_MULTI);
		SetLocal("reg.attack.noautoaim", ATK2_NO_AUTOAIM);
		SetLocal("reg.attack.reqskill", ATK2_SKILL_LEVEL);
		LegacyCommand("add", "reg.attack.reqskill", ATK2_ADD_SKILL_REQ);

		if (ATK2_IS_PROJECTILE)
		{
			SetLocal("reg.attack.ammodrain", ATK2_AMMODRAIN);
			SetLocal("reg.attack.projectile", ATK2_PROJECTILE);
			SetLocal("reg.attack.COF", ATK2_COF);
		}

		RegisterAttack();
	}

	// viewfinder_loop
	void OnViewfinderLoop()
	{
		bool bewIsWeilded = false;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			bewIsWeilded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			bewIsWeilded = true;
		// if ( !$get(ent_owner,isalive) ) local BEW_IS_WEILDED 0
		if (bewIsWeilded)
		{
			ClientEvent("update", ENT_OWNER, Eval("const.localplayer.scriptID"), "phlames_viewfinder_on", IndexOf(ENT_OWNER));
			CallEventDelayed(5.0f, "cl_refresh_loop");
		}
		else
		{
			ClientEvent("update", ENT_OWNER, Eval("const.localplayer.scriptID"), "phlames_viewfinder_off");
		}
	}

	// spell1_start
	void OnSpell1Start()
	{
		bool doMelee = false;

		// if ( game.clientside ) dbg spell1_start
		PlayOwnerAnim("critical", ATK1_PANIM, "global.anim.combatwalk", 3);

		CBaseEntity@ ownerTarg = TargetOf(ENT_OWNER);
		if (!IsAlive(ownerTarg))
			doMelee = false;
		else if (RangeTo(ownerTarg) < ATK1_RANGE)
			doMelee = true;
		if (BITEM_UNDERSKILLED)
			doMelee = true;

		if (!doMelee)
		{
			SetAttackProp(ENT_ME, 0, "range", 0);
			MELEE_ATTACK = false;
			PlayItemViewAnim(ENT_ME, VANIM_SPELL1);
		}
		else
		{
			SetAttackProp(ENT_ME, 0, "range", ATK1_RANGE);
			MELEE_ATTACK = true;
			PlaySound(1, 10, SOUND_MELEE);
			PlayItemViewAnim(ENT_ME, VANIM_MELEE);
		}
	}

	// get_spell_pos
	void OnGetSpellPos()
	{
		Vector3 ownerView = ViewAnglesOf(ENT_OWNER);
		Vector3 sealPos = OriginOf(ENT_OWNER);

		string traceStart = Text(sealPos);
		string traceEnd = Text(sealPos);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(ownerView, Vector3(0, 1000, 0)));
		SetLocal("reg.trace.ignorenet", @EntityOf(ENT_OWNER));
		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		Vector3 traceLine = Vec(LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly"));
		traceLine.z = GroundHeight(traceLine);
		Vector3 ownerOrg = OriginOf(ENT_OWNER);
		if (Distance(sealPos, ownerOrg) < 1024.0f)
		{
			SPELL_POS = Text(traceLine);
		}
		else
		{
			SPELL_POS = "outofrange";
			PlaySound(1, 10, "magic/energy1.wav");
			PlayerMessageDark(ENT_OWNER, "Out of range.");
		}
	}

	// spell1_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpell1Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		float dotFire = 0.0f;
		bool exitSub = false;
		if (!MELEE_ATTACK)
		{
			OnGetSpellPos();
			if (SPELL_POS != "outofrange")
			{
				ClientEvent("new", "all", "effects/sfx_fire_staff", SPELL_POS);
				BURN_TARG_ORG = Vec(SPELL_POS);
				BURN_TARG_ORG.z += 32.0f;
				dotFire = SkillOf(ENT_OWNER, "spellcasting.fire");
				DoDamageEx(BURN_TARG_ORG, STAFF_RADIUS1, dotFire, 0.01f, ENT_OWNER, ENT_ME, "spellcasting.fire", "fire_effect");
			}
		}
		else
		{
			// callevent 0.25 burn_targets //slight delay to avoid tsphere/xdodamage overlap
			if (IsAlive(hitEntity))
			{
				if (IsPlayer(hitEntity) && GAME_PVP == 0)
					exitSub = true;
				if (!exitSub && RelationshipOf(hitEntity, ENT_OWNER) == "enemy")
					dotFire = SkillOf(ENT_OWNER, "spellcasting.fire");
			}
		}
		// multiply DOT_FIRE DOT_RATIO
		// applyeffect PARAM3 effects/dot_fire 5.0 $get(ent_owner,id) DOT_FIRE
		MELEE_ATTACK = false;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntStaffF_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// spell2_start
	// { burn_targets
	// callexternal ent_owner ext_fire_staff1 STAFF_RADIUS1 BURN_TARG_ORG
	// }
	void OnSpell2Start()
	{
		// if ( game.clientside ) dbg spell2_start
		PlayOwnerAnim("critical", ATK1_PANIM, "global.anim.combatwalk", 3);
		PlayItemViewAnim(ENT_ME, VANIM_SPELL2);
	}

	// spell2_strike
	void OnSpell2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		// check see if sky available
		// check MP
		// drop meteor if is
		if (ManaOf(ENT_OWNER) < MP_METEOR)
		{
			PlayerMessageDark(ENT_OWNER, "Insufficient mana for Meteor.");
			PlaySound(1, 10, "magic/energy1.wav");
			exitSub = true;
		}
		if (exitSub)
			return;

		OnGetSpellPos();
		if (SPELL_POS == "outofrange")
			return;

		if (!Truthy(LegacyFunction("get_under_sky", SPELL_POS)))
		{
			PlayerMessageDark(ENT_OWNER, "Can only summon Meteor under sky.");
			PlaySound(1, 10, "magic/energy1.wav");
			exitSub = true;
		}
		if (exitSub)
			return;

		string traceStart = SPELL_POS;
		Vector3 traceEnd = Vec(SPELL_POS);
		traceEnd.z += 768.0f;
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		string meteorSpawn = Text(Vec(traceLine) + Vector3(0.0f, 0.0f, -64.0f));

		GiveMana(ENT_OWNER, -MP_METEOR);

		CreateNpc("monsters/summon/meteor_deployer", Vec(meteorSpawn), @EntityOf(ENT_OWNER), self);
	}

	// volcano_start
	void OnVolcanoStart()
	{
		PlayOwnerAnim("critical", ATK1_PANIM, "global.anim.combatwalk", 3);
		PlayItemViewAnim(ENT_ME, VANIM_SPELL2);
	}

	// volcano_strike
	void OnVolcanoStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		// check see if volcanos present
		// check MP
		// spawn volcano
		OnGetSpellPos();
		if (SPELL_POS == "outofrange")
			return;
		if (VOLCANO_ON)
		{
			PlayerMessageDark(ENT_OWNER, "Phlame's Staff can only sustain one volcano at a time.");
			exitSub = true;
		}
		if (exitSub)
			return;
		if (ManaOf(ENT_OWNER) < MP_VOLCANO)
		{
			PlayerMessageDark(ENT_OWNER, "Insufficient mana for Volcano.");
			PlaySound(1, 10, "magic/energy1.wav");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -MP_VOLCANO);

		VOLCANO_ON = true;
		CreateNpc("monsters/summon/preset_volcano", Vec(SPELL_POS), @EntityOf(ENT_OWNER), 0, 20, "spellcasting.fire");
		CallEventDelayed(20.0f, "volcano_reset");
	}

	// volcano_reset
	void OnVolcanoReset()
	{
		VOLCANO_ON = false;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;
		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_BURST_ATTEMPT))
			return;
		NEXT_BURST_ATTEMPT = GameTime() + 1.0f;

		if (ManaOf(ENT_OWNER) < MP_BURST)
		{
			PlayerMessageDark(ENT_OWNER, "Insufficient mana for flame burst.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!(GameTime() > NEXT_BURST))
			return;
		NEXT_BURST = GameTime() + 5.0f;

		IN_BURST_ATTACK = true;

		PlayItemViewAnim(ENT_ME, VANIM_BURST);
		GiveMana(ENT_OWNER, -MP_BURST);
		CallEventDelayed(1.0f, "do_burst_attack");
	}

	// do_burst_attack
	void OnDoBurstAttack()
	{
		BURST_ORG = OriginOf(ENT_OWNER);
		BURST_ORG.z = GroundHeight(BURST_ORG);

		ClientEvent("new", "all", "effects/sfx_flame_repulse", BURST_ORG);
		BURST_ATTACK = true;
		CallEventDelayed(0.1f, "end_burst_attack");
		BURST_ORG.z += 32.0f;
		float dotFire = SkillOf(ENT_OWNER, "spellcasting.fire") * 1.5f;
		DoDamageEx(BURST_ORG, STAFF_RADIUS2, dotFire, 0.01f, ENT_OWNER, ENT_ME, "spellcasting.fire", "fire_effect");
	}

	// end_burst_attack
	void OnEndBurstAttack()
	{
		BURST_ATTACK = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
	}

	// game_drop
	void OnGameDrop()
	{
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseWeaponNew_OnGameDrop(); // items/base_weapon_new
	}

	// game_remove
	void OnGameRemove()
	{
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
	}

	// game_fall
	void OnGameFall()
	{
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeaponNew_OnGameFall(); // items/base_weapon_new
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_polearms.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseElementalResist_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bitem_register_attacks") { OnBitemRegisterAttacks(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "do_burst_attack") { OnDoBurstAttack(); return true; }
		if (name == "end_burst_attack") { OnEndBurstAttack(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "get_spell_pos") { OnGetSpellPos(); return true; }
		if (name == "spell1_start") { OnSpell1Start(); return true; }
		if (name == "spell1_strike") { OnSpell1Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "spell2_start") { OnSpell2Start(); return true; }
		if (name == "spell2_strike") { OnSpell2Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "viewfinder_loop") { OnViewfinderLoop(); return true; }
		if (name == "volcano_reset") { OnVolcanoReset(); return true; }
		if (name == "volcano_start") { OnVolcanoStart(); return true; }
		if (name == "volcano_strike") { OnVolcanoStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| BaseWeaponNewScript::DispatchEvent(name, params);
	}
}
