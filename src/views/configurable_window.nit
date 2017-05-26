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
	var timer_data = new ParameterData("time","10")

	#Clock
	#var timer_clock = new Clock(parent=mid_v1, text=clock_time.second.to_s)
	var timer_clock = new Clock

	fun next_state
	do
	end


end

class Clock

	#super TextView
	 super Label
	#var native = new NativeService

end