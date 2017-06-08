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


	var window: ConfigurableWindow
	var clock : Clock = window.clock_label is lateinit
	var current_time = 60 is writable
	

	#state true -> couting or next_state
	#state false -> sleep
	var state = false
	var is_init = false is writable
	var is_killed = false

	redef fun main
	do

		print "clock init"
		loop 

			var i = current_time
			refresh_clock(i)

			sys.nanosleep(1,0)
			
			# continue to decrease i
			 if state == true and i>0 then
				
				i = i - 1
				refresh_clock(i)
				current_time = i

				print current_time
			# else if timer is at 0 next_state
			else if i <= 0 and state == true then

				#TODO throw wrong thread on next_state
				print " i < 0 state is true so -> next state"

					refresh_state

				
				print "after next state before dangerous refresh clock"

					refresh_clock(i)

				print "next state after dangerous refresh"

				#TODO this nanosleep allow the main thread then necessary time for refresh state and clock for the next loop
				#TODO found a more elegant way to avoid this, or increase the value for a more stable android
				sys.nanosleep(0,100000)

			else if is_killed == true then

				return "thread killed"

			else
				print "nothing"

			end
		end

	end

	fun refresh_clock(value : Int)
	do

		#warning label est une view
		#clock_label.data = new ParameterData("clock", value.to_s)
		var task = new RefreshViewTask(clock, value.to_s)
		app.run_on_ui_thread(task)

	end

	fun refresh_state
	do

		var task = new RefreshStateTask(window)
		app.run_on_ui_thread(task)

	end



	fun stop
	do

		state = false

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

	fun kill 
	do

		is_killed = true

	end

end

class RefreshStateTask
	super Task

	var window : ConfigurableWindow

	redef fun main
	do
		print "refresh state task main"
		window.next_state

	end

end

class RefreshViewTask
	super Task

	var target : Clock
	var value : String

	redef fun main
	do
		print "refresh view task main"
		target.data.value = value
		target.text = value
	end

end





