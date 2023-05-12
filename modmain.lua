AddComponentPostInit("edible", function(self)
     function self:GetHealth(eater)
        local multiplier = 1
        local healthvalue = self.gethealthfn ~= nil and self.gethealthfn(self.inst, eater) or self.healthvalue
        local spice_source = self.spice

        if healthvalue > 0 or multiplier == 0 then
            return 0
        end
    
        local ignore_spoilage = not self.degrades_with_spoilage or healthvalue < 0 or (eater ~= nil and eater.components.eater ~= nil and eater.components.eater.ignoresspoilage)
    
        if not ignore_spoilage and self.inst.components.perishable ~= nil then
            if self.inst.components.perishable:IsStale() then
                multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.stale_health or self.stale_health
            elseif self.inst.components.perishable:IsSpoiled() then
                multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.spoiled_health or self.spoiled_health
                spice_source = nil
            end
        end
    
        if spice_source and TUNING.SPICE_MULTIPLIERS[spice_source] and TUNING.SPICE_MULTIPLIERS[spice_source].HEALTH then
            multiplier = multiplier + TUNING.SPICE_MULTIPLIERS[spice_source].HEALTH
        end
    
        return multiplier * healthvalue
    end
end)
