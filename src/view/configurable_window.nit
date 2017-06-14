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

module configurable_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import app::http_request
import tabata_context

# abstract Window containing the data part + the clock 
abstract class ConfigurableWindow 
	super Window 

	# Contain all parameters data, round, exercise , rest etc...
	var parameter_list : nullable Array[ParameterData]
	var configurable_button_list : nullable Array[ConfigurableButton]
	var clock_data = new ParameterData("clock","10")
	var current_state_data = new ParameterData("current_state","config")

	# Clock
	var clock_label = new Clock(data=clock_data) is lateinit
	var current_state_label = new ConfigurableLabel(data=current_state_data) is lateinit

	# Context with the paramater needed for the restoration
	var context = new TabataContext("context" , self.parameter_list.as(Array[ParameterData])) is lazy

	# is redef in tabata_view
	fun next_state
	do

	end

end




