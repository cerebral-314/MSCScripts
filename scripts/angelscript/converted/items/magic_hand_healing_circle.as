#pragma context server

// Converted from items/magic_hand_healing_circle.script by msc_transpiler.
// Healing Circle by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_healing_circle"]
class MagicHandHealingCircle : MagicHandBaseScript
{
	// Constants
	bool NO_REGISTER = true;
	int MANA_COST = 150;
	float MELEE_ATK_DURATION = 4.0f;
	string SPELL_SCRIPT = "monsters/summon/circle_of_healing";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 18;
	float LAST_ATTACK = 0.0f;
	bool SET_DELETE = false;
	Vector3 OWNER_LOC = Vector3();
	string NEAR_SEAL = "NEAR_SEAL";

	// Variables declared by included files, with the value they start with in this script
	MagicHandHealingCircle()
	{
		SPELL_PREPARE_TIME = 1.0f;
		SPELL_ENERGYDRAIN = 50;
	}

	// unnamed block (first think)
	void MagicHandHealingCircle_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 18;
		PrecacheFile(SPELL_SCRIPT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Healing Circle");
		SetDescription("A large magic circle that heals all allies within");
	}

	// game_attack1
	void OnGameAttack1()
	{
		float timeDiff = GameTime() - LAST_ATTACK;
		if (!(timeDiff > MELEE_ATK_DURATION))
			return;

		LAST_ATTACK = GameTime();

		PlayItemViewAnim(ENT_ME, Int(ANIM_CAST));
		PlayOwnerAnim("critical", PLAYERANIM_PREPARE, "squatwalk1");
		PlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_CHARGE);

		if (ManaOf(ENT_OWNER) < MANA_COST)
			PlayerMessageDark(ENT_OWNER, "Insufficient mana.");
		if (!(ManaOf(ENT_OWNER) >= MANA_COST))
			return;

		// delay for effect
		CallEventDelayed(0.5f, "make_circle");
	}

	// make_circle
	void OnMakeCircle()
	{
		SET_DELETE = false;
		OWNER_LOC = OriginOf(ENT_OWNER);
		NEAR_SEAL = LegacyFunction("get_tsphere", "any", 230, OWNER_LOC);
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			PlayerMessageGreen(ENT_OWNER, "make_circle: " + GetTokenCount(NEAR_SEAL));
		int count = GetTokenCount(NEAR_SEAL);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckIfNear();
		}
		CallEventDelayed(0.1f, "make_circle2");
	}

	// check_if_near
	void OnCheckIfNear()
	{
		CBaseEntity@ curEnt = FindEntity(GetToken(NEAR_SEAL, loopIteration));
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			ConsoleMessage(ENT_OWNER, "make_circle->check_if_near: found " + NameOf(curEnt));
		if (!Truthy(ScriptFlag(curEnt, "hc", "name_exists")))
			return;
		if (SET_DELETE)
			return;
		SET_DELETE = true;
		PlayerMessageDark(ENT_OWNER, "Healing Circle: Cannot create one healing circle within another.");
	}

	// make_circle2
	void OnMakeCircle2()
	{
		if (SET_DELETE)
			return;

		ServerPlaySound(0, 10, SOUND_SHOOT);

		GiveMana(-MANA_COST);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		float healPower = Divide(SkillOf(ENT_OWNER, "spellcasting.divination"), 2.0f);
		OWNER_LOC.z = GroundHeight(OWNER_LOC);
		CreateNpc(SPELL_SCRIPT, OWNER_LOC, @EntityOf(ENT_OWNER), StatOf(ENT_OWNER, "concentration"), healPower);
		DeleteEntity(ENT_ME);
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_CHARGE);
		ServerPlaySound(0, 0, SOUND_SHOOT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/cast.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandHealingCircle_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_if_near") { OnCheckIfNear(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "make_circle") { OnMakeCircle(); return true; }
		if (name == "make_circle2") { OnMakeCircle2(); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
