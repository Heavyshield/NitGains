module android15

import nitGains
import android 



redef class TextView
	init do set_android_style(native, app.native_activity)
	private fun set_android_style(java_text_view: NativeTextView, activity: NativeActivity)
		in "Java" `{

			int back_color_id = 0;
			back_color_id = R.color.dark_orange;
			java_text_view.setTextColor(back_color_id);

		
		java_text_view.setBackgroundResource(back_color_id);
		java_text_view.setGravity(android.view.Gravity.CENTER);
		java_text_view.setAllCaps(false);
	`}
end






