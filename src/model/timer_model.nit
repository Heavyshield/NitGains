module timer_model

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_window
import pthreads
import app::http_request
import pthreads::extra



# Thread implementation for timer_thread(Clock,Time)
class Timer
	super Thread



	var clock: Clock
	var current_time: Int is writable
	var window: ConfigurableWindow

	#state true -> couting or next_state
	#state false -> sleep
	var state = false
	var is_init = false is writable

	redef fun main
	do

		print "clock init"
		loop 
			var i = current_time
			sys.nanosleep(1,0)
			print "sleep"


			# continue to decrease i
			 if state == true and i>0 then
				
				i = i - 1
				var task = new RefreshViewTask(clock,i.to_s)
				window.clock_data.value = i.to_s
				app.run_on_ui_thread(task)
				current_time = i

			# else if timer is at 0 next_state
			else if i <= 0 and state == true then

				window.next_state

				var task = new RefreshViewTask(clock,i.to_s)
				window.clock_data.value = i.to_s
				app.run_on_ui_thread(task)
			end
		end

	end

	fun stop
	do
		state = false
	end


	fun get_state : Bool
	do
		return state
	end

	fun set_state(value : Bool)
	do
		state = value
	end

	fun set_current_time(value: Int)
	do
		current_time = value

	end

	fun launch
	do
		state = true

	end

end

class RefreshViewTask
	super Task

	var target : Clock
	var value : String

	redef fun main
	do
		target.text = value
	end

end

class ClockEvent

super ViewEvent
redef type VIEW: Clock

end