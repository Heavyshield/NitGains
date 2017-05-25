module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data
import date
import nitGains_timer




class ClockEvent

super ViewEvent
redef type VIEW: Clock

end

class TabataWindow
	super Window
	
	#ParameterData
	var timer_data = new ParameterData("time",10)
	var round_data = new ParameterData("round",2)
	var preparation_data  = new ParameterData("preparation",10)
	var rest_data = new ParameterData("rest",10)
	var exercise_data = new ParameterData("number of exercises",2)
	var duration_data = new ParameterData("duration",10)
	
	#Contain all parameters data, round, exercise , rest etc...
	var parameter_list : nullable Array[ParameterData]

	#Current_state 
	var clock_time = new Time(0,0,preparation_data.value)
	var current_state = "config"
	var remaining_round : Int = round_data.value
	var remaining_exercise : Int = exercise_data.value

	#Root layout
	var root_layout = new VerticalLayout(parent=self)

	#Main layout
	var header_layout = new HorizontalLayout(parent=root_layout)
	var top_layout = new HorizontalLayout(parent=root_layout)
	var mid_layout = new HorizontalLayout(parent=root_layout)
	var bot_layout = new HorizontalLayout(parent=root_layout)


	#Secondary layout
	var mid_v1 = new VerticalLayout(parent=mid_layout)
	var mid_v2 = new VerticalLayout(parent=mid_layout)

	var bot_v1 = new VerticalLayout(parent=bot_layout)
	var bot_v2 = new VerticalLayout(parent=bot_layout)

	#Third layout
	var h1_layout = new HorizontalLayout(parent=mid_v2)
	var h2_layout = new HorizontalLayout(parent=mid_v2)
	var h3_layout = new HorizontalLayout(parent=mid_v2)
	var h4_layout = new HorizontalLayout(parent=mid_v2)
	var h5_layout = new HorizontalLayout(parent=mid_v2)


	#Labels
	var title_label = new Label(parent=header_layout, text="Tabata")
	var state_label = new Label(parent=header_layout,text="config")
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")
	var remaining_round_label = new Label(parent=h1_layout, text=remaining_round.to_s + "/", size=3.0) is lateinit
	var remaining_exercise_label = new Label(parent=h4_layout, text=remaining_exercise.to_s + "/", size=3.0) is lateinit

	#Clock
	var timer_clock = new Clock(parent=mid_v1, text=clock_time.second.to_s)
	var timer_thread = new Timer(timer_clock,new Time(0,0,0),self)

	#Buttons
	var round_button = new Button(parent=h1_layout, text=round_data.value.to_s) is lateinit
	var preparation_button = new Button(parent=h2_layout, text=preparation_data.value.to_s)
	var rest_button = new Button(parent=h3_layout, text=rest_data.value.to_s)
	var exercise_button = new Button(parent=h4_layout, text=exercise_data.value.to_s) is lateinit
	var duration_button = new Button(parent=h5_layout, text=duration_data.value.to_s)
	var play_break_button = new Button(parent=bot_v1, text="->", size=1.5)
	var reset_button = new Button(parent=bot_v2, text="reset", size=1.5)

	init
	do
		#Rebind parameterData with parameter_list
		if parameter_list == null then
			parameter_list = [timer_data,round_data,preparation_data,rest_data,exercise_data,duration_data]

		end

	end

	fun refresh_parameter
	do
			for parameter in parameter_list do
				if parameter.name == "time" then
				timer_data = parameter

				else if parameter.name == "round" then
				round_data = parameter

				else if parameter.name == "preparation" then
				preparation_data = parameter

				else if parameter.name == "rest" then
				rest_data = parameter

				else if parameter.name == "exercise" then
				exercise_data = parameter

				end
			end
	end

	fun refresh_view
	do
		timer_clock.text = timer_data.value.to_s
		round_button.text = round_data.value.to_s
		preparation_button.text = preparation_data.value.to_s
		rest_button.text = rest_data.value.to_s
		exercise_button.text = exercise_data.value.to_s

	end

	fun restore_window(parameters: Array[ParameterData])
	do
		for parameter in parameters
			do
				print parameter.name
				print parameter.value

			end
			parameter_list = parameters
			refresh_parameter
			refresh_view
	end


	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then
					

					if event.sender == round_button then
					app.push_window new ButtonWindow(null, round_data, parameter_list )

					else if event.sender == preparation_button then
					app.push_window new ButtonWindow(null, preparation_data, parameter_list)

					else if event.sender == rest_button then
					app.push_window new ButtonWindow(null, rest_data, parameter_list)

					else if event.sender == exercise_button then
					app.push_window new ButtonWindow(null, exercise_data,parameter_list)

					else if event.sender == duration_button then
					app.push_window new ButtonWindow(null, duration_data,parameter_list)

					else if event.sender == reset_button then
					app.push_window new TabataWindow(null)

					else if event.sender == play_break_button then

						#if thread isn't started
						if play_break_button.text == "->" then

							#init
							if timer_thread.get_state == true then
							
							play_break_button.text = "||"
							next_state

							#resume if false (take current clock value)
							else

							resume_clock
							play_break_button.text = "||"
							print "clock resume"

							end

						#if clock is on
						else
							play_break_button.text = "->"
							timer_thread.stop
							print "clock break (state is false)"
					end
			end
		end
	end

	fun resume_clock
	do
		timer_thread= new Timer(timer_clock,new Time(0,0,timer_clock.text.to_i),self)
		timer_thread.start
	end


	fun next_state
	do
		print "remaining_round :" + remaining_round.to_s
		print "remaining_exercise :" + remaining_exercise.to_s

		
		if current_state == "config" then

			current_state = "preparation"
			state_label.text = current_state
			timer_thread= new Timer(timer_clock,new Time(0,0,preparation_data.value),self)
			timer_thread.start

		else if current_state == "preparation" then

			current_state = "exercise"
			state_label.text = current_state
			timer_thread= new Timer(timer_clock,new Time(0,0,duration_data.value),self)
			timer_thread.start


		else if current_state == "rest" then

			current_state = "exercise"
			state_label.text = current_state
			timer_thread= new Timer(timer_clock,new Time(0,0,duration_data.value),self)
			timer_thread.start


		else if current_state == "exercise" then

			if remaining_exercise > 0 then

				current_state = "rest"
				state_label.text = current_state
				remaining_exercise += -1
				remaining_exercise_label.text = remaining_exercise.to_s + "/"
				timer_thread= new Timer(timer_clock,new Time(0,0,rest_data.value),self)
				timer_thread.start


			else if remaining_round > 0 then

					current_state = "preparation"
					state_label.text = current_state
					remaining_round += -1
					remaining_round_label.text = remaining_round.to_s + "/"
					remaining_exercise = exercise_data.value
					remaining_exercise_label.text = remaining_exercise.to_s + "/"
					timer_thread= new Timer(timer_clock,new Time(0,0,preparation_data.value),self)
					timer_thread.start


				else 
					current_state = "break"
					state_label.text = current_state
					app.push_window new SuccessWindow
				end
		end
	end
end

class ButtonWindow
	super Window

	public var button_data:  ParameterData 
	var parameter_list : nullable Array[ParameterData]

	var root_layout = new VerticalLayout(parent=self)
	var set_value_layout = new HorizontalLayout(parent=root_layout)
	var previous_value = new Button(parent=set_value_layout, text="<")
	var button_value =  new Button(parent=set_value_layout, text=button_data.value.to_s) is lateinit
	var next_value = new Button(parent=set_value_layout, text=">") is lateinit
	var back = new Button(parent=root_layout, text="back", size=1.5)

	fun refresh_parameter_list : Array[ParameterData]
	do
		for parameter in parameter_list do
			if parameter.name == button_data.name then
				parameter = button_data

			end
		end
		return parameter_list.as(Array[ParameterData])
	end

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then
				var tabata_window = new TabataWindow
				tabata_window.restore_window(refresh_parameter_list)
				app.push_window tabata_window

			else if event.sender == previous_value and button_data.value > 0 then
				button_data.value += -1
				button_value.text = button_data.value.to_s

			else if event.sender == next_value then
				button_data.value += 1
				button_value.text = button_data.value.to_s

			end

		end

	end

end

class SuccessWindow
	super Window

	var root_layout = new VerticalLayout(parent=self)
	var success_label = new Label(parent=root_layout, text="you did it", size=5.5)
	var back_button = new Button(parent=root_layout, text="back", size=1.5)

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then
			var tabata_window = new TabataWindow
				app.push_window tabata_window
		end

	end
end



# Thread implementation for timer_thread(Clock,Time)
class Timer
	super Thread


	var clock: Clock
	var init_time: Time
	var window: TabataWindow
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
			var task = new RefreshViewButton(clock,text)
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

end



class RefreshViewButton
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
	 super Label
	#var native = new NativeService

end

