module android15

import nitGains
import android 



redef class TextView
#view5.setBackgroundResource(R.drawable.butt1_black_border); 
	init do set_android_style(native, app.native_activity)
	private fun set_android_style(java_text_view: NativeTextView, activity: NativeActivity)
		in "Java" `{

			int back_color_id = 0;
			back_color_id = R.color.dark_orange;
			java_text_view.setTextColor(back_color_id);

		
		java_text_view.setBackgroundColor(back_color_id);
		java_text_view.setGravity(android.view.Gravity.CENTER);
		java_text_view.setAllCaps(false);
		java_text_view.setBackgroundResource(R.drawable.button_custom);

	`}
end






