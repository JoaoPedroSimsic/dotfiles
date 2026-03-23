const MAX_SESSIONS = 10

def fix-nix-paths [session_name: string] {
    let session_info_dir = (get-session-info-dir)
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

def get-session-info-dir [] {
    let session_dir = $"($env.HOME)/.cache/zellij"
    let version_dirs = (ls $session_dir | where type == dir | where name =~ '\d+\.\d+' | get name)
    
    if ($version_dirs | is-empty) {
        return null
    }
    
    let latest_version_dir = $version_dirs | last
    $"($latest_version_dir)/session_info"
}

def get-cwd-for-session [session_name: string] {
    let session_info_dir = (get-session-info-dir)
    if $session_info_dir == null {
        return "unknown"
    }
    
    let layout_file = $"($session_info_dir)/($session_name)/session-layout.kdl"
    
    if ($layout_file | path exists) {
        let content = (open $layout_file --raw)
        let cwd_match = ($content | parse --regex 'cwd "([^"]+)"' | get -o capture0 | first | default "unknown")
        $cwd_match | str replace $env.HOME "~"
    } else {
        "unknown"
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
        
        let cwd = (get-cwd-for-session $session_name)
        
        {
            name: $session_name
            cwd: $cwd
            status: $status
            display: $"($session_name) │ ($cwd)"
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

def run-picker [] {
    cleanup-old-sessions
    
    let sessions = (get-zellij-sessions)
    
    if ($sessions | is-empty) {
        print ""
        try {
            "  No sessions in the graveyard" | ^fzf --ansi --reverse --border=bold --border-label=" 󰘁 Graveyard " --prompt=" " --pointer=" " --color="label:#ff6600,border:#ff6600,prompt:#ff6600,pointer:#ff6600" --disabled --header="  Press ESC to exit" | ignore
        }
        return null
    }
    
    let display_lines = ($sessions | each { |s|
        let status_icon = match $s.status {
            "exited" => "󰆍"
            "current" => ""
            "active" => ""
            _ => " "
        }
        $"($status_icon) ($s.display)"
    })
    
    let tmp_out = (mktemp -t grave_out.XXXXXX)
    
    print --stderr -n "\e[2 q"

    try {
        $display_lines 
        | str join "\n" 
        | ^fzf --ansi --margin=15%,20% --layout=reverse --info=inline-right --separator="─" --border=sharp --border-label=" Grave " --prompt=" " --pointer=" " --highlight-line --color="label:#ff6600,border:#ff6600,prompt:#ff6600,fg+:#000000,bg+:#ff6600,hl:#ff9c59,hl+:#ffffff,separator:#ff6600" 
        | save -f $tmp_out
    }

    print --stderr -n "\e[0 q"

    let selected = (open $tmp_out | str trim)
    rm -f $tmp_out

    if ($selected | is-empty) {
        return null
    }
    
    let session_name = ($selected | split row "│" | first | str trim | split row " " | last | str trim)
    $session_name
}

export def main [] {
    let inside_zellij = ($env | get -o ZELLIJ | is-not-empty)
    
    if $inside_zellij {
        zellij action launch-or-focus-plugin "session-manager" --floating --move-to-focused-tab
    } else {
        let session_name = (run-picker)
        if $session_name != null and $session_name != "" {
            fix-nix-paths $session_name
            ^zellij attach $session_name
        }
    }
}

export def "grave clean" [--keep (-k): int = 10] {
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

export def "grave list" [] {
    get-zellij-sessions
}
