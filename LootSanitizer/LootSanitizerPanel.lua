local LootSanitizer = LootSanitizer
local LAM = LibAddonMenu2

function LootSanitizer:addSettingsMenu ()
  local panelName = "LootSanitizerSettings"

  -- Заголовок
  LootSanitizer.settingsPanel = LAM:RegisterAddonPanel(panelName, {
    type = "panel",
    name = LootSanitizer.name,
    version = LootSanitizer.version,
    author = LootSanitizer.author,
    slashCommand = "/lss",
  })

  local optionsData = {
    {
      type = "description",
      text = GetString(SI_LOOTSANITIZER_WARNING),
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_ITEM_CONTROL),
      choices = {
        GetString(SI_LOOTSANITIZER_ITEM_CONTROL_NO),
        GetString(SI_LOOTSANITIZER_ITEM_CONTROL_AUTOLOOT),
        GetString(SI_LOOTSANITIZER_ITEM_CONTROL_ALWAYS)
      },
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.workMode,
      getFunc = function() return LootSanitizer.settings.workMode end,
      setFunc = function(value) LootSanitizer.settings.workMode = value end,
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_CHAT_NOTIFY),
      choices = {
        GetString(SI_LOOTSANITIZER_CHAT_NOTIFY_NO),
        GetString(SI_LOOTSANITIZER_CHAT_NOTIFY_DELETE),
        GetString(SI_LOOTSANITIZER_CHAT_NOTIFY_DEV)
      },
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.chatMode,
      getFunc = function() return LootSanitizer.settings.chatMode end,
      setFunc = function(value) LootSanitizer.settings.chatMode = value end,
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_armor_up.dds|t " .. GetString(SI_LOOTSANITIZER_EQUIPMENT_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_EQUIPMENT_CONTROL),
      default = LootSanitizer.defaults.burnEquipment,
      getFunc = function() return LootSanitizer.settings.burnEquipment end,
      setFunc = function(value) LootSanitizer.settings.burnEquipment = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_EQUIPMENT_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    -- SETS ITEMS
    {
      type = "header",
      name = "|t36:36:EsoUI/Art/Collections/collections_tabIcon_itemSets_up.dds|t " .. GetString(SI_LOOTSANITIZER_SETS_HEADER),
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_SETS_CONTROL),
      choices = {
        GetString(SI_LOOTSANITIZER_SETS_CONTROL_NO),
        GetString(SI_LOOTSANITIZER_SETS_CONTROL_GREEN),
        GetString(SI_LOOTSANITIZER_SETS_CONTROL_BLUE),
        GetString(SI_LOOTSANITIZER_SETS_CONTROL_PURPLE)
      },
      choicesValues = {0, 2, 3, 4},
      default = LootSanitizer.defaults.autoBindQuality,
      getFunc = function() return LootSanitizer.settings.autoBindQuality end,
      setFunc = function(value) LootSanitizer.settings.autoBindQuality = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_SETS_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    -- COMPANION ITEMS
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_companion_up.dds:inheritcolor|t " .. GetString(SI_LOOTSANITIZER_COMPANION_HEADER),
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_COMPANION_CONTROL),
      choices = {
        GetString(SI_LOOTSANITIZER_COMPANION_CONTROL_NO),
        GetString(SI_LOOTSANITIZER_COMPANION_CONTROL_WHITE),
        GetString(SI_LOOTSANITIZER_COMPANION_CONTROL_GREEN),
        GetString(SI_LOOTSANITIZER_COMPANION_CONTROL_BLUE)
      },
      choicesValues = {0, 1, 2, 3},
      default = LootSanitizer.defaults.burnCompanionItems,
      getFunc = function() return LootSanitizer.settings.burnCompanionItems end,
      setFunc = function(value) LootSanitizer.settings.burnCompanionItems = value end,
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_styleMaterial_up.dds:inheritcolor|t " .. GetString(SI_LOOTSANITIZER_MATERIALMOTIF_HEADER),
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_MATERIAL_CONTROL),
      choices = {
        GetString(SI_LOOTSANITIZER_MATERIAL_CONTROL_NO),
        GetString(SI_LOOTSANITIZER_MATERIAL_CONTROL_COMMON),
        GetString(SI_LOOTSANITIZER_MATERIAL_CONTROL_RARE)
      },
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.burnRaceMaterial,
      getFunc = function() return LootSanitizer.settings.burnRaceMaterial end,
      setFunc = function(value) LootSanitizer.settings.burnRaceMaterial = value end,
    },
    {
      type = "dropdown",
      name = GetString(SI_LOOTSANITIZER_MOTIF_CONTROL),
      choices = {
        GetString(SI_LOOTSANITIZER_MOTIF_CONTROL_NO),
        GetString(SI_LOOTSANITIZER_MOTIF_CONTROL_COMMON),
        GetString(SI_LOOTSANITIZER_MOTIF_CONTROL_RARE)
      },
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.burnRaceMotif,
      getFunc = function() return LootSanitizer.settings.burnRaceMotif end,
      setFunc = function(value) LootSanitizer.settings.burnRaceMotif = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_MOTIFLEARN_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_MOTIFLEARN_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.autoLearnRaceMotif,
      getFunc = function() return LootSanitizer.settings.autoLearnRaceMotif end,
      setFunc = function(value) LootSanitizer.settings.autoLearnRaceMotif = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_MATERIALMOTIF_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_itemTrait_up.dds|t " .. GetString(SI_LOOTSANITIZER_TRAIT_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_TRAIT_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_TRAIT_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.burnTraitMaterial,
      getFunc = function() return LootSanitizer.settings.burnTraitMaterial end,
      setFunc = function(value) LootSanitizer.settings.burnTraitMaterial = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_TRAIT_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_provisioning_up.dds|t " .. GetString(SI_LOOTSANITIZER_INGREDIENT_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_INGREDIENT_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_INGREDIENT_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.burnIngredient,
      getFunc = function() return LootSanitizer.settings.burnIngredient end,
      setFunc = function(value) LootSanitizer.settings.burnIngredient = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_INGREDIENT_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_tool_up.dds|t " .. GetString(SI_LOOTSANITIZER_LOCKPICK_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_LOCKPICK_CONTROL),
      default = LootSanitizer.defaults.burnLockpick,
      getFunc = function() return LootSanitizer.settings.burnLockpick end,
      setFunc = function(value) LootSanitizer.settings.burnLockpick = value end,
    },
    {
      type = "slider",
      name = GetString(SI_LOOTSANITIZER_LOCKPICK_SLIDER),
      tooltip = GetString(SI_LOOTSANITIZER_LOCKPICK_SLIDER_TOOLTIP),
      min = 0,
      max = 20,
      default = LootSanitizer.defaults.burnLockpickStackSaved,
      getFunc = function() return LootSanitizer.settings.burnLockpickStackSaved end,
      setFunc = function(value) LootSanitizer.settings.burnLockpickStackSaved = value end,
      disabled = function() return LootSanitizer.settings.burnLockpick == false end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_LOCKPICK_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_bait_up.dds|t " .. GetString(SI_LOOTSANITIZER_BAIT_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_BAIT_CONTROL),
      default = LootSanitizer.defaults.burnBait,
      getFunc = function() return LootSanitizer.settings.burnBait end,
      setFunc = function(value) LootSanitizer.settings.burnBait = value end,
    },
    {
      type = "slider",
      name = GetString(SI_LOOTSANITIZER_BAIT_SLIDER),
      tooltip = GetString(SI_LOOTSANITIZER_BAIT_SLIDER_TOOLTIP),
      min = 0,
      max = 20,
      default = LootSanitizer.defaults.burnBaitStackSaved,
      getFunc = function() return LootSanitizer.settings.burnBaitStackSaved end,
      setFunc = function(value) LootSanitizer.settings.burnBaitStackSaved = value end,
      disabled = function() return LootSanitizer.settings.burnBait == false end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_BAIT_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/TradingHouse/Tradinghouse_Glyphs_Trio_up.dds|t " .. GetString(SI_LOOTSANITIZER_GLYPH_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_GLYPH_CONTROL),
      default = LootSanitizer.defaults.burnCommonGlyph,
      getFunc = function() return LootSanitizer.settings.burnCommonGlyph end,
      setFunc = function(value) LootSanitizer.settings.burnCommonGlyph = value end,
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_GLYPH_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabicon_craftbag_enchanting_up.dds|t " .. GetString(SI_LOOTSANITIZER_RUNE_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_RUNE_POTENCY_CONTROL),
      default = LootSanitizer.defaults.burnRunePotency,
      getFunc = function() return LootSanitizer.settings.burnRunePotency end,
      setFunc = function(value) LootSanitizer.settings.burnRunePotency = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_RUNE_ESSENCE_CONTROL),
      default = LootSanitizer.defaults.burnRuneEssence,
      getFunc = function() return LootSanitizer.settings.burnRuneEssence end,
      setFunc = function(value) LootSanitizer.settings.burnRuneEssence = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_RUNE_DAILY_CONTROL),
      default = LootSanitizer.defaults.saveRuneEssenceForDaily,
      getFunc = function() return LootSanitizer.settings.saveRuneEssenceForDaily end,
      setFunc = function(value) LootSanitizer.settings.saveRuneEssenceForDaily = value end,
      disabled = function() return not LootSanitizer.settings.burnRuneEssence end,
    },
    {
      type = "description",
      -- text = "|cc5c29eУдаляются все квадратные руны силы ниже 10 уровня. Треугольные руны сущности |H0:item:68342:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h, |H0:item:166045:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:45838:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h удаляться не будут. Для ежедневных ремесленных заданий будут сохраняться руны сущности |H0:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h, |H0:item:45832:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:45833:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h.|r",
      text = "|cc5c29e" .. zo_strformat(GetString(SI_LOOTSANITIZER_RUNE_DESCRIPTION), "|H0:item:68342:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", "|H0:item:166045:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", "|H0:item:45838:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", "|H0:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", "|H0:item:45832:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", "|H0:item:45833:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_trash_up.dds|t " .. GetString(SI_LOOTSANITIZER_TRASH_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_TRASH_CONTROL),
      default = LootSanitizer.defaults.burnJunk,
      getFunc = function() return LootSanitizer.settings.burnJunk end,
      setFunc = function(value) LootSanitizer.settings.burnJunk = value end,
    },
    {
      type = "description",
      -- text = "|cc5c29eУдаление предметов из категории «Мусор», которые стоят 1 золотую. К примеру, |H0:item:57660:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h.|r",
      text = "|cc5c29e" .. zo_strformat(GetString(SI_LOOTSANITIZER_TRASH_DESCRIPTION), "|H0:item:57660:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_junk_up.dds|t " .. GetString(SI_LOOTSANITIZER_JUNK_HEADER),
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_JUNK_DESCRIPTION) .. "|r",
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_COMMON_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_COMMON_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkNormalEquipment,
      getFunc = function() return LootSanitizer.settings.junkNormalEquipment end,
      setFunc = function(value) LootSanitizer.settings.junkNormalEquipment = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_ORNATE_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_ORNATE_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkOrnateEquipment,
      getFunc = function() return LootSanitizer.settings.junkOrnateEquipment end,
      setFunc = function(value) LootSanitizer.settings.junkOrnateEquipment = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_MIDDLE_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_MIDDLE_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkMiddleRawAndMaterial,
      getFunc = function() return LootSanitizer.settings.junkMiddleRawAndMaterial end,
      setFunc = function(value) LootSanitizer.settings.junkMiddleRawAndMaterial = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_NOCRPT_CONTROL),
      default = LootSanitizer.defaults.junkNotCraftedPotion,
      getFunc = function() return LootSanitizer.settings.junkNotCraftedPotion end,
      setFunc = function(value) LootSanitizer.settings.junkNotCraftedPotion = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_NOCRPS_CONTROL),
      default = LootSanitizer.defaults.junkNotCraftedPoison,
      getFunc = function() return LootSanitizer.settings.junkNotCraftedPoison end,
      setFunc = function(value) LootSanitizer.settings.junkNotCraftedPoison = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_NOCRFD_CONTROL),
      default = LootSanitizer.defaults.junkNotCraftedFood,
      getFunc = function() return LootSanitizer.settings.junkNotCraftedFood end,
      setFunc = function(value) LootSanitizer.settings.junkNotCraftedFood = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_NOCRDR_CONTROL),
      default = LootSanitizer.defaults.junkNotCraftedDrink,
      getFunc = function() return LootSanitizer.settings.junkNotCraftedDrink end,
      setFunc = function(value) LootSanitizer.settings.junkNotCraftedDrink = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_SLVNPT_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_SLVNPT_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkPotionSolvent,
      getFunc = function() return LootSanitizer.settings.junkPotionSolvent end,
      setFunc = function(value) LootSanitizer.settings.junkPotionSolvent = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_SLVNPS_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_SLVNPS_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkPoisonSolvent,
      getFunc = function() return LootSanitizer.settings.junkPoisonSolvent end,
      setFunc = function(value) LootSanitizer.settings.junkPoisonSolvent = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_TRASH_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_TRASH_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkTrashItem,
      getFunc = function() return LootSanitizer.settings.junkTrashItem end,
      setFunc = function(value) LootSanitizer.settings.junkTrashItem = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_TROVE_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_TROVE_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkTreasureItem,
      getFunc = function() return LootSanitizer.settings.junkTreasureItem end,
      setFunc = function(value) LootSanitizer.settings.junkTreasureItem = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_RFISH_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_RFISH_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkRareFish,
      getFunc = function() return LootSanitizer.settings.junkRareFish end,
      setFunc = function(value) LootSanitizer.settings.junkRareFish = value end,
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_TROPHY_CONTROL),
      tooltip = GetString(SI_LOOTSANITIZER_JUNK_TROPHY_CONTROL_TOOLTIP),
      default = LootSanitizer.defaults.junkMonsterTrophy,
      getFunc = function() return LootSanitizer.settings.junkMonsterTrophy end,
      setFunc = function(value) LootSanitizer.settings.junkMonsterTrophy = value end,
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "checkbox",
      name = GetString(SI_LOOTSANITIZER_JUNK_AUTOSELL_CONTROL),
      default = LootSanitizer.defaults.autoJunkSell,
      getFunc = function() return LootSanitizer.settings.autoJunkSell end,
      setFunc = function(value) LootSanitizer.settings.autoJunkSell = value end,
      disabled = true,
    },
    {
      type = "description",
      text = GetString(SI_LOOTSANITIZER_JUNK_AUTOSELL_DESCRIPTION),
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_quickslot_up.dds:inheritcolor|t " .. GetString(SI_LOOTSANITIZER_COMMAND_HEADER),
    },
    {
      type = "description",
      text = "|cc5c29e" .. GetString(SI_LOOTSANITIZER_COMMAND_DESCRIPTION) .. "|r",
    },
    {
      type = "description",
      text = "/lss |cc5c29e— " .. GetString(SI_LOOTSANITIZER_COMMAND_SETTINGS) .. "|r",
    },
    {
      type = "description",
      text = "/lootsanitizer |cc5c29e— " .. GetString(SI_LOOTSANITIZER_COMMAND_SETTINGS_ALT) .. "|r",
    },
    {
      type = "description",
      text = "/lsstats |cc5c29e— " .. GetString(SI_LOOTSANITIZER_COMMAND_STATISTICS) .. "|r",
    },
    {
      type = "description",
      text = [[
      ]],
    },
  }
  LootSanitizer.controlsPanel = LAM:RegisterOptionControls(panelName, optionsData)
end
