module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data
import date
import nitGains_timer

class Clock

	#super TextView
	 super Button
	#var native = new NativeService

end

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
	var exercise_data = new ParameterData("exercise",2)
	var duration_data = new ParameterData("duration",10)
	
	#Contain all parameters data, round, exercise , rest etc...
	var parameter_list : nullable Array[ParameterData]

	#Current_state 
	var clock_time = new Time(0,0,preparation_data.value)
	var current_state = "config"
	var remaining_round : Int = round_data.value
	var remaining_exercise : Int = exercise_data.value
	# config, preparation, exercise, rest, break

	#Root layout
	var root_layout = new VerticalLayout(parent=self)

	var title = new Label(parent=root_layout, text="Tabata")

	#Main layout
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
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")

	#Buttons
	var timer_button = new Clock(parent=mid_v1, text=clock_time.second.to_s)
	var round_button = new Button(parent=h1_layout, text=round_data.value.to_s)
	var preparation_button = new Button(parent=h2_layout, text=preparation_data.value.to_s)
	var rest_button = new Button(parent=h3_layout, text=rest_data.value.to_s)
	var exercise_button = new Button(parent=h4_layout, text=exercise_data.value.to_s)
	var duration_button = new Button(parent=h5_layout, text=duration_data.value.to_s)
	var play_break_button = new Button(parent=bot_v1, text="->", size=1.5)
	var reset_button = new Button(parent=bot_v2, text="reset", size=1.5)


	#manual clock Todo thread nit pour la generation d'events
	var timer_decrement = new Button(parent=mid_v1, text="<-")

	init
	do
		#Todo
		#var thread = new Timer(new Time(0,0,1))
		var thread = new Timer
		thread.start
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
		timer_button.text = timer_data.value.to_s
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

			#Fake event on clock_time déclanche l'event en cliquant sur clock
			if event.sender isa Clock then

				if clock_time.second == 0 then
					print "next_state "
					next_state
				else
					print "time is :" + clock_time.second.to_s 
				end

			else if event.sender isa Button then

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

					else if event.sender == timer_decrement and clock_time.second > 0 then
					clock_time = new Time(0,0,clock_time.second - 1)
					timer_button.text = clock_time.second.to_s

					end
			end
		end
	end

	fun next_state
	do
		print "remaining_round :" + remaining_round.to_s
		print "remaining_exercise :" + remaining_exercise.to_s

		if current_state == "config" then
			current_state = "preparation"
			clock_time = new Time(0,0,preparation_data.value)
			timer_button.text = clock_time.second.to_s
			print "preparation"

		else if current_state == "preparation" then
			current_state = "exercise"
			clock_time = new Time(0,0,duration_data.value)
			timer_button.text = clock_time.second.to_s
			print "exercise"

		else if current_state == "rest" then
			current_state = "exercise"
			clock_time = new Time(0,0,duration_data.value)
			timer_button.text = clock_time.second.to_s

		else if current_state == "exercise" then
			if remaining_exercise > 0 then
				current_state = "rest"
				remaining_exercise += -1
				clock_time = new Time(0,0,rest_data.value)
				timer_button.text = clock_time.second.to_s
				print "rest"

			else
				if remaining_round > 0 then
					current_state = "preparation"
					remaining_round += -1
					clock_time = new Time(0,0,preparation_data.value)
					timer_button.text = clock_time.second.to_s
					print "preparation"

				else 
					current_state = "break"
					print "break"

				end
			end
		else if current_state == "rest" then 
			current_state = "exercise"

		end
	end

end

	fun play_action
	do

	end

	fun break_action
	do
	end

class TimerWindow
	super Window

	var layout = new VerticalLayout(parent=self)
	var timer_label = new Label(parent=layout, text="00:00")

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


