module nitGains_timer

import date
import pthreads
import app::ui
import app::http_request


# Thread implementation for Timer (Clock,Time)
class Timer
	super Thread


	var clock: Clock
	var init_time: Time

	fun decrease(value: Int)
	do
	#	current_time = new Time(0,0,current_time.second - value)
	end

	fun reset
	do
	#current_time = init_time
	end

	redef fun main
	do
		var i = init_time.second
		var text = i.to_s

		print "thread created"

		loop 
			sys.nanosleep(1,0)
			i = i -1
			print i
			text = i.to_s
			var task = new RefreshView(clock,text)
			app.run_on_ui_thread(task)
			#clock.text = text

				if i == 0 then
				 	break
				 end
			end
		return "next state"
	end


	#redef fun run_on_ui_thread(task)
	#do

	#end

end


class RefreshView
	super Task

	var target : Clock
	var value : String

	redef fun main
	do
		target.text = value
	end

end

class Clock

	#super TextView
	 super Button
	#var native = new NativeService

end

