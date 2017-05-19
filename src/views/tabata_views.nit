module tabata_views

import app::ui
import app::data_store
import android::aware
import nitGains_data
import date



class Horloge

	#super TextView
	 super Button
	#var native = new NativeService

end

class HorlogeEvent

super ViewEvent
redef type VIEW: Horloge

end

class TabataWindow
	super Window

	var horloge_time = new Time(0,0,30)
	var current_state = "config"
	
	#ParameterData
	var timer_data = new ParameterData("time",30)
	var round_data = new ParameterData("round",1)
	var preparation_data  = new ParameterData("preparation",15)
	var rest_data = new ParameterData("rest",30)
	var exercise_data = new ParameterData("exercise",5)
	var duration_data = new ParameterData("duration",30)
	
	var parameter_list : nullable Array[ParameterData]
	#var parameter_list = new Array[timer_data,round_data,preparation_data,rest_data,exercise_data,duration_data]

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
	var round_button = new Button(parent=h_layout, text=round_data.value.to_s)
	var preparation_button = new Button(parent=h1_layout, text=preparation_data.value.to_s)
	var rest_button = new Button(parent=h2_layout, text=rest_data.value.to_s)
	var exercise_button = new Button(parent=h3_layout, text=exercise_data.value.to_s)
	var play_break_button = new Button(parent=bot_v1, text="->", size=1.5)
	var reset_button = new Button(parent=bot_v2, text="reset", size=1.5)



	#Horloge manuel Todo thread nit pour la generation d'events
	
	var timer_decrement = new Button(parent=mid_v1, text="<-")
	
	#----------------------------------------------------------


	init
	do
		#Rebint parameterData with parameter_list
		if parameter_list == null then
			parameter_list = [timer_data,round_data,preparation_data,rest_data,exercise_data,duration_data]

		end

	end

	fun refresh_parameter
	do
	#pb dans le refresh
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
			print "round data value"
			print round_data.value
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
	#TODO parameters est null Warning
		print "restore"
		print parameters

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

			#Fake event on horloge_time déclanche l'event en cliquant sur l'horloge
			if event.sender isa Horloge then
				if horloge_time.second == 0 then
					print "next_state "
					next_state
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

					else if event.sender == reset_button then

					app.push_window new TabataWindow(null)

					else if event.sender == timer_decrement then
					horloge_time = new Time(0,0,horloge_time.second - 1)
					timer_button.text = horloge_time.second.to_s
					end
			end
		end
	end

	fun next_state
	do

	end

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

			else if event.sender == previous_value then

				button_data.value += -1
				button_value.text = button_data.value.to_s

			else if event.sender == next_value then

				button_data.value += 1
				button_value.text = button_data.value.to_s

			end

		end

	end

end


