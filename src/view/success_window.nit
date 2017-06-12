module success_window

import app::ui
import app::data_store
import android::aware
import configurable_window

class SuccessWindow
	super Window

	var previous_window : ConfigurableWindow

	var root_layout = new VerticalLayout(parent=self)
	var success_label = new Label(parent=root_layout, text="you did it", size=5.5)
	var back_button = new Button(parent=root_layout, text="back", size=1.5)

end