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

module load_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import configurable_window
import tabata_context

# Window containing a list of the different saves (context)
class LoadWindow

	super Window

	var previous_window : ConfigurableWindow
	var root_layout = new VerticalLayout(parent=self)
	var context_list_label = new Label(parent=root_layout)
	var selected_save : String = "null"
	var label_1 = new Label
	var button_list = new Array[Button]
	var back = new Button(parent=root_layout, text="back", size=1.5)

	# Generate Array[Button] holding the saves name
	init 
	do 

		var rows = [[""],[""],[""],[""],
					[""],[""],[""],[""],
					[""],[""],[""],[""],
					[""],[""],[""],[""]]

		for row in rows do

			var rows_layout = new HorizontalLayout(parent= root_layout)

			for button in row do

				var button_view = new Button(parent=root_layout, text= button)
				button_list.add button_view

			end

		end

		# Saves is a SaveContext containing a HashMap of TabataContext
		var saves = app.data_store["saves"].as(SaveContext)

		var i = 0

		for name, context in saves.map do 

			button_list[i].text = name

			i = i + 1

		end 

	end

end


