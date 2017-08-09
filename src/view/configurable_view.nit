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

# Specialisations of TextView for adding a ParameterData
module configurable_view

import app::ui
import app::data_store
import android::aware
import nitGains_data

# Button with a ParameterData
class ConfigurableButton

	super Button

	var data : ParameterData is public writable

	init
	do
		self.text = data.value

	end

	fun refresh(new_data : ParameterData) 
	do
		data = new_data
		self.text = data.value
	end
end

#Button with a ParameterData and a state
class ConfigurablePlayer

	super ConfigurableButton

	var state = false

	fun on_break
	do

		state = false
		self.text = "->"

	end

	fun on_play
	do

		state = true
		self.text = "||"

	end


end

#Button with a ParameterData
class ConfigurableSave

	super ConfigurableButton

end

#Label with a ParameterData
class ConfigurableLabel

	super Label

	var data : ParameterData is public writable

	init
	do
		self.text = data.value
	end

	fun refresh(new_data : ParameterData) 
	do
		data = new_data
		self.text = data.value
	end

end

#Label with a ParameterData
class Clock

	 super ConfigurableLabel

end