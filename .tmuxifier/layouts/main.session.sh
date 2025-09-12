# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/projects/chatting/websocket-chat-app/backend/"

# Create new window. If no argument is given, window name will be based on
# layout file name.

if initialize_session "main"; then

  new_window "backend"
	run_cmd "nvim ."

	new_window "server"
	split_h 30
	select_pane 0
	run_cmd "npm run dev"

	new_window "frontend"
	run_cmd "cd ../frontend/"
	run_cmd "nvim ."

	new_window "client"
	run_cmd "cd ../frontend/"
	run_cmd "npm run dev"

	select_window 1 

fi

finalize_and_go_to_session
