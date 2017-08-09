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

module success_window

import app::ui
import app::data_store
import android::aware
import configurable_window

# Window push at the end of a session (when remaining_exercise and remaining_round are at 0)
class SuccessWindow

	super Window

	var previous_window : ConfigurableWindow
	var root_layout = new VerticalLayout(parent=self)
	var success_label = new Label(parent=root_layout, text="you did it", size=5.5)
	var back_button = new Button(parent=root_layout, text="back", size=1.5)

end