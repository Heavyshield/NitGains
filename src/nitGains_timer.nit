module nitGains_timer

import date
import pthreads
import app::ui


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
			clock.text = text

				if i == 0 then
				 	break
				 end
			end
		return "next state"
	end


end

class Clock

	#super TextView
	 super Button
	#var native = new NativeService

end

