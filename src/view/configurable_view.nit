module configurable_view

import app::ui
import app::data_store
import android::aware
import nitGains_data


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

class ConfigurablePlayer
	super ConfigurableButton

end

class ConfigurableSave
	super ConfigurableButton

end

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
