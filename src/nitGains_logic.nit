module nitGains_logic

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
	var break_button = new Button(parent=bot_v1, text="||")
	var play_button = new Button(parent=bot_v2, text="->")

	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then
			title.text = "something happen"
			eventWindow(event)
		end
	end

	fun eventWindow(event: ButtonPressEvent)
	do
		app.push_window new ButtonWindow
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
	var conf = new Label(parent=root_layout, text="conf")
	var back = new Button(parent=root_layout, text="back")

	redef fun on_event(event)
	do 
		if event isa ButtonPressEvent then
			app.push_window new TabataWindow
		end
	end

end


