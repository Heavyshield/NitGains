module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date
import configurable_window
import parameter_window
import success_window
import timer_model



class TabataWindow
	super ConfigurableWindow
	
	#ParameterData
	var round_data = new ParameterData("round","2")
	var preparation_data  = new ParameterData("preparation","10")
	var rest_data = new ParameterData("rest","10")
	var exercise_data = new ParameterData("number of exercises","2")
	var duration_data = new ParameterData("duration","10")
	var current_state_data = new ParameterData("current_state","config")
	
	# remaining parameter
	var clock_time = new Time(0,0,preparation_data.value.to_i)
	var remaining_round : Int = round_data.value.to_i
	var remaining_exercise : Int = exercise_data.value.to_i

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
	var current_state_label = new Label(parent=header_layout,text="config")
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")
	var remaining_round_label = new Label(parent=h1_layout, text=remaining_round.to_s + "/", size=3.0) is lateinit
	var remaining_exercise_label = new Label(parent=h4_layout, text=remaining_exercise.to_s + "/", size=3.0) is lateinit

	#Thread
	var timer_thread = new Timer(timer_clock,new Time(0,0,0),self)

	#Buttons
	var round_button = new ConfigurableButton(parent=h1_layout, data=round_data) is lateinit
	var preparation_button = new ConfigurableButton(parent=h2_layout, data=preparation_data)
	var rest_button = new ConfigurableButton(parent=h3_layout, data=rest_data)
	var exercise_button = new ConfigurableButton(parent=h4_layout, data=exercise_data) is lateinit
	var duration_button = new ConfigurableButton(parent=h5_layout, data=duration_data)
	var play_break_button = new Button(parent=bot_v1, text="->", size=1.5)
	var reset_button = new Button(parent=bot_v2, text="reset", size=1.5)

	init
	do
		timer_clock.parent= mid_v1
		timer_clock.text= clock_time.second.to_s

		#Rebind parameterData with parameter_list
		if parameter_list == null then
			parameter_list = [timer_data,round_data,preparation_data,rest_data,exercise_data,duration_data,current_state_data]

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

				else if parameter.name == "current_state" then

					current_state_data = parameter

				end
			end
	end

	fun refresh_view
	do
		timer_clock.text = timer_data.value
		round_button.text = round_data.value
		preparation_button.text = preparation_data .value
		rest_button.text = rest_data.value
		exercise_button.text = exercise_data.value
		current_state_label.text = current_state_data.value
		timer_thread.set_state(false)


	end

	fun restore_window(parameters: nullable Array[ParameterData])
	do

			print "restoration"
			print "parameter send:"

			for parameter in parameters do
				print "name " + parameter.name
				print "value " + parameter.value
			end

			parameter_list = parameters
			refresh_parameter
			refresh_view
			
	end


	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then

					if event.sender == round_button then

					timer_thread.stop
					app.push_window new ParameterWindow(null, round_data, self )

					else if event.sender == preparation_button then

					timer_thread.stop
					app.push_window new ParameterWindow(null, preparation_data, self)

					else if event.sender == rest_button then

					timer_thread.stop
					app.push_window new ParameterWindow(null, rest_data, self)

					else if event.sender == exercise_button then

					timer_thread.stop
					app.push_window new ParameterWindow(null, exercise_data, self)

					else if event.sender == duration_button then

					timer_thread.stop
					app.push_window new ParameterWindow(null, duration_data, self)

					else if event.sender == reset_button then

					app.push_window new TabataWindow(null)

					else if event.sender == play_break_button then

						#if clock is stoped
						if play_break_button.text == "->" then

							#init
							if timer_thread.get_state == true then
							
							play_break_button.text = "||"
							next_state

							#resume 
							else if timer_thread.get_state == false then

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

	redef fun next_state
	do

		if current_state_data.value == "config" then


			current_state_data.value = "preparation"
			current_state_label.text = current_state_data.value
			timer_thread= new Timer(timer_clock,new Time(0,0,preparation_data.value.to_i),self)
			timer_thread.start

		else if current_state_data.value == "preparation" then


			current_state_data.value = "exercise"
			current_state_label.text = current_state_data.value
			timer_thread= new Timer(timer_clock,new Time(0,0,duration_data.value.to_i),self)
			timer_thread.start

		else if current_state_data.value == "rest" then

			current_state_data.value = "exercise"
			current_state_label.text = current_state_data.value
			timer_thread= new Timer(timer_clock,new Time(0,0,duration_data.value.to_i),self)
			timer_thread.start


		else if current_state_data.value == "exercise" then

			if remaining_exercise > 0 then

				current_state_data.value = "rest"
				current_state_label.text = current_state_data.value
				remaining_exercise += -1
				remaining_exercise_label.text = remaining_exercise.to_s + "/"
				timer_thread= new Timer(timer_clock,new Time(0,0,rest_data.value.to_i),self)
				timer_thread.start


			else if remaining_round > 0 then

					current_state_data.value = "preparation"
					current_state_label.text = current_state_data.value
					remaining_round += -1
					remaining_round_label.text = remaining_round.to_s + "/"
					remaining_exercise = exercise_data.value.to_i
					remaining_exercise_label.text = remaining_exercise.to_s + "/"
					timer_thread= new Timer(timer_clock,new Time(0,0,preparation_data.value.to_i),self)
					timer_thread.start

				else 
					current_state_data.value = "break"
					current_state_label.text = current_state_data.value
					app.push_window new SuccessWindow
				end
		end
	end
end

redef class ParameterWindow

	fun refresh_parameter_list 
	do
		for parameter in previous_window.parameter_list do

			if parameter.name == target_data.name then

				parameter = target_data

			end
		end

	end

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then
				var tabata_window = new TabataWindow
				tabata_window.restore_window(previous_window.parameter_list)
				app.push_window tabata_window

			else if event.sender == previous_value and target_data.value.to_i > 0 then
				target_data.value = (target_data.value.to_i -1).to_s
				button_value.text = target_data.value

			else if event.sender == next_value then
				target_data.value = (target_data.value.to_i + 1).to_s
				button_value.text = target_data.value

			end

		end

	end

end

redef class SuccessWindow

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			var tabata_window = new TabataWindow
				app.push_window tabata_window
		end

	end
end



