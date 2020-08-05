module Reso
	class Constants
		RESOURCE_MODELS = {
				:READABLE => [ResoProperty, ResoMedia, ResoMember, ResoOffice, ResoOpenHouse],
				:EDITABLE => [ResoProperty, ResoMedia, ResoMember, ResoOffice, ResoOpenHouse],
		}

		RESOURCE_NAMES = {
				:READABLE => Set.new(RESOURCE_MODELS[:READABLE].map{|x| x.resource_name}),
				:EDITABLE => Set.new(RESOURCE_MODELS[:EDITABLE].map{|x| x.resource_name}),
		}
	end
end