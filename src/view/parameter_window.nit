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

module parameter_window

import app::ui
import android::aware
import nitGains_data
import configurable_view
import configurable_window

# Window used for set a new value to a Parameter
class ParameterWindow

	super Window

	var target_data:  ParameterData 
	var previous_window : ConfigurableWindow
	var root_layout = new VerticalLayout(parent=self)
	var set_value_layout = new HorizontalLayout(parent=root_layout)
	var previous_value = new Button(parent=set_value_layout, text="<")
	var button_value =  new Button(parent=set_value_layout, text=target_data.value) is lateinit
	var next_value = new Button(parent=set_value_layout, text=">") is lateinit
	var back = new Button(parent=root_layout, text="back", size=1.5)

end


