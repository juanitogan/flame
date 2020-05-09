# example

Example app showing basic features.

## Running Pogo example apps

If you try to run an example app after cloning this repo and doing nothing more, you will like get an error like the following:

```text
AndroidManifest.xml could not be found.
Please check C:\Users\mj_je\AndroidStudioProjects\pogo\example\android\AndroidManifest.xml for errors.
No application found for TargetPlatform.android_x64.
Is your project missing an android\AndroidManifest.xml?
Consider running "flutter create ." to create one.
```

The solution, basically, is to do what the last line says.  (Note to self: Could use a script for this.)

That is, run `flutter create .` from within each example folder you want to run: `pogo/example`, `pogo/doc/examples/animations`, etc.

> Note: This is not needed for the main project folder, `pogo`, as the Pogo game engine is not a runnable app.

You can delete the new `test` folder for each example project (none use it currently).  If you plan on submitting example app changes to Pogo, please delete the test folder before doing so (unless, of course, the test is truly a part of the example app).

DOS: `rmdir /s test`

If still have trouble with the extremely troublesome Android Studio, try going to File > Project Structure... and fixing any problems found.  (Possible warning here as I have had trouble with things breaking while fixing.)  Also, from "run" dropdown on the toolbar, select Edit Configurations... to resolve any other problems with identifying which example to run.
