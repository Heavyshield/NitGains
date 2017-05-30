module timer_model

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_window
import pthreads
import app::http_request



# Thread implementation for timer_thread(Clock,Time)
class Timer
	super Thread


	var clock: Clock
	var init_time: Time
	var window: ConfigurableWindow
	var current_time: Int = init_time.second is lateinit
	var state = true

	redef fun main
	do
		var i = init_time.second
		var text = i.to_s

		print "thread created"

		loop 

			if i <= 0 then

				window.next_state
				 break

			else if state == false then

				break

			 end

			sys.nanosleep(1,0)
			i = i -1
			print i
			text = i.to_s
			current_time = i
			var task = new RefreshViewTask(clock,text)
			window.clock_data.value = i.to_s
			app.run_on_ui_thread(task)
			end

		return "thread terminated"
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