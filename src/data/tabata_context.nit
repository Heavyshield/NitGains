module tabata_context

import nitGains_data
import app::ui
import app::data_store
import android::aware
import nitGains_data

#Hold the state of the tabata_view	
class TabataContext
	auto_serializable 

	var parameter_list : Array[ParameterData] 
	
	fun restore_context
	do

	end

end
