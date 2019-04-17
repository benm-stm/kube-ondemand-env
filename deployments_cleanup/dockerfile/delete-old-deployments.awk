#!/usr/bin/awk -f

# helm ls | awk -v now_sec=$(date +%s) -v threshold=24 -v now=$(date '+%Y-%m-%d,%H:%M') -f delete-old-deployments.awk

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

BEGIN {
  # age in seconds
  cutoff=threshold * 60 * 60;
  dry_run_mode = dry_run * 1;
}

NR > 1 {
        split($0, elements, /\t/);
        ("date -d '"elements[3]"' +%s") | getline date_sec;
        if ((now_sec - date_sec) > cutoff && trim(elements[4])=="DEPLOYED" ) {
            print(now ": delete "trim(elements[1])" => "trim(elements[3]));
            if(dry_run_mode == 0) {
              system("helm del --purge "elements[1]);
            } else {
              print("helm del --purge "elements[1]);
            }
        }
}