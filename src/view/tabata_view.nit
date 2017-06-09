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

	auto_serializable 

	#ParameterData
	var round_data = new ParameterData("round","2")
	var preparation_data  = new ParameterData("preparation","10")
	var rest_data = new ParameterData("rest","10")
	var exercise_data = new ParameterData("number of exercises","2")
	var duration_data = new ParameterData("duration","10")

	
	# remaining parameter
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
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")
	var remaining_round_label = new ConfigurableLabel(parent=h1_layout , data= new ParameterData("remaining_round",remaining_round.to_s + "/")) 
	var remaining_exercise_label = new ConfigurableLabel(parent=h4_layout, data= new ParameterData("remaining_exercise",remaining_exercise.to_s + "/")) 



	#Buttons
	var round_button = new ConfigurableButton(parent=h1_layout, data=round_data) is lateinit
	var preparation_button = new ConfigurableButton(parent=h2_layout, data=preparation_data)
	var rest_button = new ConfigurableButton(parent=h3_layout, data=rest_data)
	var exercise_button = new ConfigurableButton(parent=h4_layout, data=exercise_data) is lateinit
	var duration_button = new ConfigurableButton(parent=h5_layout, data=duration_data)
	var play_break_button = new ConfigurablePlayer(parent=bot_v1, size=1.5, data= new ParameterData("play_break","->"))
	var save_button = new Button(parent=bot_v2, text="save", size=1.5)

	#clean list
	var button_list : Array[ConfigurableButton] = [round_button,preparation_button,rest_button,exercise_button,duration_button,play_break_button]
	var label_list : Array[ConfigurableLabel] = [current_state_label,remaining_round_label,remaining_exercise_label,clock_label]


	# Context with the paramater needed for the restoration
	 var context = new TabataContext(self) is lazy

	init
	do
		#Rebind parameterData with parameter_list

		parameter_list = [clock_data,round_data,preparation_data,rest_data,exercise_data,duration_data,current_state_data]

		clock_label.parent= mid_v1
		clock_label.text= clock_data.value
		current_state_label.parent= header_layout
		current_state_label.text = current_state_data.value

	end

	redef fun on_save_state
	do
		print "on_save_state"

		app.clock_thread.stop
		refresh_parameter_list
		context = new TabataContext(self) 
		app.data_store["context"] = context
		super

	end
	redef fun on_restore_state
	do
		print "on_restore_state"

		var context = app.data_store["context"]

		if not context isa TabataContext then return

		self.context = context

		#reload window
		app.push_window context.tabata_save

	end

	# bind parameter in parameter_list with configurable_button 
	fun refresh_parameter_list
	do

		for configurable_button in button_list do
			for parameter in parameter_list do
				if configurable_button.data.name == parameter.name then
					parameter = configurable_button.data
				end
			end
		end



			for parameter in parameter_list do

				if parameter.name == "clock" then

					parameter.value = clock_label.data.value

				end

			end
		

	end

	fun refresh_button_data
	do
	
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

			refresh_button_data
	
	end

	#On ButtonPressEvent do something 
	redef fun on_event(event)
	do 

		if event isa ButtonPressEvent then

			#Play break button
			if event.sender isa ConfigurablePlayer then

						#if play_break_button is on pause (false)
						if play_break_button.state == false then

							if app.clock_thread.is_init == false then

								if current_state_label.data.value == "config" then
									next_state
								end

								app.clock_thread.is_init = true
								app.clock_thread.start

							end

							play_break_button.on_play
							resume_clock

						#if play_break_button is on play(true)
						else if play_break_button.state == true then

							app.clock_thread.stop
							play_break_button.on_break
							
						end	


			else if event.sender isa ConfigurableButton then

				app.clock_thread.stop
				refresh_parameter_list


				app.clock_thread.kill
				app.push_window new ParameterWindow(null, event.sender.as(ConfigurableButton).data, self )

			else if event.sender isa Button then

				app.clock_thread.stop

				else if event.sender.text == "save" then
					app.push_window new SaveWindow(null, parameter_list.as(Array[ParameterData]), self)
				end
				
			
		end

	end

	fun resume_clock
	do

		app.clock_thread.set_current_time(clock_label.text.to_i)
		app.clock_thread.launch

	end

	redef fun next_state
	do
		print "next state is called"

		if current_state_label.data.value == "config" then

			current_state_label.data.value = "preparation"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = preparation_data.value.to_i

		else if current_state_label.data.value == "preparation" then


			current_state_label.data.value = "exercise"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = duration_data.value.to_i

		else if current_state_label.data.value == "rest" then

			current_state_label.data.value = "exercise"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = duration_data.value.to_i


		else if current_state_label.data.value == "exercise" then

			if remaining_exercise > 0 then

				current_state_label.data.value = "rest"
				current_state_label.text = current_state_label.data.value
				remaining_exercise += -1
				remaining_exercise_label.text = remaining_exercise.to_s + "/"
				app.clock_thread.current_time = rest_data.value.to_i

			else if remaining_round > 0 then

					current_state_label.data.value = "preparation"
					current_state_label.text = current_state_label.data.value
					remaining_round += -1
					remaining_round_label.text = remaining_round.to_s + "/"
					remaining_exercise = exercise_data.value.to_i
					remaining_exercise_label.text = remaining_exercise.to_s + "/"
					app.clock_thread.current_time = preparation_data.value.to_i
				else 
					current_state_label.data.value = "break"
					current_state_label.text = current_state_label.data.value
					app.push_window new SuccessWindow
				end
		end
	end

end


#redef ParameterWindow
redef class ParameterWindow


	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then

				var tabata_window = new TabataWindow
				tabata_window.restore_window(previous_window.parameter_list)
				app.push_window tabata_window
				app.clock_thread = new  Timer(tabata_window)
				app.clock_thread.launch

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

class TabataContext

	auto_serializable 

	var tabata_save : TabataWindow
end


redef class App

	var clock_thread : nullable Timer = null
	 var tabata_window = new TabataWindow(null) is lazy


	redef fun on_create
	do
		

		clock_thread = new Timer(tabata_window)

		push_window tabata_window
		super
	end

end


