-- module for loading languages
local lang = {}

-- the table that contains the localizations
local localizations = {
	en_US = require("lang.en_US"),
	es_MX = require("lang.es_MX")
}

function lang.localize(key1, key2)
	return localizations[savefile.data.lang][key1][key2]
end

return lang