# NitGains

## Project structure
### View/
- **tabata_view** main window (activity) of the application with all the logic of a tabata app.
- **configurable_window** abstract window used by tabata_view.
- **configurable_view** specialise TextView for specific TextView like ConfigurableButton
- **load_window** list all saves
- **save_window** TextInput for save the current context
- **success_window** push when the session (all the exercies) are terminated
### Model/
- **timer_model** implement a thread use as a Timer by the app.
### Data/
- **nitGains_data** data format (ParameterData).
- **tabata_context** contain TabataContext and SavesContext, hold the ParemeterData of the app. 
### android/
- Graphic part specific for the android platform
### androidVersions/
- Adapt the app to the target API (API 15 for the moment)

## Compilation

Compile and run on the desktop (GNU/Linux and OS X) with:

>make linux
 
Compile for Android and install on a device or emulator with:

 >make androidApk

## Clean

Clean bin/ and data_store.db

>make clean

