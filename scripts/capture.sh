#!/bin/sh
# usage: capture.sh shot|rec|reca [region|window|output|W:H]
#          without target: stop recording if running, otherwise enter the submap
#        capture.sh hint [shot|rec|reca]
#          show the submap key hint, or dismiss it without argument
set -eu

action=${1:-}
target=${2:-}

hint_file=$XDG_RUNTIME_DIR/capture-hint

key() {
    printf '<span background="#6B728E" foreground="#F8F8F2"> %s </span>' "$1"
}

hint() {
    if [ -f "$hint_file" ]; then
        makoctl dismiss -n "$(cat "$hint_file")" 2> /dev/null || true
        rm -f "$hint_file"
    fi

    case $1 in
        shot) title='󰄀  Screenshot' ;;
        rec)  title='󰑊  Record' ;;
        reca) title='󰑊  Record  󰕾' ;;
        *)    return 0 ;;
    esac

    # thin spacer lines keep the key caps apart
    gap="
<span size='4pt'> </span>
"
    body="$(key r) 󰩭 region   $(key w) 󰖯 window   $(key m) 󰍹 output$gap$(key 1) 16:9   $(key 2) 4:3   $(key 3) 1:1   $(key 4) 9:16$gap$(key esc) 󰅖 cancel"

    notify-send -p -t 0 -a capture -c "$1" "$title" "$body" > "$hint_file"
}

case $action in
    hint) hint "$target"; exit 0 ;;
    shot|rec|reca) ;;
    *) echo "usage: ${0##*/} shot|rec|reca [region|window|output|W:H] | hint [shot|rec|reca]" >&2; exit 1 ;;
esac

if [ -z "$target" ]; then
    [ "$action" != shot ] && pkill -INT -x wf-recorder && exit 0
    hyprctl dispatch "hl.dsp.submap(\"$action\")" > /dev/null
    exit 0
fi

# Windows on visible workspaces, in slurp's box format
windows() {
    ws=$(hyprctl monitors -j | jq '[.[] | .activeWorkspace.id, .specialWorkspace.id]')
    hyprctl clients -j | jq -r --argjson ws "$ws" '.[]
        | select(.mapped and (.hidden | not) and (.workspace.id | IN($ws[])))
        | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

case $target in
    region) geometry=$(slurp -o) ;;
    window) geometry=$(windows | slurp -r) ;;
    output) geometry=$(slurp -or) ;;
    *:*)    geometry=$(slurp -a "$target") ;;
    *)      echo "unknown target: $target" >&2; exit 1 ;;
esac || exit 0

stamp=$(date +%Y%m%d%H%M%S)

case $action in
shot)
    file=$HOME/Pictures/Capture/$stamp.png
    mkdir -p "${file%/*}"
    grim -g "$geometry" "$file"
    wl-copy --type image/png < "$file"
    size=$(du -h "$file" | cut -f1)
    notify-send -a shot '󰄀  Copied' \
        "${file##*/}
${geometry#* }  ·  $size"
    ;;
rec|reca)
    file=$HOME/Videos/Capture/$stamp.mp4
    mkdir -p "${file%/*}"
    id=$(notify-send -p -t 0 -a record -c recording '󰑊  Recording' \
        "$(key SUPER) + $(key r)  to stop")
    set --
    [ "$action" = reca ] && set -- -a
    wf-recorder "$@" -D -c libx264 -x yuv420p -p color_range=tv -r 15 -g "$geometry" -f "$file"
    wl-copy --type text/uri-list "file://$file"
    secs=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$file")
    secs=${secs%.*}
    size=$(du -h "$file" | cut -f1)
    notify-send -r "$id" -a record -c saved '󰄬  Saved' \
        "${file##*/}
$(printf '%d:%02d' $((secs / 60)) $((secs % 60)))  ·  $size  ·  copied"
    ;;
esac
