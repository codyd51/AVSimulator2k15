AVSimulator2k15
----------------

**This tweak is not an antivirus**

This tweak merely mimics the _experience_ of having an antivirus by constantly telling the user their antivirus is out of date.

The alert triggers at a random time every 20 minutes to 1 hour.

Technically, this tweak is unimpressive, aside from one code snippet. 
This tweak injects into SpringBoard. If we were to simply add our views to `[[UIApplication sharedApplication] keyWindow]`, it would not show up when looking at an app (or anything else that isn't the homescreen).
Instead, we use FrontBoard's scene and screen managers to retreive the device's main screen, and add to that.
This ensures our view will display on top of _absolutely everything_.
We must overengineer for maximum annoyance.

Is this a good idea? Who cares. You should have thought of that before installing an antivirus in the year 2015!

GPL v3.
