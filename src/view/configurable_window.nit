module configurable_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date


#classic window with parameter bind on buttons and a clock
class ConfigurableWindow 
	super Window 

	#Contain all parameters data, round, exercise , rest etc...
	var parameter_list : nullable Array[ParameterData]
	var configurable_button_list : nullable Array[ConfigurableButton]
	var clock_data = new ParameterData("clock","10")

	#Clock
	#var timer_clock = new Clock(parent=mid_v1, text=clock_time.second.to_s)
	var clock_label = new Clock(data=clock_data) is lateinit

	fun next_state
	do
	end


end

class Clock

	#super TextView
	 super ConfigurableLabel
	#var native = new NativeService

end