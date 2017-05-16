module tabata_views

import app::ui
import app::data_store
import android::aware



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

	#Buttons
	var timer_button = new Button(parent=mid_v1, text="00:00")
	var round_button = new Button(parent=h_layout, text="1")
	var preparation_button = new Button(parent=h1_layout, text="10")
	var rest_button = new Button(parent=h2_layout, text="20")
	var exercise_button = new Button(parent=h3_layout, text="30")
	var break_button = new Button(parent=bot_v1, text="||", size=1.5)
	var play_button = new Button(parent=bot_v2, text="->", size=1.5)

	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then
			if event.sender == round_button then
			eventWindow(event)
			end
		end
	end

	fun eventWindow(event: ButtonPressEvent)
	do
		var window = new ButtonWindow
		app.push_window window
	end



end

class TimerWindow
	super Window


	var layout = new VerticalLayout(parent=self)

	var timer_label = new Label(parent=layout, text="00:00")

end

class ButtonWindow
	super Window
	var root_layout = new VerticalLayout(parent=self)
	var set_value_layout = new HorizontalLayout(parent=root_layout)

	var previous_value = new Button(parent=set_value_layout, text="<")
	var button_value = new Button(parent=set_value_layout, text="0")
	var next_value = new Button(parent=set_value_layout, text=">")
	var back = new Button(parent=root_layout, text="back", size=1.5)

	redef fun on_event(event)
	do
		
		if event isa ButtonPressEvent then

			#automatiser la selection du bouton
			if event.sender == back then
				var tabata_window = new TabataWindow
				tabata_window.round_button.text = button_value.text
				app.push_window tabata_window
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


