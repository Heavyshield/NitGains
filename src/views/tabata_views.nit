module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data
import date



class Horloge

	super Button

end

class HorlogeEvent

super ViewEvent
redef type VIEW: Horloge

end

class TabataWindow
	super Window

	var horloge_time = new Time(0,0,30)

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

	#Buttons
	var timer_button = new Horloge(parent=mid_v1, text=horloge_time.second.to_s)
	var round_button = new Button(parent=h_layout, text="1")
	var preparation_button = new Button(parent=h1_layout, text="15")
	var rest_button = new Button(parent=h2_layout, text="30")
	var exercise_button = new Button(parent=h3_layout, text="5")
	var break_button = new Button(parent=bot_v1, text="||", size=1.5)
	var play_button = new Button(parent=bot_v2, text="->", size=1.5)



	#Horloge manuel Todo thread nit pour la generation d'events
	
	var timer_decrement = new Button(parent=mid_v1, text="<-")
	
	#----------------------------------------------------------



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

			else if event.sender == timer_button then
			print "event"
			

			end

		else if event isa HorlogeEvent then
			if event.sender == timer_decrement then
			horloge_time = new Time(0,0,horloge_time.second - 1)
			timer_button.text = horloge_time.second.to_s
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


