module nitGains is
	app_name "app.nit NitGains"
	app_version(0, 0, 1)
	app_namespace "Heavyshield.NitGains"
	android_api_target 14
end

import app::ui
import app::data_store
import android::aware
import tabata_view


redef class App
	redef fun on_create
	do
		push_window new TabataWindow(null)
		super
	end
end

