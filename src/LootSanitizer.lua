-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
ThisAddOn = {}

-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
ThisAddOn.name = "LootSanitizer"
ThisAddOn.version = "0.9.96"
ThisAddOn.author = "grin3671"

ThisAddOn.defaultSettings =
{
  workMode = 0,
  chatMode = 1,
  burnEquipment = false,
  burnEquipmentCost = 0,
  burnRaceMaterial = 0,
  burnRaceMotif = 0,
  burnTraitMaterial = false,
  burnIngredient = false,
  burnLockpick = false,
  burnLockpickStackSaved = 3,
  burnBait = false,
  burnBaitStackSaved = 1,
}

ThisAddOn.trashRaceMaterial =
{
  33150, -- Кремень // Аргониан
  33194, -- Кость // Босмер
  33251, -- Молибден // Бретон
  33252, -- Адамантит // Альтмер
  33253, -- Обсидиан // Данмер
  33255, -- Лунный камень // Каджит
  33256, -- Корунд // Норд
  33257, -- Марганец // Орк
  33258, -- Звездный металл // Редгард
}

ThisAddOn.trashRaceRareMaterial =
{
  46149, -- Бронза // Варварский стиль
  46150, -- Серебро // Первобытный стиль
  46151, -- Сердце даэдра //Даэдрический стиль
  46152, -- Палладий // Древнеэльфиский стиль
  -- 33254, -- Никель // Имперский стиль
}

ThisAddOn.trashTraitMaterial =
{
  23221, -- Альмадин // Удобство // 14
  23204, -- Аметист // Сила стихий // 2
  813,   -- Бирюза // Оберег // 5
  23219, -- Бриллиант // Непробиваемость // 12
  30219, -- Гелиотроп // Насыщенность // 16
  23171, -- Гранат // Бодрость // 17
  4442,  -- Изумруд // Развитие // 15
  4456,  -- Кварц // Стойкость // 11
  810,   -- Нефрит
  23149, -- Огненный опал
  4486,  -- Рубин
  23173, -- Сапфир
  30221, -- Сардоникс
  23165, -- Сердолик
  23203, -- Хризолит
  16291, -- Цитрин
}

ThisAddOn.trashRaceMotif =
{
  16424, -- Ремесленный мотив 1: альтмеры
  27245, -- Ремесленный мотив 2: данмеры
  16428, -- Ремесленный мотив 3: босмеры
  27244, -- Ремесленный мотив 4: норды
  16425, -- Ремесленный мотив 5: бретонский стиль
  16427, -- Ремесленный мотив 6: редгарды
  44698, -- Ремесленный мотив 7: каджиты
  16426, -- Ремесленный мотив 8: орки
  27246, -- Ремесленный мотив 9: аргониане
}

ThisAddOn.trashRaceRareMotif =
{
  51638, --Ремесленный мотив 11: древнеэльфийский
  51565, --Ремесленный мотив 12: варварский
  51345, --Ремесленный мотив 13: первобытный
  51688, --Ремесленный мотив 14: даэдрический
}

ThisAddOn.trashBait =
{
  42869,
  42870,
  42871,
  42872,
}

-- TODO?
ThisAddOn.trashCraftMaterial =
{
  -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL
    5820, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // 16-24
   23103, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // 26-34
   23104, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // 36-44
   23105, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // 46-50
  -- ???, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // Champ 70-80
  -- ???, -- ITEMTYPE_BLACKSMITHING_RAW_MATERIAL // Champ 90-140

  -- ITEMTYPE_BLACKSMITHING_MATERIAL
    4487, -- ITEMTYPE_BLACKSMITHING_MATERIAL // 16-24
   23107, -- ITEMTYPE_BLACKSMITHING_MATERIAL // 26-34
    6000, -- ITEMTYPE_BLACKSMITHING_MATERIAL // 36-44
    6001, -- ITEMTYPE_BLACKSMITHING_MATERIAL // 46-50
   46127, -- ITEMTYPE_BLACKSMITHING_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_BLACKSMITHING_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_BLACKSMITHING_MATERIAL // Champ 70-80
   46130, -- ITEMTYPE_BLACKSMITHING_MATERIAL // Champ 90-140

  -- ITEMTYPE_CLOTHIER_RAW_MATERIAL
  -- Cloth
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 16-24
   23129, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 26-34
   23130, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 36-44
   23131, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 46-50
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 70-80
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 90-140
  -- Leather
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 16-24
   23095, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 26-34
    6020, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 36-44
   23097, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // 46-50
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 70-80
  -- ???, -- ITEMTYPE_CLOTHIER_RAW_MATERIAL // Champ 90-140

  -- ITEMTYPE_CLOTHIER_MATERIAL
  -- Cloth
    4463, -- ITEMTYPE_CLOTHIER_MATERIAL // 16-24
   23125, -- ITEMTYPE_CLOTHIER_MATERIAL // 26-34
   23126, -- ITEMTYPE_CLOTHIER_MATERIAL // 36-44
   23127, -- ITEMTYPE_CLOTHIER_MATERIAL // 46-50
   46131, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 10-30
   46132, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 40-60
   46133, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 70-80
   46134, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 90-140
  -- Leather
    4463, -- ITEMTYPE_CLOTHIER_MATERIAL // 16-24
   23099, -- ITEMTYPE_CLOTHIER_MATERIAL // 26-34
   23100, -- ITEMTYPE_CLOTHIER_MATERIAL // 36-44
   23101, -- ITEMTYPE_CLOTHIER_MATERIAL // 46-50
   46135, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 40-60
   46137, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 70-80
   46138, -- ITEMTYPE_CLOTHIER_MATERIAL // Champ 90-140

  -- ITEMTYPE_WOODWORKING_RAW_MATERIAL
     521, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // 16-24
   23117, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // 26-34
   23118, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // 36-44
   23119, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // 46-50
  -- ???, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // Champ 10-30
  -- ???, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // Champ 70-80
  -- ???, -- ITEMTYPE_WOODWORKING_RAW_MATERIAL // Champ 90-140

  -- ITEMTYPE_WOODWORKING_MATERIAL
     533, -- ITEMTYPE_WOODWORKING_MATERIAL // 16-24
   23121, -- ITEMTYPE_WOODWORKING_MATERIAL // 26-34
   23122, -- ITEMTYPE_WOODWORKING_MATERIAL // 36-44
   23123, -- ITEMTYPE_WOODWORKING_MATERIAL // 46-50
  -- ???, -- ITEMTYPE_WOODWORKING_MATERIAL // Champ 10-30
   46140, -- ITEMTYPE_WOODWORKING_MATERIAL // Champ 40-60
  -- ???, -- ITEMTYPE_WOODWORKING_MATERIAL // Champ 70-80
   46142, -- ITEMTYPE_WOODWORKING_MATERIAL // Champ 90-140


  135139, -- Медная пыль // 26-50
  135140, -- Унция меди // 26-50
  135142, -- Унция серебра // Champ 10-70
}

-- TODO?
-- == Растворитель для зелья == ID 33 (itemType) ==
-- EX1 ====== EX2 ==== TITLE ============= ID =====
-- Навык 1 == Ур.03 == Природная вода   == ID 883
-- Навык 1 == Ур.10 == Чистая вода      == ID 1187
-- Навык 3 == Ур.30 == Очищенная вода   == ID 23265

local LAM = LibAddonMenu2



-- Next we create a function that will initialize our addon
function ThisAddOn:Initialize()
  -- self.inCombat = IsUnitInCombat("player")
  self.autoLootEnabled = GetSetting(LOOT_SETTING_AUTO_LOOT)
  d(ThisAddOn.name .. " initialized. " .. self.autoLootEnabled)

  ThisAddOn.accountSettings = ZO_SavedVars:NewAccountWide("LootSanitizerSavedVariables", 1, nil, ThisAddOn.defaultSettings)

  if (LAM) then
    ThisAddOn:addSettingsMenu()
  end
end



-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function ThisAddOn.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == ThisAddOn.name then
    ThisAddOn:Initialize()
  end
end



-- My First Function
function ThisAddOn.OnInventoryChanged(eventCode, bagIndex, slotIndex, isNewItem, itemSoundCategory, updateReason, stackCountChange)
  -- Don't do anything with Crown items
  local isCrownCrate = IsItemFromCrownCrate(bagIndex, slotIndex)
  local isCrownStore = IsItemFromCrownStore(bagIndex, slotIndex)
  if isCrownCrate or isCrownStore then
    do return end
  end

  if ThisAddOn.accountSettings.workMode == 0 then
    do return end
  elseif ThisAddOn.accountSettings.workMode == 1 and GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT) == "0" then
    do return end
  end

  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  local itemLink = GetItemLink(bagIndex, slotIndex) -- , LINK_STYLE_BRACKETS
  local itemId = GetItemLinkItemId(itemLink)
  local itemIcon, itemQuantity, itemPrice, meetsUsageRequirement, locked, equipType, itemStyle, quality, displayQuality = GetItemInfo(bagIndex, slotIndex)
  local itemTrade, itemType, itemEx1, itemEx2, itemEx3 = GetItemCraftingInfo(bagIndex, slotIndex)
  local itemTrait = GetItemTrait(bagIndex, slotIndex)


  if ThisAddOn.accountSettings.chatMode == 2 then

    -- Название связанной профессии
    local stringCraftType = ""
    if(itemTrade ~= CRAFTING_TYPE_INVALID) then
      stringCraftType = " (" .. GetCraftingSkillName(itemTrade) .. ", " .. itemTrade .. ")"
    end

    -- Название типа предмета
    local stringItemType = ""
    if(itemType ~= ITEMTYPE_NONE) then
      stringItemType = " (" .. GetString("SI_ITEMTYPE", itemType) .. ", " .. itemType .. ")"
    end

    -- Название качества предмета (НЕ ИСПОЛЬЗУЕТСЯ)
    local stringItemQuality = ""
    if(displayQuality) then
      stringItemQuality = " (" .. GetString("SI_ITEMDISPLAYQUALITY", displayQuality) .. ", " .. displayQuality .. ")"
    end

    -- Название стиля предмета
    local stringItemStyle = ""
    if (itemStyle ~= ITEMSTYLE_NONE and itemStyle ~= ITEMSTYLE_UNIVERSAL and itemStyle ~= ITEMSTYLE_UNIQUE) then
      stringItemStyle = " (" .. GetItemStyleName(itemStyle) .. ", " .. itemStyle .. ")"
    end

    -- Название особенности предмета
    local stringItemTrait = ""
    if (itemTrait ~= ITEM_TRAIT_TYPE_NONE) then
      stringItemTrait = " (" .. GetString("SI_ITEMTRAITTYPE", itemTrait) .. ", " .. itemTrait .. ")"
    end


    d(zo_iconTextFormat(itemIcon, 22, 22, "", false) .. itemLink .. " (" .. stackCountChange .. ") | ID:" .. itemId .. stringCraftType .. stringItemType .. stringItemStyle .. stringItemTrait)

    local stringExtra = ""
    if itemEx1 then stringExtra = stringExtra .. itemEx1 .. ", " end
    if itemEx2 then stringExtra = stringExtra .. itemEx2 .. ", " end
    if itemEx3 then stringExtra = stringExtra .. itemEx3 end
    if itemEx1 or itemEx2 or itemEx3 then
      d("Extra: " .. stringExtra)
    end

    -- -- TODO: ThisAddOn.PrintAllItemCategories(itemLink)
    -- local itemTags = GetItemLinkNumItemTags(itemLink)
    -- local stringItemTagsCategory = ""
    -- local stringItemTags = ""
    -- for i = 1, itemTags do
    --   local itemTagDescription, itemTagCategory = GetItemLinkItemTagInfo(itemLink, i)
    --   if itemTagCategory ~= "" then
    --     stringItemTagsCategory = GetString("SI_ITEMTAGCATEGORY", itemTagCategory)
    --   end
    --   if stringItemTags ~= "" then
    --     stringItemTags = stringItemTags .. ", " .. itemTagDescription
    --   else
    --     stringItemTags = stringItemTags .. itemTagDescription
    --   end
    -- end
    -- if stringItemTagsCategory ~= "" then
    --   d(stringItemTagsCategory .. " " .. stringItemTags)
    -- end

    -- TODO: ZeroPriceEquip, Lockpicks, Glyph, SellingTrash, ZeroPriceTrash
    if itemPrice == 0 and itemQuantity == 1 and quality == 0 then
      d("U picked up some trash: " .. itemLink .. ". V2")
      -- DestroyItem(bagIndex, slotIndex)
    end

  end

  if ThisAddOn.accountSettings.burnEquipment and equipType ~= EQUIP_TYPE_COSTUME and equipType ~= EQUIP_TYPE_INVALID and itemPrice == 0 and quality == 1 and itemTrait == 0 then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление материалов стилей
  if ThisAddOn.accountSettings.burnRaceMaterial >= 1 and ThisAddOn.HasValue(ThisAddOn.trashRaceMaterial, itemId) then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end
  if ThisAddOn.accountSettings.burnRaceMaterial == 2 and ThisAddOn.HasValue(ThisAddOn.trashRaceRareMaterial, itemId) then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление мотивов
  if ThisAddOn.accountSettings.burnRaceMotif >= 1 and ThisAddOn.HasValue(ThisAddOn.trashRaceMotif, itemId) then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end
  if ThisAddOn.accountSettings.burnRaceMotif == 2 and ThisAddOn.HasValue(ThisAddOn.trashRaceRareMotif, itemId) then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление материалов особенностей
  if ThisAddOn.accountSettings.burnTraitMaterial and ThisAddOn.HasValue(ThisAddOn.trashTraitMaterial, itemId) then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление ингредиентов
  if ThisAddOn.accountSettings.burnIngredient and itemTrade == 5 and quality == 1 and itemPrice == 0 then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление лишних отмычек
  if ThisAddOn.accountSettings.burnLockpick and itemId == 30357 and itemQuantity == 1 and GetItemLinkStacks(itemLink) >= 200 * ThisAddOn.accountSettings.burnLockpickStackSaved then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление лишних наживок
  if ThisAddOn.accountSettings.burnBait and ThisAddOn.HasValue(ThisAddOn.trashBait, itemId) and GetItemLinkStacks(itemLink) >= 200 * ThisAddOn.accountSettings.burnBaitStackSaved then
    ThisAddOn:ChatNotification(itemLink)
    DestroyItem(bagIndex, slotIndex)
  end

end



function ThisAddOn:ChatNotification (itemLink)
  if ThisAddOn.accountSettings.chatMode > 0 then
    d("[" .. GetString(SI_LOOTSANITIZER_NAME) .. "] " .. GetString(SI_LOOTSANITIZER_ACTION) .. " " .. itemLink .. ".")
  end
end



function ThisAddOn.HasValue (checkedTable, checkedValue)
    for index, value in ipairs(checkedTable) do
        if value == checkedValue then
            return true
        end
    end

    return false
end



-- integer eventCode, string lootedBy, string itemLink, integer quantity, integer itemSound, lootType lootType, bool isStolen
function ThisAddOn.OnLootReceived(eventCode, lootedBy, itemLink, itemQuantity, itemSound, lootType, isStolen)

  if (lootType == LOOT_TYPE_ITEM) then

    local stringType = ""

    local itemId = GetItemLinkItemId(itemLink)
    -- Returns: string itemIcon, number itemPrice, boolean itemUsageReq, number itemEquipType, number itemStyle
    local itemIcon, itemPrice, itemUsageReq, itemEquipType, itemStyle = GetItemLinkInfo(itemLink)

    local stringIcon = ""
    stringIcon = zo_iconTextFormat(itemIcon, 22, 22, "", false)

    -- local itemStyle = GetItemLinkItemStyle(itemLink)
    local stringStyle = ""
    if (itemStyle ~= ITEMSTYLE_NONE and itemStyle ~= ITEMSTYLE_UNIVERSAL and itemStyle ~= ITEMSTYLE_UNIQUE) then
      stringStyle = " (" .. GetItemStyleName(itemStyle) .. ", " .. itemStyle .. ")"
    end

    local craftingSkillType = GetItemLinkCraftingSkillType(itemLink)
    if(craftingSkillType ~= CRAFTING_TYPE_INVALID) then
      stringType = " (" .. GetCraftingSkillName(craftingSkillType) .. ", " .. craftingSkillType .. ")"
    end

    d(stringIcon .. itemLink .. stringType .. stringStyle .. " #" .. itemId .. " | " .. itemStyle)

    if (itemEquipType ~= EQUIP_TYPE_COSTUME and itemEquipType ~= EQUIP_TYPE_INVALID and itemPrice == 0) then
      d("Shouldn't it be burned?")
    end
    
    -- Удаление лишних отмычек
    if (itemId == 30357 and itemQuantity == 1 and GetItemLinkStacks(itemLink) > 200 * ThisAddOn.defaultSettings.burnLockpickStackSaved) then
      d("Shouldn't it be burned?")
    end

  end

end


function ThisAddOn:addSettingsMenu ()
  local panelName = "LootSanitizerSettings"

  -- Заголовок
  ThisAddOn.settingsPanel = LAM:RegisterAddonPanel(panelName, {
    type = "panel",
    name = ThisAddOn.name,
    version = ThisAddOn.version,
    author = ThisAddOn.author,
  })

  local optionsData = {
    [1] = {
      type = "description",
      text = [[|cff0000Внимание!|r Удалённые предметы нельзя вернуть.]],
    },
    [2] = {
      type = "dropdown",
      name = "Удалять лишние предметы",
      choices = {"Нет", "Только при автосборе", "Всегда"},
      choicesValues = {0, 1, 2},
      default = ThisAddOn.defaultSettings.workMode,
      getFunc = function() return ThisAddOn.accountSettings.workMode end,
      setFunc = function(value) ThisAddOn.accountSettings.workMode = value end,
    },
    [3] = {
      type = "dropdown",
      name = "Уведомления в чатe",
      choices = {"Отключены", "Только о удалении", "Режим разработчика"},
      choicesValues = {0, 1, 2},
      default = ThisAddOn.defaultSettings.chatMode,
      getFunc = function() return ThisAddOn.accountSettings.chatMode end,
      setFunc = function(value) ThisAddOn.accountSettings.chatMode = value end,
    },
    [4] = {
      type = "description",
      text = [[
      ]],
    },
    [5] = {
      type = "header",
      name = "Экипировка",
    },
    [6] = {
      type = "checkbox",
      name = "Удаление экипировки",
      default = ThisAddOn.defaultSettings.burnEquipment,
      getFunc = function() return ThisAddOn.accountSettings.burnEquipment end,
      setFunc = function(value) ThisAddOn.accountSettings.burnEquipment = value end,
    },
    [7] = {
      type = "slider",
      name = "Максимальная стоимость удаляемых предметов",
      min = 0,
      max = 1000,
      disabled = true,
      tooltip = "Настройка стоимости не работает",
      default = ThisAddOn.defaultSettings.burnEquipmentCost,
      getFunc = function() return ThisAddOn.accountSettings.burnEquipmentCost end,
      setFunc = function(value) ThisAddOn.accountSettings.burnEquipmentCost = value end,
    },
    [8] = {
      type = "description",
      text = [[|cc5c29eУдаляется только обычная, ничего не стоящая экипировка в стилях 9-ти стандартных рас и при отсутствии ремесленных особеностей.|r
      ]],
    },
    [9] = {
      type = "header",
      name = "Материалы стилей и мотивы",
    },
    [10] = {
      type = "dropdown",
      name = "Удалять материалы стилей",
      choices = {"Нет", "Только стандартные", "Включая редкие"},
      choicesValues = {0, 1, 2},
      default = ThisAddOn.defaultSettings.burnRaceMaterial,
      getFunc = function() return ThisAddOn.accountSettings.burnRaceMaterial end,
      setFunc = function(value) ThisAddOn.accountSettings.burnRaceMaterial = value end,
    },
    [11] = {
      type = "dropdown",
      name = "Удалять ремесленные мотивы",
      choices = {"Нет", "Только стандартные", "Включая редкие"},
      choicesValues = {0, 1, 2},
      default = ThisAddOn.defaultSettings.burnRaceMotif,
      getFunc = function() return ThisAddOn.accountSettings.burnRaceMotif end,
      setFunc = function(value) ThisAddOn.accountSettings.burnRaceMotif = value end,
    },
    [12] = {
      type = "description",
      text = [[|cc5c29eСтандартными считаются стили 9-ти стандартных рас, доступных игрокам. Редкими — Варварский, Древнеэльфийский, Даэдрический и Первобытный.|r
      ]],
    },
    [13] = {
      type = "header",
      name = "Материалы особенностей",
    },
    [14] = {
      type = "checkbox",
      name = "Удаление материалов особенностей",
      tooltip = "Удаление материалов особенностей.",
      default = ThisAddOn.defaultSettings.burnTraitMaterial,
      getFunc = function() return ThisAddOn.accountSettings.burnTraitMaterial end,
      setFunc = function(value) ThisAddOn.accountSettings.burnTraitMaterial = value end,
    },
    [15] = {
      type = "description",
      text = [[|cc5c29eБудут удаляться только материалы особенностей для доспехов и оружия, за исключением Нирна.|r
      ]],
    },
    [16] = {
      type = "header",
      name = "Ингредиенты",
    },
    [17] = {
      type = "checkbox",
      name = "Удаление ингредиентов",
      tooltip = "Удаление ингредиентов обычной редкости.",
      default = ThisAddOn.defaultSettings.burnIngredient,
      getFunc = function() return ThisAddOn.accountSettings.burnIngredient end,
      setFunc = function(value) ThisAddOn.accountSettings.burnIngredient = value end,
    },
    [18] = {
      type = "description",
      text = [[
      ]],
    },
    [19] = {
      type = "header",
      name = "Отмычки",
    },
    [20] = {
      type = "checkbox",
      name = "Удаление лишних отмычек",
      default = ThisAddOn.defaultSettings.burnLockpick,
      getFunc = function() return ThisAddOn.accountSettings.burnLockpick end,
      setFunc = function(value) ThisAddOn.accountSettings.burnLockpick = value end,
    },
    [21] = {
      type = "slider",
      name = "Сохраняемый запас отмычек",
      tooltip = "Указываются стаки (x200).",
      min = 0,
      max = 20,
      default = ThisAddOn.defaultSettings.burnLockpickStackSaved,
      getFunc = function() return ThisAddOn.accountSettings.burnLockpickStackSaved end,
      setFunc = function(value) ThisAddOn.accountSettings.burnLockpickStackSaved = value end,
      disabled = function() return ThisAddOn.accountSettings.burnLockpick == false end,
    },
    [22] = {
      type = "description",
      text = [[|cc5c29eНовые отмычки будут удаляться, после того как в инвентаре наберётся указанное количество стаков.|r
      ]],
    },
    [23] = {
      type = "header",
      name = "Наживки",
    },
    [24] = {
      type = "checkbox",
      name = "Удаление лишних наживок",
      default = ThisAddOn.defaultSettings.burnBait,
      getFunc = function() return ThisAddOn.accountSettings.burnBait end,
      setFunc = function(value) ThisAddOn.accountSettings.burnBait = value end,
    },
    [25] = {
      type = "slider",
      name = "Сохраняемый запас наживок",
      tooltip = "Указываются стаки (x200).",
      min = 0,
      max = 20,
      default = ThisAddOn.defaultSettings.burnBaitStackSaved,
      getFunc = function() return ThisAddOn.accountSettings.burnBaitStackSaved end,
      setFunc = function(value) ThisAddOn.accountSettings.burnBaitStackSaved = value end,
      disabled = function() return ThisAddOn.accountSettings.burnBait == false end,
    },
    [26] = {
      type = "description",
      text = [[|cc5c29eНовые наживки будут удаляться, после того как в инвентаре наберётся указанное количество стаков.|r
      ]],
    },
  }
  ThisAddOn.controlsPanel = LAM:RegisterOptionControls(panelName, optionsData)
end



-- Finally, we'll register our event handler function to be called when the proper event occurs
EVENT_MANAGER:RegisterForEvent(ThisAddOn.name, EVENT_ADD_ON_LOADED, ThisAddOn.OnAddOnLoaded)

-- Этот тип события не позволяет удалять лут, т.к. не получает bagIndex и slotIndex лута
--EVENT_MANAGER:RegisterForEvent(ThisAddOn.name, EVENT_LOOT_RECEIVED, ThisAddOn.OnLootReceived)

-- Изменение предметов в инвентаре + фильтры
EVENT_MANAGER:RegisterForEvent(ThisAddOn.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ThisAddOn.OnInventoryChanged)
EVENT_MANAGER:AddFilterForEvent(ThisAddOn.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)
EVENT_MANAGER:AddFilterForEvent(ThisAddOn.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
EVENT_MANAGER:AddFilterForEvent(ThisAddOn.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
