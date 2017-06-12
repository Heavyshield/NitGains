module tabata_context

import nitGains_data
import app::ui
import app::data_store
import android::aware
import nitGains_data


#Hold the TabataView
class TabataContext

	auto_serializable 

	var name : String 
	var tabata_save : Array[ParameterData]

end

#Hold all saves in a HashMap
class SaveContext

	auto_serializable

	var name : String
	var map : HashMap[String, TabataContext] is writable

end
