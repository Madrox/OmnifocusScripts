(*

This script:
1. Looks in Omnifocus's inbox for any email-formatted tasks from Luxer package systems (to arrange this step, add a forwarding rule in your email to your omnifocus task email receiver)
2. Sets a due date to today
3. Moves it into a project (currently "Daily Checklist")

*)

on findPackageCode(delim, currentNote)
	log currentNote
	log "entering..."
	set AppleScript's text item delimiters to delim
	set theTextItems to every text item of currentNote
	set AppleScript's text item delimiters to ""
	log theTextItems
	return "Package code " & ((characters 1 thru 6 of (text item 2 of theTextItems)) as string)
end findPackageCode

on run
	tell application "OmniFocus"
		tell front document
			set theInbox to every inbox task
			set proj to flattened project named "Daily Checklist"
			log proj
			if theInbox is not equal to {} then
				repeat with n from 1 to length of theInbox
					set currentTask to item n of theInbox
					set taskName to name of currentTask
					set taskProject to project
					if taskName starts with "You've got a package" then
						set currentNote to note of currentTask
						set currentTask's due date to current date
						log currentNote
						set currentTask's name to my findPackageCode("enter the access code ", currentNote)
						move currentTask to end of tasks of proj
					end if
					if taskName starts with "Your Package has" then
						set currentNote to note of currentTask
						set currentTask's due date to current date
						log currentNote
						set currentTask's name to my findPackageCode("simply enter code ", currentNote)
						move currentTask to end of tasks of proj
					end if
				end repeat
			end if
		end tell
	end tell
end run
