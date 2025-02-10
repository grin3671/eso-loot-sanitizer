-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
LootSanitizer = {}

-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
LootSanitizer.name = "LootSanitizer"
LootSanitizer.version = "0.17.0"
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
  autoLearnRaceMotif = false,
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
  junkNormalEquipment = false,
  junkOrnateEquipment = false,
  junkMiddleRawAndMaterial = false,
  junkNotCraftedPotion = false,
  junkNotCraftedPoison = false,
  junkNotCraftedFood = false,
  junkNotCraftedDrink = false,
  junkPotionSolvent = false,
  junkPoisonSolvent = false,
  junkTrashItem = false,
  junkTreasureItem = false,
  junkRareFish = false,
  junkMonsterTrophy = false,
  autoJunkSell = false,
  -- LCM Values
  listOfJunk = {},
  listOfBurn = {}
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
  33254, -- Никель // Имперский стиль
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

LootSanitizer.stats =
{
  ["space"] = 0,
  ["price"] = 0,
}


local LAM = LibAddonMenu2
local LCM = LibCustomMenu

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
  
  if (LCM) then
    local function AddItem(inventorySlot, slotActions)
      local valid = ZO_Inventory_GetBagAndIndex(inventorySlot)
      if not valid then return end

      local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
      local itemLink = GetItemLink(bagId, slotIndex)

      -- List of Junk
      local isInAccountJunkList, listJunkIndex = self.HasValue(self.settings.listOfJunk, itemLink);
      slotActions:AddCustomSlotAction(isInAccountJunkList and SI_LOOTSANITIZER_LCMACTION_JUNK_OFF or SI_LOOTSANITIZER_LCMACTION_JUNK_ON, function()
        if isInAccountJunkList == false then
          self:addToList(self.settings.listOfJunk, itemLink)
          self:SetItemJunk(bagId, slotIndex)
        else
          self:removeFromList(self.settings.listOfJunk, listJunkIndex)
        end
      end , "")

      -- List of Burn
      local isInAccountBurnList, listBurnIndex = self.HasValue(self.settings.listOfBurn, itemLink);
      slotActions:AddCustomSlotAction(isInAccountBurnList and SI_LOOTSANITIZER_LCMACTION_BURN_OFF or SI_LOOTSANITIZER_LCMACTION_BURN_ON, function()
        if isInAccountBurnList == false then
          self:addToList(self.settings.listOfBurn, itemLink)
        else
          self:removeFromList(self.settings.listOfBurn, listBurnIndex)
        end
      end , "")
    end
     
    LCM:RegisterContextMenu(AddItem, LCM.CATEGORY_LATE)
  end
end

-- 
function LootSanitizer:addToList(list, itemLink)
  table.insert(list, itemLink)
end
function LootSanitizer:removeFromList(list, index)
  table.remove(list, index)
end
function LootSanitizer:writeList(list)
  if list == "" then
    d("Insert table name after chat command. Eg. junk or burn.")
  elseif list == "junk" then
    for index, value in ipairs(self.settings.listOfJunk) do
      d(zo_strformat("<<1>>. <<2>>", index, value))
    end
  elseif list == "burn" then
    for index, value in ipairs(self.settings.listOfBurn) do
      d(zo_strformat("<<1>>. <<2>>", index, value))
    end
  else
    d("Table with title '" .. tostring(list) .. "' not found.")
  end
end



-- LootSanitizer.linkHandlers =
-- {
--   lslink = function (data) if data then d("linkTypeData: " .. data) end end
-- }

-- function LootSanitizer:OnLinkClicked( rawLink, mouseButton, linkText, linkStyle, linkType, ... )
--   if (type(linkType) == "string" and LootSanitizer.linkHandlers[linkType]) then
--     LootSanitizer.linkHandlers[linkType](...)
--     return true -- link has been handled
--   end
-- end

-- function LootSanitizer:registerChatLinks()
--   -- register link type
--   LibChatMessage:RegisterCustomChatLink("lslink")
--   -- set handlers
--   LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, self.OnLinkClicked, self)
--   LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, self.OnLinkClicked, self)
-- end




-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function LootSanitizer.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == LootSanitizer.name then
    LootSanitizer:Initialize()
  end
end


function LootSanitizer:IsItemShouldBeDestroed(bagIndex, slotIndex, stackCountChange)
  local itemLink = GetItemLink(bagIndex, slotIndex)

  -- Don't do anything with Crown and Crafted items
  local isCrownCrate = IsItemFromCrownCrate(bagIndex, slotIndex)
  local isCrownStore = IsItemFromCrownStore(bagIndex, slotIndex)
  local isItemCrafted = IsItemLinkCrafted(itemLink) or GetItemCreatorName(bagIndex, slotIndex) ~= ""
  if isCrownCrate or isCrownStore or isItemCrafted then
    return false, "R1"
  end

  -- User Blacklist
  local isItemInBurnList = LootSanitizer.HasValue(LootSanitizer.settings.listOfBurn, itemLink)
  if isItemInBurnList then
    return true, "R100"
  end

  -- Get additional info
  local itemId = GetItemLinkItemId(itemLink)
  local itemIcon, itemQuantity, itemPrice, meetsUsageRequirement, locked, itemEquipType, itemStyle, quality, displayQuality = GetItemInfo(bagIndex, slotIndex)
  local itemTrait = GetItemTrait(bagIndex, slotIndex)
  local itemType, itemSpecialType = GetItemType(bagIndex, slotIndex)
  local itemTrade, _, _, itemEx2, _ = GetItemCraftingInfo(bagIndex, slotIndex)
  local itemReqSkillRank = GetItemLinkRequiredCraftingSkillRank(itemLink)
  local itemRarity = displayQuality or quality

  -- Get additional info
  local isNewMotif = false
  if IsItemLinkBookPartOfCollection(itemLink) then
    if not IsItemLinkBookKnown(itemLink) then
      isNewMotif = true
    end
  end

  local isCompanionItem = false
  if GetItemLinkActorCategory(itemLink) == GAMEPLAY_ACTOR_CATEGORY_COMPANION then
    isCompanionItem = true
  end

  local isPlayerEquip = false
  if isCompanionItem == false and ((itemEquipType == EQUIP_TYPE_RING or itemEquipType == EQUIP_TYPE_NECK) or (itemSpecialType == SPECIALIZED_ITEMTYPE_WEAPON or itemSpecialType == SPECIALIZED_ITEMTYPE_ARMOR)) then
    isPlayerEquip = true
  end

  -- Calculate reason
  if self.settings.burnEquipment and isPlayerEquip and itemPrice == 1 and quality == 1 and itemTrait == 0 then
    return true, "R101"
  end

  if self.settings.burnCompanionItems >= 1 and isCompanionItem and itemRarity <= self.settings.burnCompanionItems then
    return true, "R102"
  end

  -- Удаление материалов стилей
  if self.settings.burnRaceMaterial >= 1 and self.HasValue(self.trashRaceMaterial, itemId) then
    return true, "R103"
  end

  if self.settings.burnRaceMaterial == 2 and self.HasValue(self.trashRaceRareMaterial, itemId) then
    return true, "R104"
  end

  if self.settings.burnTraitMaterial and self.HasValue(self.trashTraitMaterial, itemId) then
    return true, "R105"
  end

  if self.settings.burnIngredient and itemTrade == 5 and quality == 1 and itemPrice == 1 then
    return true, "R106"
  end

  -- Удаление лишних отмычек
  if self.settings.burnLockpick and itemId == 30357 and itemQuantity == 1 and GetItemLinkStacks(itemLink) >= 200 * self.settings.burnLockpickStackSaved then
    return true, "R107"
  end

  if self.settings.burnBait and itemType == 16 and itemSpecialType == 750 and GetItemLinkStacks(itemLink) >= 200 * self.settings.burnBaitStackSaved then
    return true, "R108"
  end

  if self.settings.burnCommonGlyph and (itemType == 20 or itemType == 21 or itemType == 26) and stackCountChange == 1 and IsItemLinkCrafted(itemLink) == false and quality == 1 then
    return true, "R109"
  end

  if self.settings.burnRunePotency and itemType == 51 and stackCountChange <= self.settings.maxBurnedStack and itemEx2 ~= 10 then
    return true, "R110"
  end

  if self.settings.burnRuneEssence and itemType == 53 and stackCountChange <= self.settings.maxBurnedStack and self.HasValue(self.savedItems, itemId) == false then
    if self.settings.saveRuneEssenceForDaily and self.HasValue(self.dailyRunes, itemId) then
      return false, "R111"
    end
    return true, "R112"
  end

  if self.settings.burnJunk and itemSpecialType == SPECIALIZED_ITEMTYPE_TRASH and itemPrice == 1 then
    return true, "R113"
  end

  if (self.settings.burnRaceMotif >= 1 and self.HasValue(self.trashRaceMotif, itemId)) or (self.settings.burnRaceMotif == 2 and self.HasValue(self.trashRaceRareMotif, itemId)) then
    if self.settings.autoLearnRaceMotif and isNewMotif then
      if CallSecureProtected("UseItem", bagIndex, slotIndex) then
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SHOW_BOOK, self.CloseMotifBook)
      end
    else
      return true, "R114"
    end
  end

  return false, "R0"
end


function LootSanitizer:IsItemShouldBeMarkedAsJunk(bagIndex, slotIndex)
  local itemLink = GetItemLink(bagIndex, slotIndex)

  -- Don't do anything with Crown and Crafted items
  local isCrownCrate = IsItemFromCrownCrate(bagIndex, slotIndex)
  local isCrownStore = IsItemFromCrownStore(bagIndex, slotIndex)
  local isItemCrafted = IsItemLinkCrafted(itemLink) or GetItemCreatorName(bagIndex, slotIndex) ~= ""
  if isCrownCrate or isCrownStore or isItemCrafted then
    return false, "R1"
  end

  -- User Blacklist
  local isItemInJunkList = self.HasValue(self.settings.listOfJunk, itemLink)
  if isItemInJunkList then
    return true, "R100"
  end

  -- Get additional info
  local itemIcon, itemQuantity, itemPrice, meetsUsageRequirement, locked, equipType, itemStyle, itemRarity, displayQuality = GetItemInfo(bagIndex, slotIndex)
  local itemTrait = GetItemTrait(bagIndex, slotIndex)
  local itemType, itemSpecialType = GetItemType(bagIndex, slotIndex)
  local itemTrade, _, _, itemEx2, _ = GetItemCraftingInfo(bagIndex, slotIndex)
  local itemReqSkillRank = GetItemLinkRequiredCraftingSkillRank(itemLink)

  -- Get Item users
  local isCompanionItem = GetItemActorCategory(bagIndex, slotIndex) == GAMEPLAY_ACTOR_CATEGORY_COMPANION
  local isPlayerEquip = false
  if isCompanionItem == false and ((equipType == EQUIP_TYPE_RING or equipType == EQUIP_TYPE_NECK) or (itemSpecialType == SPECIALIZED_ITEMTYPE_WEAPON or itemSpecialType == SPECIALIZED_ITEMTYPE_ARMOR)) then
    isPlayerEquip = true
  end

  -- Get additional traits info
  local isUnknownTrait = false
  local isInspirationTrait = false
  local traitType, traitDescription = GetItemLinkTraitInfo(itemLink)
  if traitType ~= ITEM_TRAIT_TYPE_NONE and traitDescription ~= "" then
    local traitInformation = GetItemTraitInformationFromItemLink(itemLink)
    isUnknownTrait = traitInformation == 1
    isInspirationTrait = traitInformation == 3
  end

  -- Not part of Sets
  local hasSet, setName, numBonuses, numNormalEquipped, maxEquipped, setId, numPerfectedEquipped = GetItemLinkSetInfo(itemLink)
  if self.settings.junkNormalEquipment and isPlayerEquip and hasSet == false then
    if not isUnknownTrait and not isInspirationTrait then
      return true, "R101"
    end
  end

  -- Items for selling
  if self.settings.junkOrnateEquipment and (itemTrait == 10 or itemTrait == 19 or itemTrait == 24) then
    return true, "R102"
  end

  -- Materials and raws for mid-level craft skills
  local function getTradeSkillData(table, bagIndex, slotIndex)
    local tradeSkillType, itemType, itemEx1, itemEx2, itemEx3 = GetItemCraftingInfo(bagIndex, slotIndex)
    local tradeSkillLineId = GetTradeskillLevelPassiveAbilityId(tradeSkillType)
    local tradeSkillLineName = GetAbilityName(tradeSkillLineId)
    local currentUpgradeLevel, maxUpgradeLevel
    if tradeSkillLineName ~= "" then
      local _rank_, _advised_, _active_, _discovered_= GetSkillLineDynamicInfo(skillType)
      local skillType, skillLineIndex, skillIndex, morphChoice, rank = GetSpecificSkillAbilityKeysByAbilityId(tradeSkillLineId)
      currentUpgradeLevel, maxUpgradeLevel = GetSkillAbilityUpgradeInfo(skillType, skillLineIndex, skillIndex)
    end

    table.name = tradeSkillLineName
    table.curRank = currentUpgradeLevel
    table.maxRank = maxUpgradeLevel
    table.materialReqRank = itemEx1
    table.materialReqLevel = itemEx2
  end

  local relTradeSkill = {}
  if itemTrade ~= CRAFTING_TYPE_INVALID then
    getTradeSkillData(relTradeSkill, bagIndex, slotIndex)
  end

  local isRawMaterial = itemType == 35 or itemType == 37 or itemType == 39 or itemType == 63
  local isMaterial = itemType == 36 or itemType == 38 or itemType == 40 or itemType == 64
  if self.settings.junkMiddleRawAndMaterial and (isRawMaterial or isMaterial) and relTradeSkill.maxRank and itemReqSkillRank > 1 and itemReqSkillRank < relTradeSkill.maxRank then
    return true, "R103"
  end

  -- Not crafted food
  if self.settings.junkNotCraftedFood and itemType == 4 and itemRarity < 3 then
    return true, "R104"
  end

  -- Not crafted drink
  if self.settings.junkNotCraftedDrink and itemType == 12 and itemRarity < 3 then
    return true, "R105"
  end

  -- Not crafted potion
  if self.settings.junkNotCraftedPotion and itemType == 7 and itemRarity < 3 then
    return true, "R106"
  end

  -- Not crafted poison
  if self.settings.junkNotCraftedPoison and itemType == 30 and itemRarity < 3 then
    return true, "R107"
  end

  -- Potion solvent of any level
  if self.settings.junkPotionSolvent and itemType == 33 then
    return true, "R108"
  end

  -- Poison solvent of any level
  if self.settings.junkPoisonSolvent and itemType == 58 then
    return true, "R109"
  end

  -- Trash items
  if self.settings.junkTrashItem and itemType == 48 then
    return true, "R110"
  end

  -- Treasure items
  if self.settings.junkTreasureItem and itemType == 56 then
    return true, "R111"
  end

  -- Rare fish
  if self.settings.junkRareFish and itemSpecialType == 80 then
    return true, "R112"
  end

  -- Monster trophy
  if self.settings.junkMonsterTrophy and itemSpecialType == 81 then
    return true, "R113"
  end

  return false, "R0"
end


function LootSanitizer:IsItemShouldBeBinded(bagIndex, slotIndex)
  local itemLink = GetItemLink(bagIndex, slotIndex)

  if IsItemLinkSetCollectionPiece(itemLink) then
    -- Get additional info
    local itemId = GetItemLinkItemId(itemLink)
    local _, _, _, _, _, _, _, quality, displayQuality = GetItemInfo(bagIndex, slotIndex)
    local itemRarity = displayQuality or quality

    if not IsItemSetCollectionPieceUnlocked(itemId) then
      if self.settings.autoBindQuality > 0 and itemRarity <= self.settings.autoBindQuality and not IsItemBoPAndTradeable(bagIndex, slotIndex) then
        return true, "R3" -- addon settings allow binding
      end
      return false, "R2" -- addon settings disallow binding
    end
    return false, "R1" -- already binded
  end
  return false, "R0" -- can't be binded
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

  -- Get Name for Chat Notifications
  local itemName = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemName(bagIndex, slotIndex))

  -- Get Additional Info for Burn Conditions
  local itemLink = GetItemLink(bagIndex, slotIndex)
  local _, _, itemPrice, _, _, itemEquipType, itemStyle, _, displayQuality = GetItemInfo(bagIndex, slotIndex)
  local itemType, itemSpecialType = GetItemType(bagIndex, slotIndex)

  -- Collection Status
  local isShouldBeBinded, bindReason = LootSanitizer:IsItemShouldBeBinded(bagIndex, slotIndex)
  if isShouldBeBinded then
    BindItem(bagIndex, slotIndex)
    LootSanitizer:Message(itemLink, "bind")
  end

  -- isItemTracked
  local isItemTracked = false
  if ESOMRL and ESOMRL.ISMRLTracking(itemLink) then
    isItemTracked = true
  end

  -- isStyleMaterialTracked
  local isStyleMaterialTracked = false
  local itemStyleMaterialLink = GetItemStyleMaterialLink(itemStyle)
  if ESOMRL and ESOMRL.ISMRLTracking(itemStyleMaterialLink) then
    isStyleMaterialTracked = true
  end

  -- isCompanionItem
  local isCompanionItem = false
  if GetItemLinkActorCategory(itemLink) == GAMEPLAY_ACTOR_CATEGORY_COMPANION then
    isCompanionItem = true
  end

  -- isPlayerEquip
  local isPlayerEquip = false
  if isCompanionItem == false and ((itemEquipType == EQUIP_TYPE_RING or itemEquipType == EQUIP_TYPE_NECK) or (itemSpecialType == SPECIALIZED_ITEMTYPE_WEAPON or itemSpecialType == SPECIALIZED_ITEMTYPE_ARMOR)) then
    isPlayerEquip = true
  end



  -- BURN
  local isJunk, junkReason = false, false
  local isBurn, burnReason = LootSanitizer:IsItemShouldBeDestroed(bagIndex, slotIndex, stackCountChange)
  if isBurn then
    if not IsShiftKeyDown() and not isItemTracked and (not isPlayerEquip and not isStyleMaterialTracked) then
      LootSanitizer:Message(itemLink)
      LootSanitizer:DestroyItem(bagIndex, slotIndex)
      LootSanitizer:UpdateStats(itemPrice * stackCountChange)
    elseif burnReason == "R101" then
      LootSanitizer:Message(itemLink)
      LootSanitizer:DestroyItem(bagIndex, slotIndex)
      LootSanitizer:UpdateStats(itemPrice * stackCountChange)
    end
  else
    -- JUNK
    isJunk, junkReason = LootSanitizer:IsItemShouldBeMarkedAsJunk(bagIndex, slotIndex)
  end
  if LootSanitizer.settings.chatMode == 2 and isBurn then
    if IsShiftKeyDown() then
      d(zo_strformat("[<<1>>] Holding Shift prevents destroying of <<2>>.", GetString(SI_LOOTSANITIZER_NAME), itemName))
    elseif isItemTracked then
      d(zo_strformat("[<<1>>] Item not burned coz <<2>> is tracked by addon MRL.", GetString(SI_LOOTSANITIZER_NAME), itemName))
    elseif isPlayerEquip and isStyleMaterialTracked then
      d(zo_strformat("[<<1>>] Item not burned coz style material of <<2>> is tracked by addon MRL.", GetString(SI_LOOTSANITIZER_NAME), itemName))
    end
  end
  if LootSanitizer.settings.chatMode == 2 and burnReason ~= "R0" then
    d(zo_strformat("[<<1>>] Is <<2>> should be destored: <<3>>. Reason: <<4>>.", GetString(SI_LOOTSANITIZER_NAME), itemName, tostring(isBurn), burnReason))
  end



  -- JUNK
  if isJunk then
    LootSanitizer:SetItemJunk(bagIndex, slotIndex)
  end
  if LootSanitizer.settings.chatMode == 2 and junkReason ~= "R0" then
    d(zo_strformat("[<<4>>] Is <<1>> junk: <<2>>. Reason: <<3>>.", itemName, tostring(isJunk), junkReason, GetString(SI_LOOTSANITIZER_NAME)))
  end

end



-- Sounds
-- SKILL_PURCHASED / BOOK_ACQUIRED / LOCKPICKING_BREAK
function LootSanitizer:DestroyItem(bagIndex, slotIndex)
  DestroyItem(bagIndex, slotIndex)
  PlaySound(SOUNDS.INVENTORY_DESTROY_JUNK)
end
-- SKILL_PURCHASED / BOOK_ACQUIRED / LOCKPICKING_BREAK
function LootSanitizer:SetItemJunk(bagIndex, slotIndex)
  SetItemIsJunk(bagIndex, slotIndex, true)
  PlaySound(SOUNDS.INVENTORY_ITEM_UNJUNKED)
end

function LootSanitizer:CloseMotifBook()
  local function callMeToo()
    d("Book should be closed: " ..  GetTimeString())
    EndInteraction(INTERACTION_BOOK)
  end
  d("Waiting for book interaction: " ..  GetTimeString())
  EVENT_MANAGER:UnregisterForEvent(LootSanitizer.name, EVENT_SHOW_BOOK)
  zo_callLater(callMeToo, 500)
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
      return true, index
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

SLASH_COMMANDS["/lslist"] = function(list)
  LootSanitizer:writeList(list)
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
