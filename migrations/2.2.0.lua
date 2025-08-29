---
--- Migration script for wind_turbine data structure refactoring
--- Converts array-based structure to named field structure

local function migrate_wind_turbine_structure()
    if not storage.wind_turbines then
        log("No wind_turbines data found, skipping migration")
        return
    end
    
    local migrated_count = 0
    local total_count = 0
    
    for registration_number, wind_turbine in pairs(storage.wind_turbines) do
        total_count = total_count + 1
        
        -- Check if this is the old array format
        -- Old format: {entity, name, position, surface}
        -- New format: {entity = entity, name = name, position = position, surface = surface}
        if type(wind_turbine) == "table" and 
           wind_turbine[1] and -- has entity at index 1
           wind_turbine[2] and -- has name at index 2
           wind_turbine[3] and -- has position at index 3
           wind_turbine[4] and -- has surface at index 4
           not wind_turbine.entity then -- doesn't have named 'entity' field
            
            log("Migrating wind_turbine with registration_number: " .. tostring(registration_number))
            
            -- Convert to new named field structure
            local migrated_turbine = {
                entity = wind_turbine[1],
                name = wind_turbine[2],
                position = wind_turbine[3],
                surface = wind_turbine[4]
            }
            
            -- Replace the old structure with the new one
            storage.wind_turbines[registration_number] = migrated_turbine
            migrated_count = migrated_count + 1
            
        elseif type(wind_turbine) == "table" and wind_turbine.entity then
            -- Already in new format, no migration needed
            log("wind_turbine with registration_number " .. tostring(registration_number) .. " already in new format")
        else
            log("WARNING: Invalid wind_turbine structure found at registration_number: " .. tostring(registration_number))
        end
    end
    
    log("Migration completed: " .. migrated_count .. " out of " .. total_count .. " wind_turbines migrated")
end

-- Execute migration
log("start migration to 2.2.0")
migrate_wind_turbine_structure()
log("migration to 2.2.0 finished")
