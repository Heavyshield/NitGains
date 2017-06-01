module tabata_view

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
import tabata_context
import save_window

class TabataWindow
	super ConfigurableWindow
	
	#Clock state
	var clock_player = false

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
	var current_state_label = new ConfigurableLabel(parent=header_layout,data= new ParameterData("current_state","config"))
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")
	var remaining_round_label = new ConfigurableLabel(parent=h1_layout , data= new ParameterData("remaining_round",remaining_round.to_s + "/")) 
	var remaining_exercise_label = new ConfigurableLabel(parent=h4_layout, data= new ParameterData("remaining_exercise",remaining_exercise.to_s + "/")) 

	#Thread
	var clock_thread = new Timer(clock_label,new Time(0,0,0),self)

	#Buttons
	var round_button = new ConfigurableButton(parent=h1_layout, data=round_data) is lateinit
	var preparation_button = new ConfigurableButton(parent=h2_layout, data=preparation_data)
	var rest_button = new ConfigurableButton(parent=h3_layout, data=rest_data)
	var exercise_button = new ConfigurableButton(parent=h4_layout, data=exercise_data) is lateinit
	var duration_button = new ConfigurableButton(parent=h5_layout, data=duration_data)
	var play_break_button = new ConfigurablePlayer(parent=bot_v1, size=1.5, data= new ParameterData("play_break","->"))
	var reset_button = new Button(parent=bot_v2, text="reset", size=1.5)
	var save_button = new Button(parent=bot_v2, text="save", size=1.5)

	#data_store
	var context : nullable TabataContext 
	#= new TabataContext(parameter_list.as(Array[ParameterData])) is lateinit

	#clean list
	var button_list : Array[ConfigurableButton] = [round_button,preparation_button,rest_button,exercise_button,duration_button,play_break_button]
	var label_list : Array[ConfigurableLabel] = [current_state_label,remaining_round_label,remaining_exercise_label,clock_label]

	init
	do

		clock_label.parent= mid_v1
		clock_label.text= clock_time.second.to_s

		#Rebind parameterData with parameter_list
		if parameter_list == null then

			parameter_list = [clock_data,round_data,preparation_data,rest_data,exercise_data,duration_data,current_state_data]

		end
	end



	fun refresh_parameter
	do
			clock_thread.set_state(false)
		for parameter in parameter_list do

			for configurable_button in button_list do

				if parameter.name == configurable_button.data.name then

				configurable_button.refresh(parameter)

				end
			end

			for configurable_label in label_list do 

				if parameter.name == configurable_label.data.name then

				configurable_label.refresh(parameter)

				end
			end
		end


	end

	#restore tabata_window from ParameterWindow with parameter_list
	fun restore_window(parameters: nullable Array[ParameterData])
	do

			parameter_list = parameters
			refresh_parameter
			
	end


	#On ButtonPressEvent do something 
	redef fun on_event(event)
	do 

		if event isa ButtonPressEvent then

			#Play break button
			if event.sender isa ConfigurablePlayer then

						#if clock is stoped (false)
						if clock_player == false then

							#init
							if clock_thread.get_state == true then
							
							play_break_button.text = "||"
							clock_player = true
							next_state

							#resume 
							else if clock_thread.get_state == false then

							resume_clock
							play_break_button.text = "||"
							clock_player = true
							print "clock resume"

							end

						#if clock is on (true)
						else if clock_player == true then

							clock_thread.stop
							play_break_button.text = "->"
							
							clock_player = false
							print "clock break (state is false)"
						end	


			else if event.sender isa ConfigurableButton then

				clock_thread.stop
				app.push_window new ParameterWindow(null, event.sender.as(ConfigurableButton).data, self )

			else if event.sender isa Button then
				clock_thread.stop

				if event.sender.text == "reset" then
					app.push_window new TabataWindow(null)
				else if event.sender.text == "save" then
					app.push_window new SaveWindow(null, parameter_list.as(Array[ParameterData]), self)
				end
				
			end
		end

	end

	fun resume_clock
	do
		clock_thread= new Timer(clock_label,new Time(0,0,clock_label.text.to_i),self)
		clock_thread.start
	end

	redef fun next_state
	do

		if current_state_data.value == "config" then


			current_state_data.value = "preparation"
			current_state_label.text = current_state_data.value
			clock_thread= new Timer(clock_label,new Time(0,0,preparation_data.value.to_i),self)
			clock_thread.start

		else if current_state_data.value == "preparation" then


			current_state_data.value = "exercise"
			current_state_label.text = current_state_data.value
			clock_thread= new Timer(clock_label,new Time(0,0,duration_data.value.to_i),self)
			clock_thread.start

		else if current_state_data.value == "rest" then

			current_state_data.value = "exercise"
			current_state_label.text = current_state_data.value
			clock_thread= new Timer(clock_label,new Time(0,0,duration_data.value.to_i),self)
			clock_thread.start


		else if current_state_data.value == "exercise" then

			if remaining_exercise > 0 then

				current_state_data.value = "rest"
				current_state_label.text = current_state_data.value
				remaining_exercise += -1
				remaining_exercise_label.text = remaining_exercise.to_s + "/"
				clock_thread= new Timer(clock_label,new Time(0,0,rest_data.value.to_i),self)
				clock_thread.start


			else if remaining_round > 0 then

					current_state_data.value = "preparation"
					current_state_label.text = current_state_data.value
					remaining_round += -1
					remaining_round_label.text = remaining_round.to_s + "/"
					remaining_exercise = exercise_data.value.to_i
					remaining_exercise_label.text = remaining_exercise.to_s + "/"
					clock_thread= new Timer(clock_label,new Time(0,0,preparation_data.value.to_i),self)
					clock_thread.start

				else 
					current_state_data.value = "break"
					current_state_label.text = current_state_data.value
					app.push_window new SuccessWindow
				end
		end
	end

	redef fun on_save_state
	do
		app.data_store["context"] = context
		super
	end

	redef fun on_restore_state
	do
		super

		var context = app.data_store["context"]

		if not context isa TabataContext then return

		self.context = context

	end
end


#redef ParameterWindow
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

#redef SuccessWindow
redef class SuccessWindow

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			var tabata_window = new TabataWindow
				app.push_window tabata_window
		end

	end
end

redef class SaveWindow 
	redef fun on_event(event)
	do
		if event isa ButtonPressEvent then

			var tabata_window = new TabataWindow
				app.push_window tabata_window
		end

	end
end

#redef TabataContext
redef class TabataContext 

	redef fun restore_context
	do
		app.push_window new TabataWindow(null,self.parameter_list)
	end

end



