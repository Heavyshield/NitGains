module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data




class TabataWindow
	super Window


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
	var h_layout = new HorizontalLayout(parent=mid_v2)
	var h1_layout = new HorizontalLayout(parent=mid_v2)
	var h2_layout = new HorizontalLayout(parent=mid_v2)
	var h3_layout = new VerticalLayout(parent=mid_v2)

	#Values
	var timer_value = "00:00"
	var round_value = "1"
	var preparation_value = "15"
	var rest_value = "30"
	var exercise_value = "5"
	var break_value = "||"
	var play_value = "->"

	#Buttons
	var timer_button = new Button(parent=mid_v1, text=timer_value)
	var round_button = new Button(parent=h_layout, text=round_value)
	var preparation_button = new Button(parent=h1_layout, text=preparation_value)
	var rest_button = new Button(parent=h2_layout, text=rest_value)
	var exercise_button = new Button(parent=h3_layout, text=exercise_value)
	var break_button = new Button(parent=bot_v1, text=break_value, size=1.5)
	var play_button = new Button(parent=bot_v2, text=play_value, size=1.5)



	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then
			if event.sender == round_button then
			push_button_window(new ParameterData("round",round_button.text.to_i))

			else if event.sender == preparation_button then
			push_button_window(new ParameterData("preparation",round_button.text.to_i))

			else if event.sender == rest_button then
			push_button_window(new ParameterData("rest",round_button.text.to_i))

			else if event.sender == exercise_button then
			push_button_window(new ParameterData("exercise",round_button.text.to_i))

			end
		end
	end

	fun push_button_window(parameter_data : ParameterData )
	do
		var button_window = new ButtonWindow
		button_window.button_data = parameter_data
		button_window.button_value.text = parameter_data.parameter_value.to_s

		print "button data send"
		print parameter_data.parameter_name
		print parameter_data.parameter_value

		app.push_window button_window
	end
end

class TimerWindow
	super Window

	var layout = new VerticalLayout(parent=self)
	var timer_label = new Label(parent=layout, text="00:00")

end

class ButtonWindow
	super Window

	var button_data = new ParameterData("",0)
	var tabata_context = new TabataWindow

	var root_layout = new VerticalLayout(parent=self)
	var set_value_layout = new HorizontalLayout(parent=root_layout)
	var previous_value = new Button(parent=set_value_layout, text="<")
	var button_value = new Button(parent=set_value_layout, text=button_data.parameter_value.to_s)
	var next_value = new Button(parent=set_value_layout, text=">")
	var back = new Button(parent=root_layout, text="back", size=1.5)

	fun restore_tabata_window
	do
		if button_data.parameter_name == "round" then
		tabata_context.round_button.text = button_value.text
		
		else if button_data.parameter_name == "preparation" then
		tabata_context.preparation_button.text = button_value.text
		
		else if button_data.parameter_name == "rest" then
		tabata_context.rest_button.text = button_value.text

		else if button_data.parameter_name == "exercise" then
		tabata_context.exercise_button.text = button_value.text

		end
		app.push_window tabata_context
	end

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then
				self.restore_tabata_window
				
			else if event.sender == previous_value then

			var value = button_value.text.to_i - 1
				button_value.text = value.to_s

			else if event.sender == next_value then

				var value = button_value.text.to_i + 1
				button_value.text = value.to_s

			end

		end

	end

end


