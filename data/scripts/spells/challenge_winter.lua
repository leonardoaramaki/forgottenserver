-- The delay between each area pattern
local animationDelay = 200
local combat = {}

local area = {
    {
        {0, 1, 0},
        {1, 2, 1},
        {0, 1, 0}
    },
    {
        {1, 0, 1},
        {0, 2, 0},
        {1, 0, 1}
    },
    {
        {0, 1, 1, 1, 0},
        {1, 0, 0, 0, 1},
        {1, 0, 2, 0, 1},
        {1, 0, 0, 0, 1},
        {0, 1, 1, 1, 0}
    }
}

for i = 1, #area do
    combat[i] = Combat()
    combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
end

for x, _ in ipairs(area) do
    combat[x]:setArea(createCombatArea(area[x]))
end

function executeCombat(p, i)
    if not p.player or not p.player:isPlayer() then
        return false
    end
    p.combat[i]:execute(p.player, p.variant)
end

local spell = Spell(SPELL_INSTANT)

--[[ Called this spell is pronounced. ]]--
function spell.onCastSpell(player, variant)
	-- Table containing data used to execute the spell using the other declared areas.
	-- This approach is what makes the spell area pattern animation.
    local p = {player = player, variant = variant, combat = combat}

    local level = player:getLevel()
    local maglevel = player:getMagicLevel()
    local min = (level / 5) + (maglevel * 1.4) + 8
    local max = (level / 5) + (maglevel * 2.2) + 14

	-- Loop through the areas to execute the spell on the given areas.
	-- First area runs and the others will run after animationDelay between each of them.
    for i = 1, #area do
        combat[i]:setFormula(COMBAT_FORMULA_LEVELMAGIC, 0, -min, 0, -max)
        if i == 1 then
            combat[i]:execute(player, variant)
        else
            addEvent(executeCombat, (animationDelay * i) - animationDelay, p, i)
        end
    end

    return true
end

-- "frigo" is what needs to be uttered by the player to trigger this spell
spell:name("Challenge Winter")
spell:words("frigo")
spell:id(100)
spell:group("attack")
spell:cooldown(200)
spell:groupCooldown(200)
spell:isAggressive(true)
spell:needTarget(false)
spell:level(1)
spell:needLearn(false)
spell:vocation("sorcerer")
spell:register()
