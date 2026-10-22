# Reports each herdr workspace's number as the $index sidebar token (config.toml,
# [ui.sidebar.spaces]); numbers shift when workspaces open or close, so it re-reports
# whenever the list changes. Run hidden: herdr\install.ps1 starts it.
$last = ''
while ($true) {
    try {
        $list = (herdr workspace list 2>$null | ConvertFrom-Json).result.workspaces
        $now = ($list | ForEach-Object { "$($_.workspace_id)=$($_.number)" }) -join ','
        if ($now -ne $last) {
            $seq = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
            foreach ($w in $list) {
                # The workspace ID goes first: herdr rejects options before it.
                herdr workspace report-metadata $w.workspace_id --source space-index --seq $seq --token "index=$($w.number)" *> $null
            }
            $last = $now
        }
    } catch {}
    Start-Sleep -Seconds 2
}
