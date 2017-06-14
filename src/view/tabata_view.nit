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

# Main logic of the application
module tabata_view

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import configurable_window
import parameter_window
import success_window
import timer_model
import save_window
import load_window

# Main Window 
class TabataWindow

	super ConfigurableWindow	

	# ParameterData
	var round_data = new ParameterData("round","2")
	var preparation_data  = new ParameterData("preparation","10")
	var rest_data = new ParameterData("rest","10")
	var exercise_data = new ParameterData("number of exercises","2")
	var duration_data = new ParameterData("duration","10")

	# Remaining parameter
	var remaining_round : Int = round_data.value.to_i
	var remaining_exercise : Int = exercise_data.value.to_i

	# Root layout
	var root_layout = new VerticalLayout(parent=self)

	# Main layout
	var header_layout = new HorizontalLayout(parent=root_layout)
	var mid_layout = new HorizontalLayout(parent=root_layout)
	var bot_layout = new HorizontalLayout(parent=root_layout)

	# Secondary layout
	var mid_v1 = new VerticalLayout(parent=mid_layout)
	var mid_v2 = new VerticalLayout(parent=mid_layout)
	var bot_v1 = new VerticalLayout(parent=bot_layout)
	var bot_v2 = new VerticalLayout(parent=bot_layout)

	# Third layout
	var h1_layout = new HorizontalLayout(parent=mid_v2)
	var h2_layout = new HorizontalLayout(parent=mid_v2)
	var h3_layout = new HorizontalLayout(parent=mid_v2)
	var h4_layout = new HorizontalLayout(parent=mid_v2)
	var h5_layout = new HorizontalLayout(parent=mid_v2)

	# Labels
	var title_label = new Label(parent=header_layout, text="Tabata")
	var round_label = new Label(parent=h1_layout, text="round")
	var preparation_label = new Label(parent=h2_layout, text="preparation")
	var rest_label = new Label(parent=h3_layout, text="rest")
	var exercise_label = new Label(parent=h4_layout, text="exercise")
	var duration_label = new Label(parent=h5_layout, text="duration")
	var remaining_round_label = new ConfigurableLabel(parent=h1_layout , data= new ParameterData("remaining_round",remaining_round.to_s )) 
	var remaining_exercise_label = new ConfigurableLabel(parent=h4_layout, data= new ParameterData("remaining_exercise",remaining_exercise.to_s )) 

	# Buttons
	var round_button = new ConfigurableButton(parent=h1_layout, data=round_data) is lateinit
	var preparation_button = new ConfigurableButton(parent=h2_layout, data=preparation_data)
	var rest_button = new ConfigurableButton(parent=h3_layout, data=rest_data)
	var exercise_button = new ConfigurableButton(parent=h4_layout, data=exercise_data) is lateinit
	var duration_button = new ConfigurableButton(parent=h5_layout, data=duration_data)
	var play_break_button = new ConfigurablePlayer(parent=bot_v1, size=1.5, data= new ParameterData("play_break","->"))
	var save_button = new Button(parent=bot_v2, text="save", size=1.5)
	var load_button = new Button(parent=bot_v2, text="load", size=1.5)
	var reset_button = new Button(parent=bot_v1, text="reset")

	# View list
	var button_list : Array[ConfigurableButton] = [round_button,preparation_button,rest_button,exercise_button,duration_button,play_break_button]
	var label_list : Array[ConfigurableLabel] = [current_state_label,remaining_round_label,remaining_exercise_label,clock_label]

	# Bind the TextView with their ParameterData
	init
	do
		
		parameter_list = [clock_data,round_data,preparation_data,rest_data,exercise_data,duration_data,current_state_data]
		clock_label.parent= mid_v1
		clock_label.text= clock_data.value
		current_state_label.parent= header_layout
		current_state_label.text = current_state_data.value

	end

	# When the app is close, save a context
	redef fun on_save_state
	do

		app.clock_thread.stop
		refresh_parameter_list
		context = new TabataContext("context",self.parameter_list.as(Array[ParameterData])) 
		app.data_store["context"] = context
		super

	end

	# When the app is restore, load a context
	redef fun on_restore_state
	do

		var context = app.data_store["context"]

		if not context isa TabataContext then return

			self.context = context
			var tabata_window = new TabataWindow
			tabata_window.restore_window(context.tabata_save, false)
			app.push_window tabata_window
			app.clock_thread = new  Timer(tabata_window)
			app.clock_thread.launch

	end

	# Bind ParameterData in Button with parameter_list 
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

	# Bind ParameterData in parameter_list with ConfigurableButton 
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

	# Reset remaining label , current_state, clock 
	fun reset_session
	do

		remaining_round = round_button.data.value.to_i
		remaining_round_label.text = remaining_round.to_s
		remaining_exercise = exercise_button.data.value.to_i
		remaining_exercise_label.text = remaining_exercise.to_s
		app.clock_thread.kill
		current_state_label.refresh(new ParameterData("current_state","config"))

	end

	# Restore a tabata_window using a new parameter_list 
	fun restore_window(parameters: nullable Array[ParameterData], new_session: Bool)
	do

			parameter_list = parameters
			refresh_button_data
			
			if new_session == true then

				print "new session"
				reset_session

			else

				print "same session"
				
			end
	
	end

	# On ButtonPressEvent do something 
	redef fun on_event(event)
	do 

		if event isa ButtonPressEvent then

			# ConfigurablePlayer
			if event.sender isa ConfigurablePlayer then

						# Play
						if play_break_button.state == false then

							if app.clock_thread.is_init == false then

								# Specific case (first application run)
								if current_state_label.data.value == "config" then

									next_state

								end

								app.clock_thread.is_init = true
								app.clock_thread.start

							end

							play_break_button.on_play
							resume_clock

						# Break
						else if play_break_button.state == true then

							app.clock_thread.stop
							play_break_button.on_break
							
						end	

			# Push a ParameterWindow
			else if event.sender isa ConfigurableButton then

				app.clock_thread.stop
				refresh_parameter_list
				app.clock_thread.kill
				app.push_window new ParameterWindow(null, event.sender.as(ConfigurableButton).data, self )

			end

			# Push a SaveWindow
			if event.sender.text == "save" then

				app.clock_thread.stop
				app.push_window new SaveWindow(null, parameter_list.as(Array[ParameterData]), self)

			# Push a LoadWindow	
			else if event.sender.text == "load" then

				app.clock_thread.stop
				app.push_window new LoadWindow(null, self)

			# Reset the session
			else if event.sender.text == "reset" then

				app.clock_thread.stop
				var tabata_window = new TabataWindow
				tabata_window.restore_window(self.parameter_list, true)
				app.push_window tabata_window
				app.clock_thread = new  Timer(tabata_window)
				app.clock_thread.launch

			end

		end

	end

	# Launch the Timer with the current_time
	fun resume_clock
	do

		app.clock_thread.set_current_time(clock_label.text.to_i)
		app.clock_thread.launch

	end

	# Refresh current_state and remaining_exercise, remaining_round
	redef fun next_state
	do

		if current_state_label.data.value == "config" then

			current_state_label.data.value = "preparation"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = preparation_button.data.value.to_i

		else if current_state_label.data.value == "preparation" then

			current_state_label.data.value = "exercise"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = duration_button.data.value.to_i

		else if current_state_label.data.value == "rest" then

			current_state_label.data.value = "exercise"
			current_state_label.text = current_state_label.data.value
			app.clock_thread.current_time = duration_button.data.value.to_i

		else if current_state_label.data.value == "exercise" then

			if remaining_exercise > 0 then

				current_state_label.data.value = "rest"
				current_state_label.text = current_state_label.data.value
				remaining_exercise += -1
				remaining_exercise_label.text = remaining_exercise.to_s 
				app.clock_thread.current_time = rest_button.data.value.to_i

			else if remaining_round > 0 then

					current_state_label.data.value = "preparation"
					current_state_label.text = current_state_label.data.value
					remaining_round += -1
					remaining_round_label.text = remaining_round.to_s 
					remaining_exercise = exercise_data.value.to_i
					remaining_exercise_label.text = remaining_exercise.to_s 
					app.clock_thread.current_time = preparation_button.data.value.to_i

				else

					current_state_label.data.value = "break"
					current_state_label.text = current_state_label.data.value
					app.push_window new SuccessWindow(null,self)

				end
		end

	end

end


# Add the necessary for restore the TabataWindow
redef class ParameterWindow


	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then

				var tabata_window = new TabataWindow
				tabata_window.restore_window(previous_window.parameter_list, false)
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

# Add the necessary for restore the TabataWindow
redef class SuccessWindow

	
	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			var tabata_window = new TabataWindow
			tabata_window.restore_window(previous_window.parameter_list, true)
			app.push_window tabata_window
			app.clock_thread = new  Timer(tabata_window)
			app.clock_thread.launch

		end

	end

end

# Add the necessary for restore the TabataWindow and save a new context
redef class SaveWindow 
	redef fun on_event(event)
	do

		# Save the current config
		if event isa ButtonPressEvent then

			save_context(save_text_input.text.to_s)
			var tabata_window = new TabataWindow
			tabata_window.restore_window(previous_window.parameter_list, false)
			app.push_window tabata_window
			app.clock_thread = new  Timer(tabata_window)
			app.clock_thread.launch

		end

	end

	# app.data_store["saves"] is a context containing HashMap
	fun save_context(name : String)
	do

		var save_context = app.data_store["saves"]

		if not save_context isa SaveContext then

			var map = new HashMap[String, TabataContext]
			map["default"] = previous_window.context
			var saves = new SaveContext("saves", map) 
			app.data_store["saves"] = saves
			save_context = app.data_store["saves"]

		end

		save_context = app.data_store["saves"].as(SaveContext)
		var new_save = new TabataContext("save1",previous_window.parameter_list.as(Array[ParameterData])) 
		var new_map = save_context.map
		new_map[save_text_input.text.to_s] = new_save
		save_context.map = new_map  
		app.data_store["saves"] = save_context

	end

end

# Add the necessary for restore the TabataWindow with a specific context
redef class LoadWindow 
	
	redef fun on_event(event)
	do

		if event isa ButtonPressEvent then

			if event.sender.text == "back" or event.sender.text == "" then

				var tabata_window = new TabataWindow
				tabata_window.restore_window(previous_window.parameter_list, false)
				app.push_window tabata_window
				app.clock_thread = new  Timer(tabata_window)
				app.clock_thread.launch

			else
			
				selected_save = event.sender.text.to_s
				var tabata_window = new TabataWindow
				var saves_context = app.data_store["saves"].as(SaveContext)
				var save = saves_context.map[selected_save]
				tabata_window.restore_window(save.tabata_save, true)
				app.push_window tabata_window
				app.clock_thread = new  Timer(tabata_window)
				app.clock_thread.launch

			end

		end

	end

end

# Entry point, push the main window (TabataWindow), hold the timer  
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
