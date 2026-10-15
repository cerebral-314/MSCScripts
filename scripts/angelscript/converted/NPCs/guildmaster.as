#pragma context server

// Converted from NPCs/guildmaster.script by msc_transpiler.
// Crest Master by Thothie, for giving people crests on

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/guildmaster"]
class Guildmaster : BaseNpcScript
{
	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;
	bool PROXY_SPOKE = false;
	CBaseEntity@ NERF_PLR = null;
	string SKILL_TOKENS = "SKILL_TOKENS";
	string PROP_TOKENS = "PROP_TOKENS";
	string CUR_SKILL = "CUR_SKILL";

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetGold(0);
		SetName("Fenrin, the Crest Keeper");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		CANCHAT = 1;
		SetSayTextRange(1024);

		CatchSpeech("say_hi", "hello", "hail", "greet");
		CatchSpeech("cheater_guessing", "edana", "blades", "urdual", "fmu", "torkalath", "darktide", "bou", "pirates", "crest", "guild", "thoth");
		CatchSpeech("give_orochi", "krizarid");

		PROXY_SPOKE = false;

		CallEventDelayed(0.1f, "check_central");
	}

	// check_central
	void OnCheckCentral()
	{
		if (Eval("game.central") != "0")
			return;
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		InfoMessage("all", "FENRIN_FN_ONLY", "You must be connected to [FN] to use the Guild Master");
		DeleteEntity(ENT_ME);
	}

	// 1
	void On_1()
	{
		if (PROXY_SPOKE)
			return;
		if (Float(LegacyFunction("cansee", "player", 512)) == 1.0f)
			OnSayHi();
		PROXY_SPOKE = true;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SetVolume(10);
		SayText("Greetings, I am Fenrin, the Master of Guilds.");
		PlayAnim("once", "talkleft");
		CallEventDelayed(0.0f, "5");
	}

	// say_hi2
	void OnSayHi2()
	{
		if (Contains(NameOf(ENT_LASTSPOKE), "dridje") && Truthy(Eval("game.central")))
		{
			OnHiDridge();
			return;
		}

		SetVolume(10);
		SayText("Or I was, now I just kinda sit here looking over this gaudy map fragment.");
		CallEventDelayed(5.0f, "say_hi3");
	}

	// say_hi3
	void OnSayHi3()
	{
		PlayAnim("once", "retina");
		SayText("By the gods, this is gaudy. Who built this monstrosity anyways?");
		CallEventDelayed(5.0f, "say_hi4");
	}

	// say_hi4
	void OnSayHi4()
	{
		SayText("Oh, if you're here for a crest, that system is changed. You should hit up the forums and send Thothie a PM.");
		CallEventDelayed(5.0f, "say_hi5");
	}

	// say_hi5
	void OnSayHi5()
	{
		PlayAnim("once", "nod");
		SayText("The forums being at www.msremake.com, of course.");
	}

	// hi_dridge
	void OnHiDridge()
	{
		PlayAnim("once", "nod");
		SayText("Oh hi there Dridje...");
		CallEventDelayed(3.0f, "hi_dridge2");
	}

	// hi_dridge2
	void OnHiDridge2()
	{
		PlayAnim("once", "retina");
		@NERF_PLR = EntityOf(ENT_LASTSPOKE);
		SayText("Enjoy your rollback.");

		SKILL_TOKENS = "archery;bluntarms;axehandling;swordsmanship;polearms;smallarms;spellcasting";
		PROP_TOKENS = "proficiency;power;balance";

		int count = GetTokenCount(SKILL_TOKENS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoNerf();
		}
	}

	// do_nerf
	void OnDoNerf()
	{
		int curIdx = loopIteration;
		CUR_SKILL = GetToken(SKILL_TOKENS, curIdx);
		int count = GetTokenCount(PROP_TOKENS);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoNerfProps();
		}
		loopIteration = outerIteration;
	}

	// do_nerf_props
	void OnDoNerfProps()
	{
		string curSkillName = CUR_SKILL + "." + GetToken(PROP_TOKENS, loopIteration);
		string grabSkill = "skill." + curSkillName;
		float skillLevel = Float(GetProp(NERF_PLR, grabSkill));
		skillLevel *= 0.5f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "1") { On_1(); return true; }
		if (name == "check_central") { OnCheckCentral(); return true; }
		if (name == "do_nerf") { OnDoNerf(); return true; }
		if (name == "do_nerf_props") { OnDoNerfProps(); return true; }
		if (name == "hi_dridge") { OnHiDridge(); return true; }
		if (name == "hi_dridge2") { OnHiDridge2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_hi4") { OnSayHi4(); return true; }
		if (name == "say_hi5") { OnSayHi5(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
