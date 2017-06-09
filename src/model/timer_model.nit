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
	var previous_state = "null"
	var current_state = "null"

	redef fun main
	do
		print "main_________________"

		current_time = window.clock_label.data.value.to_i
		current_state = window.current_state_label.data.value

		print "current_time : " + current_time.to_s
		print "current_state : " + current_state

		loop 

			current_state = window.current_state_label.data.value
			var i = current_time
			refresh_clock(i)

			sys.nanosleep(1,0)

			print "loop_________________"
			print "current_time : " + current_time.to_s
			print "current_state : " + current_state
			
			# continue to decrease i
			 if state == true and i>0 then
				
				i = i - 1
				refresh_clock(i)
				current_time = i

				print current_time
			# else if timer is at 0 next_state
			else if i <= 0 and state == true then

				#TODO throw wrong thread on next_state
				print " i <= 0 and state == true then"
				print "previous_state : " + previous_state
				print "current_state : " + current_state

					#fix for avoid an another nanosleep 
					if current_state != previous_state then

					print "spot a different state so allow a next state"

					previous_state = current_state

					refresh_state

					end

					refresh_clock(i)


			else if is_killed == true then

					print "thread killed"

				return "thread killed"

			else
				print "waiting..."

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

		window.next_state

	end

end

class RefreshViewTask
	super Task

	var target : Clock
	var value : String

	redef fun main
	do

		target.data.value = value
		target.text = value

	end

end





