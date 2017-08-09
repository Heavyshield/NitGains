module save_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date
import configurable_window


class SaveWindow

	super Window

	var parameter_list: Array[ParameterData]
	var previous_window : ConfigurableWindow

	var root_layout = new VerticalLayout(parent=self)
	var save_label = new Label(parent=root_layout, text="save name :")
	var save_text_input = new TextInput(parent=root_layout)
	var back = new Button(parent=root_layout, text="back", size=1.5)

end


