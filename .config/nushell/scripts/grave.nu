const MAX_SESSIONS = 10

def fix-nix-paths [session_name: string] {
    let session_info_dir = (get-session-info-dir $session_name)
    if $session_info_dir == null {
        return
    }
    
    let layout_file = $"($session_info_dir)/($session_name)/session-layout.kdl"
    
    if ($layout_file | path exists) {
        let content = (open $layout_file --raw)
        if ($content | str contains "/nix/store/") {
            ^sed -i 's|command "/nix/store/[^"]*/bin/nvim"|command="nvim"|g' $layout_file
            ^sed -i '/args "--cmd" "lua dofile/d' $layout_file
            ^sed -i 's|/nix/store/[^/]*/bin/||g' $layout_file
        }
    }
}

def get-session-info-dir [session_name: string] {
    let session_dir = $"($env.HOME)/.cache/zellij"
    
    # Search all version directories for the session
    let version_dirs = (ls $session_dir | where type == dir | get name)
    
    for dir in $version_dirs {
        let session_path = $"($dir)/session_info/($session_name)"
        if ($session_path | path exists) {
            return $"($dir)/session_info"
        }
    }
    
    null
}

def get-session-details [session_name: string] {
    let session_info_dir = (get-session-info-dir $session_name)
    if $session_info_dir == null {
        return { cwd: "unknown", tabs: 0, commands: [], branch: "" }
    }
    
    let layout_file = $"($session_info_dir)/($session_name)/session-layout.kdl"
    
    if ($layout_file | path exists) {
        let content = (open $layout_file --raw)
        
        # Get cwd (keep raw for git check)
        let cwd_raw = ($content | parse --regex 'cwd "([^"]+)"' | get -o capture0 | first | default "")
        let cwd = if $cwd_raw == "" { "unknown" } else { $cwd_raw | str replace $env.HOME "~" }
        
        # Count tabs
        let tabs = ($content | split row "tab name=" | length) - 1
        
        # Get running commands (exclude shells, extract basename from full paths)
        let commands = ($content 
            | parse --regex 'pane command="([^"]+)"' 
            | get -o capture0 
            | each { |cmd| $cmd | path basename }
            | uniq 
            | where { |cmd| $cmd not-in ["nu", "bash", "zsh", "fish", "sh"] }
        )
        
        # Get git branch
        let branch = if $cwd_raw != "" and ($cwd_raw | path exists) {
            let result = (do { ^git -C $cwd_raw rev-parse --abbrev-ref HEAD } | complete)
            if $result.exit_code == 0 { $result.stdout | str trim } else { "" }
        } else { "" }
        
        { cwd: $cwd, tabs: $tabs, commands: $commands, branch: $branch }
    } else {
        { cwd: "unknown", tabs: 0, commands: [], branch: "" }
    }
}

def get-zellij-sessions [] {
    let output = (zellij list-sessions --no-formatting | lines)
    
    $output | each { |line|
        let parts = ($line | split row " ")
        let session_name = ($parts | first)
        
        let status = if ($line | str contains "EXITED") {
            "exited"
        } else if ($line | str contains "current") {
            "current"
        } else {
            "active"
        }
        
        let details = (get-session-details $session_name)
        
        # Build display: cwd (branch) │ commands │ tabs
        let cwd_branch = if $details.branch != "" { $"($details.cwd) \(($details.branch)\)" } else { $details.cwd }
        let cmd_str = if ($details.commands | is-empty) { "" } else { $details.commands | str join " " }
        let tab_str = if $details.tabs > 1 { $"($details.tabs) tabs" } else { "" }
        let info_parts = ([$cmd_str, $tab_str] | where { |p| $p != "" } | str join " │ ")
        let info = if $info_parts != "" { $" │ ($info_parts)" } else { "" }
        
        {
            name: $session_name
            cwd: $details.cwd
            status: $status
            display: $"($cwd_branch)($info)"
        }
    }
}

def cleanup-old-sessions [] {
    let sessions = (get-zellij-sessions)
    let exited_sessions = ($sessions | where status == "exited")
    
    if ($exited_sessions | length) > $MAX_SESSIONS {
        let to_delete = ($exited_sessions | skip $MAX_SESSIONS)
        
        for session in $to_delete {
            zellij delete-session $session.name --force
        }
    }
}

def run-picker [--exclude-current (-e) --fullscreen (-f)] {
    cleanup-old-sessions
    let margin = if $fullscreen { "0%,0%" } else { "15%,15%" }
    let exclude_flag = if $exclude_current { "--exclude-current" } else { "" }

    print --stderr -n "\e[2 q"
    let output = try {
        ^nu --no-config-file -c $"use ~/.config/nushell/scripts/grave.nu *; grave fzf-inner --margin '($margin)' ($exclude_flag)"
    } catch { "" }
    print --stderr -n "\e[0 q"

    let output = ($output | str trim)
    if $output == "" { null } else { $output }
}

export def "grave fzf-inner" [--margin: string = "15%,15%" --exclude-current --edit] {
    let sessions = (get-zellij-sessions)
    let filtered = if $exclude_current {
        $sessions | where status != "current"
    } else {
        $sessions
    }
    
    if ($filtered | is-empty) {
        return
    }
    
    let lines_cmd = if $exclude_current {
        "nu -c \"use ~/.config/nushell/scripts/grave.nu *; grave list-display --exclude-current\""
    } else {
        "nu -c \"use ~/.config/nushell/scripts/grave.nu *; grave list-display\""
    }
    
    let exclude_flag = if $exclude_current { "--exclude-current" } else { "" }
    let toggle_edit = if $edit { "" } else { "--edit" }
    let become_cmd = $"nu -c \"use ~/.config/nushell/scripts/grave.nu *; grave fzf-inner --margin '($margin)' ($exclude_flag) ($toggle_edit)\""
    let delete_cmd = $"nu -c \"use ~/.config/nushell/scripts/grave.nu *; grave delete-session {2}\"; " + $become_cmd
    
    let colors = if $edit {
        "label:#ff9c59,border:#ff9c59,prompt:#ff9c59,fg+:#0a0400,bg+:#ff9c59,hl:#ff6600,hl+:#ffffff,separator:#ff9c59"
    } else {
        "label:#ff6600,border:#ff6600,prompt:#ff6600,fg+:#0a0400,bg+:#ff6600,hl:#ff9c59,hl+:#ffffff,separator:#ff6600"
    }
    
    let label = if $edit { " EDIT " } else { " Grave " }
    let header = if $edit { "  Tab: normal │ d: delete │ Esc: close" } else { "  Tab: edit mode │ Enter: switch │ Esc: close" }
    
    let mode_binds = if $edit {
        $"--disabled '--bind=j:down,k:up,h:first,l:last,d:become(($delete_cmd)),tab:become(($become_cmd))'"
    } else {
        $"'--bind=tab:become(($become_cmd))'"
    }
    
    let lines = ($filtered | each { |s|
        let status_icon = match $s.status {
            "exited" => "󰆍"
            "current" => ""
            "active" => ""
            _ => " "
        }
        $"($status_icon) ($s.name) │ ($s.display)"
    } | str join "\n")
    
    let fzf_args = [
        "--ansi" "--layout=reverse" "--info=inline-right" "--separator=─" 
        "--border=sharp" $"--border-label=($label)" "--prompt= " "--pointer=" 
        "--highlight-line" $"--color=($colors)" $"--header=($header)" 
        "--delimiter=│" $"--margin=($margin)" "--with-nth=1.."
    ]
    
    let bind_arg = if $edit {
        "--bind=j:down,k:up,h:first,l:last,d:become(" + $delete_cmd + "),tab:become(" + $become_cmd + ")"
    } else {
        "--bind=tab:become(" + $become_cmd + ")"
    }
    
    let result = try {
        if $edit {
            $lines | ^fzf ...$fzf_args "--disabled" $bind_arg
        } else {
            $lines | ^fzf ...$fzf_args $bind_arg
        }
    } catch { "" } 

    if ($result | str trim) != "" {
        $result | split row "│" | first | str trim | split row " " | last | str trim
    }
}

export def "grave delete-session" [name: string] {
    try { zellij delete-session $name --force }
}

export def main [--switch (-s)] {
    let inside_zellij = ($env | get -o ZELLIJ | is-not-empty)
    
    if $inside_zellij and not $switch {
        zellij action launch-or-focus-plugin "session-manager" --floating --move-to-focused-tab
    } else {
        let session_name = (run-picker)
        if $session_name != null and $session_name != "" {
            fix-nix-paths $session_name
            sleep 50ms
            ^zellij attach $session_name
        }
    }
}

export def switch [] {
    let pid_file = "/tmp/grave-pid"
    
    if ($pid_file | path exists) {
        try { ^kill (open $pid_file | str trim) }
        rm -f $pid_file
        exit
    }
    
    $nu.pid | into string | save -f $pid_file
    let session_name = (run-picker --exclude-current --fullscreen)
    rm -f $pid_file
    
    if $session_name != null and $session_name != "" {
        fix-nix-paths $session_name
        sleep 50ms
        ^zellij action switch-session $session_name
    }
}

export def toggle [] {
    let layout = (zellij action dump-layout)
    # Look for a pane with name="Grave" and extract its id
    let grave_match = ($layout | parse --regex 'pane.*id=(\d+).*name="Grave"' | get -o capture0 | first)

    if $grave_match != null {
        # Grave pane exists, close it by ID
        zellij action close-pane --pane-id $grave_match
    } else {
        # No Grave pane, create one
        zellij run --floating --close-on-exit --name "Grave" -- nu --no-config-file -c "use ~/.config/nushell/scripts/grave.nu *; grave switch"
    }
}

export def clean [--keep (-k): int = 10] {
    let sessions = (get-zellij-sessions)
    let exited_sessions = ($sessions | where status == "exited")
    
    if ($exited_sessions | length) <= $keep {
        let count = ($exited_sessions | length)
        print $"Only ($count) exited sessions, nothing to clean."
        return
    }
    
    let to_delete = ($exited_sessions | skip $keep)
    
    for session in $to_delete {
        zellij delete-session $session.name --force
        print $"Deleted: ($session.name)"
    }
    
    let deleted_count = ($to_delete | length)
    print $"Cleaned up ($deleted_count) sessions, kept ($keep) most recent."
}

export def list [] {
    get-zellij-sessions
}

export def list-display [--exclude-current (-e)] {
    let all_sessions = (get-zellij-sessions)
    let sessions = if $exclude_current {
        $all_sessions | where status != "current"
    } else {
        $all_sessions
    }
    
    $sessions | each { |s|
        let status_icon = match $s.status {
            "exited" => "󰆍"
            "current" => ""
            "active" => ""
            _ => " "
        }
        $"($status_icon) ($s.name) │ ($s.display)"
    } | str join "\n"
}
