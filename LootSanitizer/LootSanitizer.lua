-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
LootSanitizer = {}

-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
LootSanitizer.name = "LootSanitizer"
LootSanitizer.version = "0.13.2"
LootSanitizer.author = "grin3671"

LootSanitizer.enabled = 1

LootSanitizer.defaults =
{
  workMode = 0,
  chatMode = 1,
  burnEquipment = false,
  burnEquipmentPrice = 1, -- english word used in inventory: value
  burnCompanionItems = 0,
  burnRaceMaterial = 0,
  burnRaceMotif = 0,
  burnTraitMaterial = false,
  burnIngredient = false,
  burnLockpick = false,
  burnLockpickStackSaved = 3,
  burnBait = false,
  burnBaitStackSaved = 1,
  burnJunk = false,
  burnCommonGlyph = false,
  burnRunePotency = false,
  burnRuneEssence = false,
  saveRuneEssenceForDaily = true,
  maxBurnedStack = 10,
  maxBurnedPrice = 100,
  autoBindQuality = 0,
}

LootSanitizer.trashRaceMaterial =
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

LootSanitizer.trashRaceRareMaterial =
{
  46149, -- Бронза // Варварский стиль
  46150, -- Серебро // Первобытный стиль
  46151, -- Сердце даэдра //Даэдрический стиль
  46152, -- Палладий // Древнеэльфиский стиль
  -- 33254, -- Никель // Имперский стиль
}

LootSanitizer.trashTraitMaterial =
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

LootSanitizer.trashRaceMotif =
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

LootSanitizer.trashRaceRareMotif =
{
  51638, --Ремесленный мотив 11: древнеэльфийский
  51565, --Ремесленный мотив 12: варварский
  51345, --Ремесленный мотив 13: первобытный
  51688, --Ремесленный мотив 14: даэдрический
}

LootSanitizer.trashBait =
{
  42869,
  42870,
  42871,
  42872,
}

LootSanitizer.savedItems =
{
  68342,  -- Хакейджо
  166045, -- Индеко
  45838, -- Ракейпа
}

LootSanitizer.dailyRunes =
{
  45831,  -- Око
  45832,  -- Мако
  45833,  -- Дени
}

-- TODO? EVENTS
LootSanitizer.eventJester =
{
  114945, -- Веточка цветущей вишни
  114946, -- Кольцевая шутиха
  114947, -- Струйная шутиха
  114948, -- Спиральная шутиха
  147300, -- Веселый пирог
  171322, -- Игристый сидр из яблок грязевых крабов
  120891, -- [Rare] Шутиха «Искрящийся колпак»
}

-- TODO?
-- == Растворитель для зелья == ID 33 (itemType) ==
-- EX1 ====== EX2 ==== TITLE ============= ID =====
-- Навык 1 == Ур.03 == Природная вода   == ID 883
-- Навык 1 == Ур.10 == Чистая вода      == ID 1187
-- Навык 3 == Ур.30 == Очищенная вода   == ID 23265


LootSanitizer.stats =
{
  ["space"] = 0,
  ["price"] = 0,
}


local LAM = LibAddonMenu2


-- Next we create a function that will initialize our addon
function LootSanitizer:Initialize()
  -- self.inCombat = IsUnitInCombat("player")
  self.autoLootEnabled = GetSetting(LOOT_SETTING_AUTO_LOOT)
  d(LootSanitizer.name .. " initialized. " .. self.autoLootEnabled)

  -- Use SavedVars or Defaults as AddOn Settings
  LootSanitizer.settings = ZO_SavedVars:NewAccountWide("LootSanitizerSavedVariables", 1, nil, LootSanitizer.defaults)

  if (LAM) then
    LootSanitizer:addSettingsMenu()
  end
end


LootSanitizer.linkHandlers =
{
  lslink = function (data) if data then d("linkTypeData: " .. data) end end
}

function LootSanitizer:OnLinkClicked( rawLink, mouseButton, linkText, linkStyle, linkType, ... )
  if (type(linkType) == "string" and LootSanitizer.linkHandlers[linkType]) then
    LootSanitizer.linkHandlers[linkType](...)
    return true -- link has been handled
  end
end

function LootSanitizer:registerChatLinks()
  -- register link type
  LibChatMessage:RegisterCustomChatLink("lslink")
  -- set handlers
  LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, self.OnLinkClicked, self)
  LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, self.OnLinkClicked, self)
end




-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function LootSanitizer.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == LootSanitizer.name then
    LootSanitizer:Initialize()
  end
end



-- My First Function
function LootSanitizer.OnInventoryChanged(eventCode, bagIndex, slotIndex, isNewItem, itemSoundCategory, updateReason, stackCountChange)
  -- Don't do anything with Crown items
  if IsItemFromCrownCrate(bagIndex, slotIndex) or IsItemFromCrownStore(bagIndex, slotIndex) then
    do return end
  end

  if LootSanitizer.enabled == 0 then
    do return end
  end

  if LootSanitizer.settings.workMode == 0 then
    do return end
  elseif LootSanitizer.settings.workMode == 1 and GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT) == "0" then
    do return end
  end

  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  local itemLink = GetItemLink(bagIndex, slotIndex) -- , LINK_STYLE_BRACKETS
  local itemId = GetItemLinkItemId(itemLink)
  local itemIcon, itemQuantity, itemPrice, meetsUsageRequirement, locked, equipType, itemStyle, quality, displayQuality = GetItemInfo(bagIndex, slotIndex)
  local itemTrade, itemType, _, itemEx2, _ = GetItemCraftingInfo(bagIndex, slotIndex)
  local itemTrait = GetItemTrait(bagIndex, slotIndex)
  local itemRarity = displayQuality or quality

  local _, itemSpecialType = GetItemLinkItemType(itemLink)
  local specializedItemTypeText = ZO_GetSpecializedItemTypeText(itemType, itemSpecialType)
  local stringSpecialType = ""
  if specializedItemTypeText then
    stringSpecialType = " (" .. specializedItemTypeText .. ", " .. itemSpecialType .. ")"
  end

  -- Collection Status
  if IsItemLinkSetCollectionPiece(itemLink) then
    local itemId = GetItemLinkItemId(itemLink)
    if not IsItemSetCollectionPieceUnlocked(itemId) then
      -- AutoItemBinder
      if LootSanitizer.settings.autoBindQuality > 0 and itemRarity <= LootSanitizer.settings.autoBindQuality then
        BindItem(bagIndex, slotIndex)
        LootSanitizer:Message(itemLink, "bind")
      end
    end
  end

  -- Unknown Trait Status
  local stringNewTrait = ""
  local itemHasUnknownTrait = false
  local itemHasInspirationTrait = false
  local traitType, traitDescription = GetItemLinkTraitInfo(itemLink)
  if traitType ~= ITEM_TRAIT_TYPE_NONE and traitDescription ~= "" then
    local traitName = GetString("SI_ITEMTRAITTYPE", traitType)
    local traitInformation = GetItemTraitInformationFromItemLink(itemLink)
    -- "Increased Inspiration", -- SI_ITEMTRAITINFORMATION1
    -- "Increased Sell Value", -- SI_ITEMTRAITINFORMATION2
    -- "Can Research", -- SI_ITEMTRAITINFORMATION3
    -- "Transmuted", -- SI_ITEMTRAITINFORMATION4
    -- "Reconstructed", -- SI_ITEMTRAITINFORMATION5
    if traitInformation == 1 then
      itemHasInspirationTrait = true
    end
    if traitInformation == 3 then
      itemHasUnknownTrait = true
      stringNewTrait = ", NEW TRAIT!"
    end
  end

  -- isCompanionItem
  local isCompanionItem = false
  if GetItemLinkActorCategory(itemLink) == GAMEPLAY_ACTOR_CATEGORY_COMPANION then
    isCompanionItem = true
  end

  -- isPlayerEquip
  local isPlayerEquip = false
  if isCompanionItem == false and ((equipType == EQUIP_TYPE_RING or equipType == EQUIP_TYPE_NECK) or (itemSpecialType == SPECIALIZED_ITEMTYPE_WEAPON or itemSpecialType == SPECIALIZED_ITEMTYPE_ARMOR)) then
    isPlayerEquip = true
  end

  -- Extra info about items in chat
  if LootSanitizer.settings.chatMode == 2 then
    -- Название связанной профессии
    local stringCraftType = ""
    if(itemTrade ~= CRAFTING_TYPE_INVALID) then
      stringCraftType = " (" .. GetCraftingSkillName(itemTrade) .. ", " .. itemTrade .. ")"
    end

    -- Неизвестные рецепты (ITEMTYPE_RECIPE == 29)
    if(itemType == ITEMTYPE_RECIPE) then
      local craftingSkillType = GetItemLinkRecipeCraftingSkillType(itemLink)
      if not IsItemLinkRecipeKnown(itemLink) then
        d("НАЙДЕН НОВЫЙ РЕЦЕПТ!" .. " / " .. GetCraftingSkillName(craftingSkillType) .. " / " .. GetString(SI_ITEM_FORMAT_STR_UNKNOWN_RECIPE))
      end
    end

    if IsItemLinkBookPartOfCollection(itemLink) then
      if not IsItemLinkBookKnown(itemLink) then
        d("НАЙДЕНА НОВАЯ КНИГА/СТРАНИЦА СТИЛЯ!")
      end
    end

    --
    local collectibleId = GetItemLinkTooltipRequiresCollectibleId(itemLink)
    if collectibleId ~= 0 then
      local collectibleName = GetCollectibleName(collectibleId)
      if collectibleName ~= "" then
        local collectibleCategory = GetCollectibleCategoryType(collectibleId)
        d("Collection: " .. collectibleName .." (" .. collectibleCategory .. ")")
      end
    end

    -- "Use to add to your Collections", -- SI_ITEM_FORMAT_STR_ADD_TO_COLLECTION
    -- "Already in your Collections", -- SI_ITEM_FORMAT_STR_ALREADY_IN_COLLECTION
    local grantedCollectibleId = GetItemLinkContainerCollectibleId(itemLink)
    if grantedCollectibleId > 0 then
      local collectibleCategory = GetCollectibleCategoryType(grantedCollectibleId)
      if IsCollectibleOwnedByDefId(grantedCollectibleId) then
        d(GetString(SI_ITEM_FORMAT_STR_ALREADY_IN_COLLECTION))
      elseif collectibleCategory == COLLECTIBLE_CATEGORY_TYPE_COMBINATION_FRAGMENT and not CanCombinationFragmentBeUnlocked(grantedCollectibleId) then
        d(GetString(SI_ITEM_FORMAT_STR_ALREADY_OWN_COMBINATION_RESULT))
      else
        d("New item")
      end
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

    d(zo_iconTextFormat(itemIcon, 22, 22, "", false) .. itemLink .. " (" .. stackCountChange .. ") | ID:" .. itemId .. stringCraftType .. stringItemType .. stringSpecialType .. stringItemStyle .. stringItemTrait .. stringNewTrait)
  end

  if LootSanitizer.settings.burnEquipment and isPlayerEquip and itemPrice == 1 and quality == 1 and itemTrait == 0 then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end

  -- Удаление предметов спутников
  if isCompanionItem and LootSanitizer.settings.burnCompanionItems >= 1 and displayQuality <= LootSanitizer.settings.burnCompanionItems then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end

  -- Удаление материалов стилей
  if LootSanitizer.settings.burnRaceMaterial >= 1 and LootSanitizer.HasValue(LootSanitizer.trashRaceMaterial, itemId) then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end
  if LootSanitizer.settings.burnRaceMaterial == 2 and LootSanitizer.HasValue(LootSanitizer.trashRaceRareMaterial, itemId) then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление мотивов
  if LootSanitizer.settings.burnRaceMotif >= 1 and LootSanitizer.HasValue(LootSanitizer.trashRaceMotif, itemId) then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end
  if LootSanitizer.settings.burnRaceMotif == 2 and LootSanitizer.HasValue(LootSanitizer.trashRaceRareMotif, itemId) then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление материалов особенностей
  if LootSanitizer.settings.burnTraitMaterial and LootSanitizer.HasValue(LootSanitizer.trashTraitMaterial, itemId) then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление ингредиентов
  if LootSanitizer.settings.burnIngredient and itemTrade == 5 and quality == 1 and itemPrice == 1 then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление лишних отмычек
  if LootSanitizer.settings.burnLockpick and itemId == 30357 and itemQuantity == 1 and GetItemLinkStacks(itemLink) >= 200 * LootSanitizer.settings.burnLockpickStackSaved then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление лишних наживок
  if LootSanitizer.settings.burnBait and LootSanitizer.HasValue(LootSanitizer.trashBait, itemId) and GetItemLinkStacks(itemLink) >= 200 * LootSanitizer.settings.burnBaitStackSaved then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
  end

  -- Удаление лишних глифов
  if LootSanitizer.settings.burnCommonGlyph and (itemType == 20 or itemType == 21 or itemType == 26) and stackCountChange == 1 and IsItemLinkCrafted(itemLink) == false and quality == 1 then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end

  -- Удаление рун силы (квадратные)
  if LootSanitizer.settings.burnRunePotency and itemType == 51 and stackCountChange <= LootSanitizer.settings.maxBurnedStack and itemEx2 ~= 10 then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end

  -- Удаление рун сущности (треугольные)
  if LootSanitizer.settings.burnRuneEssence and itemType == 53 and stackCountChange <= LootSanitizer.settings.maxBurnedStack and LootSanitizer.HasValue(LootSanitizer.savedItems, itemId) == false then
    if LootSanitizer.settings.saveRuneEssenceForDaily and LootSanitizer.HasValue(LootSanitizer.dailyRunes, itemId) then
      do return end
    end
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end

  -- Удаление дешевого (1) мусора
  if LootSanitizer.settings.burnJunk and itemSpecialType == SPECIALIZED_ITEMTYPE_TRASH and itemPrice == 1 then
    LootSanitizer:Message(itemLink)
    LootSanitizer:DestroyItem(bagIndex, slotIndex)
    LootSanitizer:UpdateStats(itemPrice * stackCountChange)
  end
end

-- Sounds
-- SKILL_PURCHASED / BOOK_ACQUIRED / LOCKPICKING_BREAK
function LootSanitizer:DestroyItem(bagIndex, slotIndex)
  DestroyItem(bagIndex, slotIndex)
  PlaySound(SOUNDS.INVENTORY_DESTROY_JUNK)
end

-- Updating session stats
function LootSanitizer:UpdateStats(itemPrice, slotCount)
  slotCount = slotCount or 1
  self.stats.price = self.stats.price + itemPrice
  self.stats.space = self.stats.space + slotCount
end

-- Updating session stats
function LootSanitizer:ShowStats()
  CHAT_ROUTER:AddSystemMessage(zo_strformat("[<<1>>] В течение этой сессии аддон освободил <<2>> ячеек в сумке. Удалено предметов на сумму: <<3>>.", "LootSanitizer", LootSanitizer.stats.space, LootSanitizer.stats.price))
end


function LootSanitizer:turnOff ()
  LootSanitizer.enabled = 0
  LootSanitizer:DebugTime("Store Open")
end

function LootSanitizer:turnOn ()
  LootSanitizer.enabled = 1
  LootSanitizer:DebugTime("Store Close")
end


function LootSanitizer:DebugTime(text)
  if self.settings.chatMode == 2 then
    local text = ": " .. text or ""
    local time = tostring(ZO_FormatClockTime())
    d(time .. text)
  end
end


function LootSanitizer:Message (text, type)
  local SanitizerTexts =
  {
    delete = "[" .. GetString(SI_LOOTSANITIZER_NAME) .. "] " .. GetString(SI_LOOTSANITIZER_ACTION),
    bind   = "[" .. GetString(SI_LOOTSANITIZER_NAME) .. "] " .. GetString(SI_LOOTSANITIZER_BINDACTION),
  }
  local textTypePrefix = "delete"
  if type then textTypePrefix = type end
  if LootSanitizer.settings.chatMode > 0 then
    CHAT_ROUTER:AddSystemMessage(string.format(SanitizerTexts[textTypePrefix] .. " " .. text .. "."))
  end
end


function LootSanitizer.HasValue (checkedTable, checkedValue)
  for index, value in ipairs(checkedTable) do
    if value == checkedValue then
      return true
    end
  end
  return false
end


function LootSanitizer:openSettingsWindow()
  if (self.settingsPanel) then
    LibAddonMenu2:OpenToPanel(self.settingsPanel)
  end
end


SLASH_COMMANDS["/lss"] = function()
  LootSanitizer:openSettingsWindow()
end

SLASH_COMMANDS["/lootsanitizer"] = function()
  LootSanitizer:openSettingsWindow()
end

SLASH_COMMANDS["/lsstats"] = function()
  LootSanitizer:ShowStats()
end


-- Register addon loading
EVENT_MANAGER:RegisterForEvent(LootSanitizer.name, EVENT_ADD_ON_LOADED, LootSanitizer.OnAddOnLoaded)

-- This type of event does not allow to remove items, cos did not provide bagIndex and slotIndex
--EVENT_MANAGER:RegisterForEvent(LootSanitizer.name, EVENT_LOOT_RECEIVED, LootSanitizer.OnLootReceived)

-- Do thing after getting new items in backpack
EVENT_MANAGER:RegisterForEvent(LootSanitizer.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, LootSanitizer.OnInventoryChanged)
EVENT_MANAGER:AddFilterForEvent(LootSanitizer.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)
EVENT_MANAGER:AddFilterForEvent(LootSanitizer.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
EVENT_MANAGER:AddFilterForEvent(LootSanitizer.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)

-- Turn off/on addon on open/close vendors store to prevent destoing buyed items
EVENT_MANAGER:RegisterForEvent(LootSanitizer.name, EVENT_OPEN_STORE, LootSanitizer.turnOff)
EVENT_MANAGER:RegisterForEvent(LootSanitizer.name, EVENT_CLOSE_STORE, LootSanitizer.turnOn)
