class 'VEManagerClient'

local m_Logger = Logger("VEManagerClient", false)

-- Default Dynamic day-night cycle Presets
night = require "Presets/DefaultNight"
morning = require "Presets/DefaultMorning"
noon = require "Presets/DefaultNoon"
evening = require "Presets/DefaultEvening"
ve_cinematic_tools = require "Presets/CustomPreset"

function VEManagerClient:__init()
	m_Logger:Write('Initializing VEManagerClient')
	self:RegisterVars()
	self:RegisterEvents()
	self:RegisterModules()
end

function VEManagerClient:RegisterVars()
	self.m_RawPresets = {}
	self.m_RawPresets["CinematicTools"] = json.decode(ve_cinematic_tools:GetPreset()) -- TODO: Remove when you can change presets from tools
	self.m_RawPresets["DefaultNight"] = json.decode(night:GetPreset())
	self.m_RawPresets["DefaultMorning"] = json.decode(morning:GetPreset())
	self.m_RawPresets["DefaultNoon"] = json.decode(noon:GetPreset())
	self.m_RawPresets["DefaultEvening"] = json.decode(evening:GetPreset())
    self.m_SupportedTypes = {"Vec2", "Vec3", "Vec4", "Float32", "Boolean", "Int"}
	self.m_SupportedClasses = {
		"CameraParams",
		"CharacterLighting",
		"ColorCorrection",
		"DamageEffect",
		"Dof",
		"DynamicAO",
		"DynamicEnvmap",
		"Enlighten",
		"FilmGrain",
		"Fog",
		"LensScope",
		"MotionBlur",
		"OutdoorLight",
		"PlanarReflection",
		"ScreenEffect",
		"Sky",
		"SunFlare",
		"Tonemap",
		"Vignette",
		"Wind"}
	self.m_Presets = {}
	self.m_Lerping = {}
	self.m_Instances = {}
	self.m_VisibilityUpdateThreshold = 0.000001
end

function VEManagerClient:RegisterEvents()
	self.m_OnUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
	Events:Subscribe('Level:Destroy', self, self.OnLevelDestroy)

	Events:Subscribe('VEManager:RegisterPreset', self, self.RegisterPreset)
	Events:Subscribe('VEManager:EnablePreset', self, self.EnablePreset)
	Events:Subscribe('VEManager:DisablePreset', self, self.DisablePreset)
	Events:Subscribe('VEManager:SetVisibility', self, self.SetVisibility)
	Events:Subscribe('VEManager:UpdateVisibility', self, self.UpdateVisibility)
	Events:Subscribe('VEManager:FadeIn', self, self.FadeIn)
	Events:Subscribe('VEManager:FadeTo', self, self.FadeTo)
	Events:Subscribe('VEManager:FadeOut', self, self.FadeOut)
	Events:Subscribe('VEManager:Lerp', self, self.Lerp)
	Events:Subscribe('VEManager:Crossfade', self, self.Crossfade)
end

function VEManagerClient:RegisterModules()
	easing = require "Modules/Easing"
	require 'Modules/Time'
	require '__shared/DebugGUI'
	require 'DebugGui'
	require 'Modules/CinematicTools'
end


--[[

	User Functions

]]

function VEManagerClient:RegisterPreset(p_ID, p_Preset)
	self.m_RawPresets[p_ID] = json.decode(p_Preset)
end

function VEManagerClient:EnablePreset(p_ID)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	m_Logger:Write("Enabling preset: " .. tostring(p_ID))
	self.m_Presets[p_ID]["logic"].visibility = 1
	self.m_Presets[p_ID]["ve"].visibility = 1
	self.m_Presets[p_ID]["ve"].enabled = true
	self.m_Presets[p_ID].entity:FireEvent("Enable")
end

function VEManagerClient:DisablePreset(p_ID)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	m_Logger:Write("Disabling preset: " .. tostring(p_ID))
	self.m_Presets[p_ID]["logic"].visibility = 1
	self.m_Presets[p_ID]["ve"].visibility = 0
	self.m_Presets[p_ID]["ve"].enabled = false
	self.m_Presets[p_ID].entity:FireEvent("Disable")
end

function VEManagerClient:SetVisibility(p_ID, p_Visibility)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	self.m_Presets[p_ID]["logic"].visibility = p_Visibility
	self.m_Presets[p_ID]["ve"].visibility = p_Visibility

	self:Reload(p_ID)
end

function VEManagerClient:UpdateVisibility(p_ID, p_Priority, p_Visibility)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	if math.abs(self.m_Presets[p_ID]["logic"].visibility - p_Visibility) < self.m_VisibilityUpdateThreshold then
		return
	end

	self.m_Presets[p_ID]["logic"].visibility = p_Visibility
	self.m_Presets[p_ID]["ve"].visibility = p_Visibility

	local s_States = VisualEnvironmentManager:GetStates()
	local s_FixedPriority = 10000000 + p_Priority

	for _, l_State in pairs(s_States) do
		if l_State.priority == s_FixedPriority then
			l_State.visibility = p_Visibility
			VisualEnvironmentManager:SetDirty(true)
			return
		end
	end
end

function VEManagerClient:SetSingleValue(p_ID, p_Priority, p_Class, p_Property, p_Value)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	local s_States = VisualEnvironmentManager:GetStates()
	local s_FixedPriority = 10000000 + p_Priority

	for _, l_State in pairs(s_States) do
		if l_State.priority == s_FixedPriority then
			l_State[p_Class][p_Property] = p_Value
			VisualEnvironmentManager:SetDirty(true)
			return
		end
	end
end

function VEManagerClient:FadeIn(p_ID, p_Time)
	self:FadeTo(p_ID, 0, 1, p_Time)
end

function VEManagerClient:FadeOut(p_ID, p_Time)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	local s_VisibilityStart = self.m_Presets[p_ID]["logic"].visibility
	self:FadeTo(p_ID, s_VisibilityStart, 0, p_Time)
end

function VEManagerClient:FadeTo(p_ID, p_VisibilityStart, p_VisibilityEnd, p_Time)
	if self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	self.m_Presets[p_ID]['time'] = tonumber(p_Time)
	self.m_Presets[p_ID]['startTime'] = SharedUtils:GetTimeMS()
	self.m_Presets[p_ID]['startValue'] = tonumber(p_VisibilityStart)
	self.m_Presets[p_ID]['EndValue'] = tonumber(p_VisibilityEnd)
	self.m_Lerping[#self.m_Lerping + 1] = p_ID
end


function VEManagerClient:Lerp(p_ID, p_Value, p_Time)
	if p_ID == nil then
		error("The preset name provided is nil.")
		return
	elseif self.m_Presets[p_ID] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(p_ID))
		return
	end

	self.m_Presets[p_ID]['time'] = p_Time
	self.m_Presets[p_ID]['startTime'] = SharedUtils:GetTimeMS()
	self.m_Presets[p_ID]['startValue'] = self.m_Presets[p_ID]["logic"].visibility
	self.m_Presets[p_ID]['EndValue'] = p_Value

	self.m_Lerping[#self.m_Lerping +1] = p_ID
end

--[[function VEManagerClient:Crossfade(id1, id2, time)
	if self.m_Presets[id1] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(id1))
		return
	elseif self.m_Presets[id2] == nil then
		error("There isn't a preset with this id or it hasn't been parsed yet. Id: ".. tostring(id2))
		return
	end

	self:FadeTo(id1, self.m_Presets[id2]["logic"].visibility, time) -- Fade id1 to id2 visibility
	self:FadeTo(id2, self.m_Presets[id1]["logic"].visibility, time) -- Fade id2 to id1 visibility

end]]


--[[

	Internal functions

]]

function VEManagerClient:GetState(...)
	--Get all visual environment states
	local s_Args = { ... }
	local s_States = VisualEnvironmentManager:GetStates()

	--Loop through all states
	for _, l_State in pairs(s_States) do

		for l_Index, l_Priority in pairs(s_Args) do

			if l_State.priority == l_Priority then
				return l_State
			end
		end
	end
	return nil
end

function VEManagerClient:InitializePresets()
	m_Logger:Write("Spawned Presets:")
	for l_Index, l_Preset in pairs(self.m_Presets) do
		l_Preset["entity"] = EntityManager:CreateEntity(l_Preset["logic"], LinearTransform())

		if l_Preset["entity"] == nil then
			m_Logger:Write("- " .. tostring(l_Index) .. ", could not be spawned.")
			return
		end

		l_Preset["entity"]:Init(Realm.Realm_Client, true)
		VisualEnvironmentManager:SetDirty(true)

		m_Logger:Write("- " .. tostring(l_Index))
	end
end

function VEManagerClient:Reload(p_ID)
	self.m_Presets[p_ID].entity:FireEvent("Disable")
	self.m_Presets[p_ID].entity:FireEvent("Enable")
end

function VEManagerClient:LoadPresets()
	m_Logger:Write("Loading presets... (Name, Type, Priority)")
	--Foreach preset
	for l_Index, l_Preset in pairs(self.m_RawPresets) do

		-- Variables check
		if l_Preset.Name == nil then
			l_Preset.Name = 'Unknown_Preset_' .. tostring(#self.m_Presets)
		end

		if l_Preset.Type == nil then
			l_Preset.Type = 'generic'
		end

		if l_Preset.Priority == nil then
			l_Preset.Priority = 1
		else
			l_Preset.Priority = tonumber(l_Preset.Priority)
			-- Restrict using day-night cycle priorities
			-- TODO: This should be somehow adjusted to the new dynamic system
			if l_Preset.Priority >= 11 and l_Preset.Priority <= 14 then
				l_Preset.Priority = l_Preset.Priority + 5
			end
		end

		-- Generate our VisualEnvironment
		local s_IsBasePreset = l_Preset.Priority == 1

		--Not sure if we need the LogicelVEEntity, but :shrug:
		local s_LVEED = self:CreateEntity("LogicVisualEnvironmentEntityData")
		self.m_Presets[l_Preset.Name] = {}
		self.m_Presets[l_Preset.Name]["logic"] = s_LVEED
		s_LVEED.visibility = 1

		local s_VEB = self:CreateEntity("VisualEnvironmentBlueprint")
		s_VEB.name = l_Preset.Name
		s_LVEED.visualEnvironment = s_VEB
		self.m_Presets[l_Preset.Name]["blueprint"] = s_VEB

		local s_VE = self:CreateEntity("VisualEnvironmentEntityData")
		s_VEB.object = s_VE

		m_Logger:Write("- " .. l_Preset.Name .. ", " .. l_Preset.Type .. ", " .. tostring(l_Preset.Priority))

		s_VE.enabled = true
		s_VE.priority = l_Preset.Priority
		s_VE.visibility = 1

		self.m_Presets[l_Preset.Name]["ve"] = s_VE
		self.m_Presets[l_Preset.Name]["type"] = l_Preset.Type

		--Foreach class
		local s_ComponentCount = 0
		for _, l_Class in pairs(self.m_SupportedClasses) do
			if l_Preset[l_Class] ~= nil  then

				-- Create class and add it to the VE entity.
				local s_Class =  _G[l_Class.."ComponentData"]()
				
				s_Class.excluded = false
				s_Class.isEventConnectionTarget = 3
				s_Class.isPropertyConnectionTarget = 3
				s_Class.indexInBlueprint = s_ComponentCount
				s_Class.transform = LinearTransform()

				-- Foreach field in class
				for _, l_Field in ipairs(s_Class.typeInfo.fields) do
					-- Fix lua types
					local s_FieldName = l_Field.name

					if s_FieldName == "End" then
						s_FieldName = "EndValue"
					end

					-- Get type
					local s_Type = l_Field.typeInfo.name --Boolean, Int32, Vec3 etc.
					-- print("Field: " .. tostring(s_FieldName) .. " | " .. " Type: " .. tostring(s_Type))
					
					-- Initialize value
					local s_Value = nil

					-- If the preset contains that field
					if l_Preset[l_Class][s_FieldName] ~= nil then
						
						if IsBasicType(s_Type) then
							s_Value = self:ParseValue(s_Type, l_Preset[l_Class][s_FieldName])
						
						elseif l_Field.typeInfo.enum then
							s_Value = tonumber(l_Preset[l_Class][s_FieldName])
						
						elseif s_Type == "TextureAsset" then
							s_Value = self:GetSavedTexture(l_Preset[l_Class][s_FieldName])
							if s_Value == nil then
								m_Logger:Write("\t- TextureAsset has not been saved (" .. l_Preset[l_Class][s_FieldName] .. " | " .. tostring(l_Class) .. " | " .. tostring(s_FieldName) .. ")")
							end
						
						elseif l_Field.typeInfo.array then
							error("\t- Found unexpected array") -- TODO: Instead of error (that breaks the code), a continue should be used (unfortunately with goto), or set an "errorFound" true/false parameter to true and skip the component addition
							return
						
						else
							error("\t- Found unexpected DataContainer: " .. s_Type) -- TODO: Instead of error (that breaks the code), a continue should be used (unfortunately with goto), or set an "errorFound" true/false parameter to true and skip the component addition
							return
						end
						
						-- Set value
						if s_Value ~= nil then
							s_Class[firstToLower(s_FieldName)] = s_Value
						end
					end
					
					-- If not in the preset or incorrect value
					if s_Value == nil then

						-- Try to get original value
						-- m_Logger:Write("Setting default value for field " .. s_FieldName .. " of class " .. l_Class .. " | " ..  tostring(s_Value))
						s_Value = self:GetDefaultValue(l_Class, l_Field)

						if s_Value == nil then
							m_Logger:Write("\t- Failed to fetch original value: " .. tostring(l_Class) .. " | " .. tostring(s_FieldName))
							
							if s_FieldName == "FilmGrain" then -- fix FilmGrain texture
								m_Logger:Write("\t\t- Fixing value for field " .. s_FieldName .. " of class " .. l_Class .. " | " ..  tostring(s_Value))
								s_Class[firstToLower(s_FieldName)] = TextureAsset(ResourceManager:FindInstanceByGuid(Guid'44AF771F-23D2-11E0-9C90-B6CDFDA832F1', Guid('1FD2F223-0137-2A0F-BC43-D974C2BD07B4')))
							end
						else
							-- Applying original value
							if IsBasicType(s_Type) then
								s_Class[firstToLower(s_FieldName)] = s_Value
							
							elseif l_Field.typeInfo.enum then
								s_Class[firstToLower(s_FieldName)] = tonumber(s_Value)
							
							elseif s_Type == "TextureAsset" then
								s_Class[firstToLower(s_FieldName)] = TextureAsset(s_Value)

							elseif l_Field.typeInfo.array then
								m_Logger:Write("\t- Found unexpected array, ignoring")
							
							else
								-- Its a DataContainer
								s_Class[firstToLower(s_FieldName)] = _G[s_Type](s_Value)
							end
						end
					end
				end
				s_ComponentCount = s_ComponentCount + 1
				s_VE.components:add(s_Class)
			end
		end
		s_VE.runtimeComponentCount = s_ComponentCount
		s_VE.visibility = 0
		s_VE.enabled = false
		s_LVEED.visibility = 0
	end
	self:InitializePresets()
	Events:Dispatch("VEManager:PresetsLoaded")
	m_Logger:Write("Presets loaded")
end


function VEManagerClient:OnLevelLoaded(p_MapPath, p_GameModeName)
	self:LoadPresets()
end

function VEManagerClient:OnLevelDestroy()
	self:RegisterVars()
	collectgarbage('collect')
end

function VEManagerClient:GetDefaultValue(p_Class, p_Field)
	if p_Field.typeInfo.enum then

		if p_Field.typeInfo.name == "Realm" then
			return Realm.Realm_Client
		else
			m_Logger:Write("\t- Found unhandled enum, " .. p_Field.typeInfo.name)
			return
		end
	end

	local s_States = VisualEnvironmentManager:GetStates()

	for i, l_State in ipairs(s_States) do
		--m_Logger:Write(">>>>>> state:" .. l_State.entityName)

		if l_State.entityName == "Levels/Web_Loading/Lighting/Web_Loading_VE" then
			goto continue
		
		elseif l_State.entityName ~= 'EffectEntity' then
			local s_Class = l_State[firstToLower(p_Class)] --colorCorrection

			if s_Class == nil then
				goto continue
			end

			--print("Sending default value: " .. tostring(p_Class) .. " | " .. tostring(p_Field.typeInfo.name) .. " | " .. tostring(s_Class[firstToLower(p_Field.typeInfo.name)]) .. " (" .. tostring(type(s_Class[firstToLower(p_Field.typeInfo.name)])) .. ")")
			-- print(tostring(s_Class[firstToLower(p_Field.name)]) .. ' | ' .. tostring(p_Field.typeInfo.name))
			return s_Class[firstToLower(p_Field.name)] --colorCorrection Contrast
		end

		::continue::
	end
end

-- This one is a little dirty.
function VEManagerClient:CreateEntity(p_Class, p_Guid)
	-- Create the instance
	local s_Entity = _G[p_Class]()

	if p_Guid == nil then
		-- Clone the instance and return the clone with a randomly generated Guid
		return _G[p_Class](s_Entity:Clone(GenerateGuid()))
	else
		return _G[p_Class](s_Entity:Clone(p_Guid))
	end
end

function VEManagerClient:UpdateLerp(percentage)
	for i,preset in pairs(self.m_Lerping) do

		local TimeSinceStarted = SharedUtils:GetTimeMS() - self.m_Presets[preset].startTime
		local PercentageComplete = TimeSinceStarted / self.m_Presets[preset].time
		--local lerpValue = self.m_Presets[preset].startValue + (self.m_Presets[preset].EndValue - self.m_Presets[preset].startValue) * PercentageComplete

		-- t = elapsed time
		-- b = begin
		-- c = change == ending - beginning
		-- d = duration (total time)
		local t = TimeSinceStarted
		local b = self.m_Presets[preset].startValue
		local c = self.m_Presets[preset].EndValue - self.m_Presets[preset].startValue
		local d = self.m_Presets[preset].time

		local transition = "linear"
		if(self.m_Presets[preset].transition ~= nil) then
			transition = self.m_Presets[preset].transition
		end

		local lerpValue = easing[transition](t,b,c,d)

		if(PercentageComplete >= 1 or PercentageComplete < 0) then
			self:SetVisibility(preset, self.m_Presets[preset].EndValue)
			self.m_Lerping[i] = nil
		else
			self:SetVisibility(preset, lerpValue)
		end
	end
end

function VEManagerClient:SetLerpPriority(id) -- remove
	if self.m_Presets[id].type ~= 'Time' then
		return
	end
end

function VEManagerClient:OnUpdateInput(p_Delta, p_SimulationDelta)

	if VEM_CONFIG.DEV_ENABLE_TEST_KEYS then

		if InputManager:WentKeyDown(VEM_CONFIG.DEV_SHOW_HIDE_CINEMATIC_TOOLS_KEY) then

			if g_CinematicTools.m_Visible == true then 
				g_CinematicTools:HideUI()
			else
				g_CinematicTools:ShowUI()
			end
		end
	end

	if #self.m_Lerping > 0 then
		self:UpdateLerp(p_Delta)
	end
end


--[[

	Utils

]]


function VEManagerClient:ParseValue(p_Type, p_Value)
	-- This separates Vectors. Let's just do it to everything, who cares?
	if p_Type == "Boolean" then
		if p_Value == "true" then
			return true
		else
			return false
		end
	elseif p_Type == "CString" then
		return tostring(p_Value)

	elseif  p_Type == "Float8" or
			p_Type == "Float16" or
			p_Type == "Float32" or
			p_Type == "Float64" or
			p_Type == "Int8" or
			p_Type == "Int16" or
			p_Type == "Int32" or
			p_Type == "Int64" or
			p_Type == "Uint8" or
			p_Type == "Uint16" or
			p_Type == "Uint32" or
			p_Type == "Uint64" then
		return tonumber(p_Value)

	elseif p_Type == "Vec2" then -- Vec2
		local s_Vec = HandleVec(p_Value)
		return Vec2(tonumber(s_Vec[1]), tonumber(s_Vec[2]))

	elseif p_Type == "Vec3" then -- Vec3
		local s_Vec = HandleVec(p_Value)
		return Vec3(tonumber(s_Vec[1]), tonumber(s_Vec[2]), tonumber(s_Vec[3]))

	elseif p_Type == "Vec4" then -- Vec4
		local s_Vec = HandleVec(p_Value)
		return Vec4(tonumber(s_Vec[1]), tonumber(s_Vec[2]), tonumber(s_Vec[3]), tonumber(s_Vec[4]))
	
	else
		m_Logger:Write("Unhandled type: " .. p_Type)
		return nil
	end
end

function VEManagerClient:GetSavedTexture(p_Value)
	-- Check if Texture has been saved
	if _G['g_textureAssets'][p_Value:lower()] then
		return TextureAsset(_G['g_textureAssets'][p_Value:lower()])
	end

	return
end

function h()
	local vars = {"A","B","C","D","E","F","0","1","2","3","4","5","6","7","8","9"}
	return vars[math.floor(MathUtils:GetRandomInt(1,16))]..vars[math.floor(MathUtils:GetRandomInt(1,16))]
end

function GenerateGuid()
	return Guid(h()..h()..h()..h().."-"..h()..h().."-"..h()..h().."-"..h()..h().."-"..h()..h()..h()..h()..h()..h(), "D")
end

function HandleVec(vec)
	local s_fixedContents = string.gsub(vec, "%(", "")
	s_fixedContents = string.gsub(s_fixedContents, "%)", "")
	s_fixedContents = string.gsub(s_fixedContents, ", ", ":")
	return split(s_fixedContents, ":")
end

function firstToUpper(str)
	return (str:gsub("^%U", string.upper))
end

function firstToLower(str)
	return (str:gsub("^%L", string.lower))
end

function split(pString, pPattern)
	local Table = {} -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	return Table
end

function dump(o)

	if(o == nil) then
		m_Logger:Write("tried to load jack shit")
	end

	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function IsBasicType( typ )
	if typ == "CString" or
	typ == "Float8" or
	typ == "Float16" or
	typ == "Float32" or
	typ == "Float64" or
	typ == "Int8" or
	typ == "Int16" or
	typ == "Int32" or
	typ == "Int64" or
	typ == "Uint8" or
	typ == "Uint16" or
	typ == "Uint32" or
	typ == "Uint64" or
	typ == "LinearTransform" or
	typ == "Vec2" or
	typ == "Vec3" or
	typ == "Vec4" or
	typ == "Boolean" or
	typ == "Guid" then
		return true
	end
	return false
end

-- Singleton.
if g_VEManagerClient == nil then
	g_VEManagerClient = VEManagerClient()
end

return g_VEManagerClient