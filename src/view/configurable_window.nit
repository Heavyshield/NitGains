module configurable_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date
import app::http_request


#classic window with parameter bind on buttons and a clock
class ConfigurableWindow 
	super Window 

	auto_serializable 

	#Contain all parameters data, round, exercise , rest etc...
	var parameter_list : nullable Array[ParameterData]
	var configurable_button_list : nullable Array[ConfigurableButton]
	var clock_data = new ParameterData("clock","10")
	var current_state_data = new ParameterData("current_state","config")

	#Clock
	#var timer_clock = new Clock(parent=mid_v1, text=clock_time.second.to_s)
	var clock_label = new Clock(data=clock_data) is lateinit
	var current_state_label = new ConfigurableLabel(data=current_state_data) is lateinit

	fun next_state
	do
	end

end




