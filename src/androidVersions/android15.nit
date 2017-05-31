module android15

import nitGains
import android 

redef class TextInput
	init do set_android_style(native, app.native_activity)

	# Set text style and hide cursor
	private fun set_android_style(java_edit_text: NativeEditText, activity: NativeActivity)
	in "Java" `{

		java_edit_text.setBackgroundResource(R.color.display_background_color);
		java_edit_text.setTextColor(
			activity.getResources().getColor(R.color.display_formula_text_color));
		java_edit_text.setTextSize(android.util.TypedValue.COMPLEX_UNIT_FRACTION, 120.0f);
		java_edit_text.setCursorVisible(false);
		java_edit_text.setGravity(android.view.Gravity.CENTER_VERTICAL | android.view.Gravity.END);
	`}
end

redef class Button
	init do set_android_style(native, app.native_activity)
	private fun set_android_style(java_button: NativeButton, activity: NativeActivity)
		in "Java" `{

			int back_color_id = 0;
			back_color_id = R.color.dark_orange;
			java_button.setTextColor(back_color_id);

		
		java_button.setBackgroundResource(back_color_id);
		java_button.setGravity(android.view.Gravity.CENTER);
		java_button.setAllCaps(false);
		java_button.setTextSize(android.util.TypedValue.COMPLEX_UNIT_FRACTION, 100.0f);
	`}
end

