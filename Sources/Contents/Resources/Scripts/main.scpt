# Applescript create by chris1111
# GifExtract Copyright (c) 2024 chris1111 All rights reserved.
tell application "GifExtract"
	activate
end tell
tell application "Finder"
	if exists file "Macintosh HD:usr:local:bin:python3" then
		set theAlertText to "python3 exists, ok proceed."
		display alert "Checking existing python3" message (theAlertText as text) buttons "OK" default button "OK" giving up after 3
	else
		display dialog "To use this program you must have python3 installed
Quit and install python3." with icon note buttons {"Quit"} cancel button "Quit" default button {"Quit"}
		tell application GifExtract to quit
	end if
end tell
tell application "GifExtract"
	activate
end tell
display dialog "Welcome GifExtract
python3 is installed. 
OK  ✅
" with icon note buttons {"Quit", "OK"} default button ("OK") cancel button "Quit"

set gifFiles to choose file of type {"public.image"} with prompt "Choose GIF's images" with multiple selections allowed
set dest to quoted form of POSIX path of (choose folder with prompt "Select the folder to save GIF's images frames")

set pScript to quoted form of "from AppKit import NSApplication, NSImage, NSImageCurrentFrame, NSGIFFileType; import sys, os
tName=os.path.basename(sys.argv[1])
dir=sys.argv[2]
app=NSApplication.sharedApplication() 
img=NSImage.alloc().initWithContentsOfFile_(sys.argv[1])
if img:
     gifRep=img.representations()[0]
     frames=gifRep.valueForProperty_('NSImageFrameCount')
     if frames:
         for i in range(frames.intValue()):
             gifRep.setProperty_withValue_(NSImageCurrentFrame, i)
             gifRep.representationUsingType_properties_(NSGIFFileType, None).writeToFile_atomically_(dir + tName + ' ' + str(i + 1).zfill(2) + '.gif', True)
         print (i + 1)"
tell application "GifExtract"
	activate
end tell

repeat with f in gifFiles
	set numberOfExtractedGIFs to (do shell script "/usr/local/bin/python3 -c " & pScript & " " & (quoted form of POSIX path of f) & " " & dest) as integer
end repeat

set theSteps to numberOfExtractedGIFs
set progress total steps to theSteps
set progress completed steps to 0
set progress description to "Exctracting GIF's images ..."
repeat with i from 1 to theSteps
	set progress additional description to "Exctracting with python3 
Processing item " & i & " of " & theSteps
	set progress completed steps to i
	delay 0.1
	set progress additional description to "Extracting gif's frame Done!"
end repeat

tell application "GifExtract"
	activate
end tell
delay 0.2
display alert "Extracting gif" message (gifFiles as text) buttons "Done" default button "Done" giving up after 5
delay 0.5
tell application "GifExtract"
	activate
end tell
set theAction to button returned of (display dialog "Do you whant convert gif's frame to .PNG?
" with icon note buttons {"No", "Convert"} default button ("Convert"))
if theAction = "No" then
	do shell script "open " & dest
end if
if theAction = "Convert" then
	do shell script "sips -s  format png  " & dest & "/*.gif --out " & dest
	delay 2
	do shell script "rm -rf  " & dest & "/*.gif"
	delay 1
	do shell script "open " & dest
end if

