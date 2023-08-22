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
      text = [[|cff0000Внимание!|r Удалённые предметы нельзя вернуть.]],
    },
    {
      type = "dropdown",
      name = "Режим удаления предметов",
      choices = {"Отключено", "Только при автосборе", "Всегда"},
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.workMode,
      getFunc = function() return LootSanitizer.settings.workMode end,
      setFunc = function(value) LootSanitizer.settings.workMode = value end,
    },
    {
      type = "dropdown",
      name = "Уведомления в чатe",
      choices = {"Отключено", "Только о удалении", "Режим разработчика"},
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
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_armor_up.dds|t Экипировка",
    },
    {
      type = "checkbox",
      name = "Удаление простой экипировки",
      default = LootSanitizer.defaults.burnEquipment,
      getFunc = function() return LootSanitizer.settings.burnEquipment end,
      setFunc = function(value) LootSanitizer.settings.burnEquipment = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eУдаляется экипировка обычной редкости, которая стоит 1 золотую и не имеет ремесленных особеностей. Предметы созданные игроками удаляться не будут.|r
      ]],
    },
    -- SETS ITEMS
    {
      type = "header",
      name = "|t36:36:EsoUI/Art/Collections/collections_tabIcon_itemSets_up.dds|t " .. GetString(SI_ITEM_SETS_BOOK_TITLE),
    },
    {
      type = "dropdown",
      name = "Автоматическая привязка",
      choices = {"Отключено", "Только зелёные предметы", "Синие и зелёные предметы"},
      choicesValues = {0, 2, 3},
      default = LootSanitizer.defaults.autoBindQuality,
      getFunc = function() return LootSanitizer.settings.autoBindQuality end,
      setFunc = function(value) LootSanitizer.settings.autoBindQuality = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eАвтоматически привязывать новую экипировку выбранного качества для добавления в коллекцию.|r
      ]],
    },
    -- COMPANION ITEMS
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_companion_up.dds:inheritcolor|t " .. GetString("SI_ITEMFILTERTYPE", ITEMFILTERTYPE_COMPANION),
    },
    {
      type = "dropdown",
      name = "Удаление предметов спутников",
      choices = {"Отключено", "Только белые", "Зеленые и ниже", "Синие и ниже"},
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
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_styleMaterial_up.dds:inheritcolor|t Материалы стилей и мотивы",
    },
    {
      type = "dropdown",
      name = "Удаление материалов стилей",
      choices = {"Отключено", "Только стандартные", "Включая редкие"},
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.burnRaceMaterial,
      getFunc = function() return LootSanitizer.settings.burnRaceMaterial end,
      setFunc = function(value) LootSanitizer.settings.burnRaceMaterial = value end,
    },
    {
      type = "dropdown",
      name = "Удаление ремесленных мотивов",
      choices = {"Отключено", "Только стандартные", "Включая редкие"},
      choicesValues = {0, 1, 2},
      default = LootSanitizer.defaults.burnRaceMotif,
      getFunc = function() return LootSanitizer.settings.burnRaceMotif end,
      setFunc = function(value) LootSanitizer.settings.burnRaceMotif = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eСтандартными считаются стили 9-ти стандартных рас, доступных игрокам. Редкими — Варварский, Древнеэльфийский, Даэдрический и Первобытный.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_itemTrait_up.dds|t Материалы особенностей",
    },
    {
      type = "checkbox",
      name = "Удаление материалов особенностей",
      tooltip = "Удаление обычных материалов особенностей для доспехов и оружия. Особенности «Сила Нирна» не удаляются.",
      default = LootSanitizer.defaults.burnTraitMaterial,
      getFunc = function() return LootSanitizer.settings.burnTraitMaterial end,
      setFunc = function(value) LootSanitizer.settings.burnTraitMaterial = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eУдаление обычных материалов особенностей для доспехов и оружия. Особенности «Сила Нирна» не удаляются.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_Craftbag_provisioning_up.dds|t Ингредиенты",
    },
    {
      type = "checkbox",
      name = "Удаление ингредиентов",
      tooltip = "Удаление ингредиентов обычной редкости.",
      default = LootSanitizer.defaults.burnIngredient,
      getFunc = function() return LootSanitizer.settings.burnIngredient end,
      setFunc = function(value) LootSanitizer.settings.burnIngredient = value end,
    },
    {
      type = "description",
      text = [[
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_tool_up.dds|t Отмычки",
    },
    {
      type = "checkbox",
      name = "Удаление лишних отмычек",
      default = LootSanitizer.defaults.burnLockpick,
      getFunc = function() return LootSanitizer.settings.burnLockpick end,
      setFunc = function(value) LootSanitizer.settings.burnLockpick = value end,
    },
    {
      type = "slider",
      name = "Сохраняемый запас отмычек",
      tooltip = "Указываются стаки (x200).",
      min = 0,
      max = 20,
      default = LootSanitizer.defaults.burnLockpickStackSaved,
      getFunc = function() return LootSanitizer.settings.burnLockpickStackSaved end,
      setFunc = function(value) LootSanitizer.settings.burnLockpickStackSaved = value end,
      disabled = function() return LootSanitizer.settings.burnLockpick == false end,
    },
    {
      type = "description",
      text = [[|cc5c29eНовые отмычки будут удаляться, после того как в инвентаре наберётся указанное количество стаков.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_bait_up.dds|t Наживки",
    },
    {
      type = "checkbox",
      name = "Удаление лишних наживок",
      default = LootSanitizer.defaults.burnBait,
      getFunc = function() return LootSanitizer.settings.burnBait end,
      setFunc = function(value) LootSanitizer.settings.burnBait = value end,
    },
    {
      type = "slider",
      name = "Сохраняемый запас наживок",
      tooltip = "Указываются стаки (x200).",
      min = 0,
      max = 20,
      default = LootSanitizer.defaults.burnBaitStackSaved,
      getFunc = function() return LootSanitizer.settings.burnBaitStackSaved end,
      setFunc = function(value) LootSanitizer.settings.burnBaitStackSaved = value end,
      disabled = function() return LootSanitizer.settings.burnBait == false end,
    },
    {
      type = "description",
      text = [[|cc5c29eНовые наживки будут удаляться, после того как в инвентаре наберётся указанное количество стаков.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/TradingHouse/Tradinghouse_Glyphs_Trio_up.dds|t Глифы",
    },
    {
      type = "checkbox",
      name = "Удаление глифов",
      default = LootSanitizer.defaults.burnCommonGlyph,
      getFunc = function() return LootSanitizer.settings.burnCommonGlyph end,
      setFunc = function(value) LootSanitizer.settings.burnCommonGlyph = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eУдаление доспешных, оружейных и ювелирных глифов обычной редкости. Предметы созданные игроками удаляться не будут.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabicon_craftbag_enchanting_up.dds|t Руны",
    },
    {
      type = "checkbox",
      name = "Удаление рун силы",
      default = LootSanitizer.defaults.burnRunePotency,
      getFunc = function() return LootSanitizer.settings.burnRunePotency end,
      setFunc = function(value) LootSanitizer.settings.burnRunePotency = value end,
    },
    {
      type = "checkbox",
      name = "Удаление рун сущности",
      default = LootSanitizer.defaults.burnRuneEssence,
      getFunc = function() return LootSanitizer.settings.burnRuneEssence end,
      setFunc = function(value) LootSanitizer.settings.burnRuneEssence = value end,
    },
    {
      type = "checkbox",
      name = "Сохранять руны для дейликов",
      default = LootSanitizer.defaults.saveRuneEssenceForDaily,
      getFunc = function() return LootSanitizer.settings.saveRuneEssenceForDaily end,
      setFunc = function(value) LootSanitizer.settings.saveRuneEssenceForDaily = value end,
      disabled = function() return not LootSanitizer.settings.burnRuneEssence end,
    },
    {
      type = "description",
      text = [[|cc5c29eУдаляются все квадратные руны силы ниже 10 уровня. Треугольные руны сущности |H0:item:68342:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h, |H0:item:166045:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:45838:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h удаляться не будут. Для ежедневных ремесленных заданий будут сохраняться руны сущности |H0:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h, |H0:item:45832:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h и |H0:item:45833:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_trash_up.dds|t Мусор",
    },
    {
      type = "checkbox",
      name = "Удаление дешевого мусора",
      default = LootSanitizer.defaults.burnJunk,
      getFunc = function() return LootSanitizer.settings.burnJunk end,
      setFunc = function(value) LootSanitizer.settings.burnJunk = value end,
    },
    {
      type = "description",
      text = [[|cc5c29eУдаление предметов из категории «Мусор», которые стоят 1 золотую. К примеру, |H0:item:57660:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h.|r
      ]],
    },
    {
      type = "header",
      name = "|t36:36:esoui/art/inventory/inventory_tabIcon_quickslot_up.dds:inheritcolor|t Команды",
    },
    {
      type = "description",
      text = [[|cc5c29eКоманды для чата, которые помогут вам взаимодействовать с аддоном.|r

/lss |cc5c29e— Открыть окно настроек.|r
/lootsanitizer |cc5c29e— Открыть окно настроек (запасной вариант).|r
/lsstats |cc5c29e— Вывести в чат результаты работы аддона.|r
      ]],
    },
  }
  LootSanitizer.controlsPanel = LAM:RegisterOptionControls(panelName, optionsData)
end
