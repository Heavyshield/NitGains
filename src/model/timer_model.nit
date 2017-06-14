# This file is part of NIT ( http://www.nitlanguage.org ).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module timer_model

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_window
import pthreads
import app::http_request

# Thread using as a Timer 
class Timer
	super Thread


	var window: ConfigurableWindow
	var clock : Clock = window.clock_label is lateinit
	var current_time = 60 is writable
	var state = false
	var is_init = false is writable
	var is_killed = false
	var previous_state = "null"
	var current_state = "null"

	redef fun main
	do

		current_time = window.clock_label.data.value.to_i
		current_state = window.current_state_label.data.value

		loop 

			current_state = window.current_state_label.data.value
			var i = current_time
			refresh_clock(i)
			sys.nanosleep(1,0)

			# Counting
			 if state == true and i>0 then
				
				i = i - 1
				refresh_clock(i)
				current_time = i
				print current_time

			# Reach 0, call next_state
			else if i <= 0 and state == true then

					# Check with the main thread is refreshed
					if current_state != previous_state then

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

	# Set Clock value 
	fun refresh_clock(value : Int)
	do

		var task = new RefreshViewTask(clock, value.to_s)
		app.run_on_ui_thread(task)

	end

	# Set current_state value
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

# Build a Task used by the main Thread for refresh the current_state
class RefreshStateTask
	super Task

	var window : ConfigurableWindow

	redef fun main
	do

		window.next_state

	end

end

# Build a Task used by the main Thread for refresh the Clock
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





