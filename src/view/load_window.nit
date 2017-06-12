module load_window

import app::ui
import app::data_store
import android::aware
import nitGains_data
import configurable_view
import date
import configurable_window
import tabata_context

#TODO lister toutes les sauvegarde dans app::data_store
class LoadWindow

	super Window

	var previous_window : ConfigurableWindow


	var root_layout = new VerticalLayout(parent=self)
	var context_list_label = new Label(parent=root_layout)
	var selected_save : String = "null"
	var label_1 = new Label

	var button_list = new Array[Button]

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


		#saves is a SaveContext containing TabataContext
		var saves = app.data_store["saves"].as(SaveContext)

		var i = 0



			for name, context in saves.map do 

			button_list[i].text = name

			i = i + 1

			end 

	


	end

end


