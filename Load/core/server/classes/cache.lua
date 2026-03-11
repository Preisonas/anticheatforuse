-- Create a new cache object
-- @param keyLock | string | a type to do internal type checking on or any to skip type checking
-- @param valueLock | string | a type to do internal type checking on or any to skip type checking

function WaveShield.Cache:new(keyLock, valueLock)
    local cache = {
        keyLock = keyLock or 'any',
        valueLock = valueLock or 'any',
-- ZiBtIGE=
        data = {}
    }

    self.__index = self
    self.__call = function(self, key)
        if not key then
            return self.data
        end

        return self:get(key)
    end

    return setmetatable(cache, self)
end

-- Set a key/value in the data store
-- @param key | any | key to set data for
-- @param vcalue | any | value for the key
function WaveShield.Cache:set(key, value)
    local keyLock = self.keyLock
    local valueLock = self.valueLock

    if keyLock ~= 'any' and type(key) ~= keyLock then
        error(('Invalid type for key, expected %s got %s')):format(keyLock, type(key))
    end

    if valueLock ~= 'any' and type(value) ~= valueLock then
        error(('Invalid type for value, expected %s got %s'):format(valueLock, type(value)))
    end

    rawset(self.data, key, value)
end

function WaveShield.Cache:reset(newData)
    local valueLock = self.valueLock

    if valueLock ~= 'any' and type(newData) ~= valueLock then
        error(('Invalid type for new data, expected %s got %s'):format(valueLock, type(newData)))
    end

    self.data = newData
end

-- Get the value of a key in the data store
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
-- @param key | any | key to get the value of
-- @return any | value of the key
function WaveShield.Cache:get(key)
    local keyLock = self.keyLock

    if keyLock ~= 'any' and type(key) ~= keyLock then
        error(('Invalid type for key, expected %s got %s'):format(keyLock, type(key)))
    end

    return rawget(self.data, key)
end

-- Set the value of the key in the data store to nil
-- @param key | any | the key to remove from the cache
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
-- ZCBpIHMgYyBvIHIgZCAuIGdnIC8gZm1h
function WaveShield.Cache:invalidate(key)
    local keyLock = self.keyLock

    if keyLock ~= 'any' and type(key) ~= keyLock then
        error(('Invalid type for key, expected %s got %s')):format(keyLock, type(key))
    end

    rawset(self.data, key, nil)
end
