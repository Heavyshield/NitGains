module parameter_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date
import configurable_window


class ParameterWindow
	super Window

	public var target_data:  ParameterData 
	var previous_window : ConfigurableWindow

	var root_layout = new VerticalLayout(parent=self)
	var set_value_layout = new HorizontalLayout(parent=root_layout)
	var previous_value = new Button(parent=set_value_layout, text="<")
	var button_value =  new Button(parent=set_value_layout, text=target_data.value) is lateinit
	var next_value = new Button(parent=set_value_layout, text=">") is lateinit
	var back = new Button(parent=root_layout, text="back", size=1.5)

end


