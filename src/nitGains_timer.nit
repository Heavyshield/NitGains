module nitGains_timer

import date
import pthreads

class Timer
	super Thread

	#var init_time : Time
	#var current_time : Time = init_time
	

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
		var i = 0
		loop 
			sys.nanosleep(1,0)
			print "threaded"
			i += 1

			if i == 100 then break
		end

		return "done"
	end

end

