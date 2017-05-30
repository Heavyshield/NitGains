module nitGains is
	app_name "app.nit NitGains"
	app_version(0, 0, git_revision)
	app_namespace "org.nitlanguage.nitGains"
	android_api_target 15
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

