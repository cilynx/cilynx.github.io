for f in *.*; do   mv "$f" "$(md5sum "$f" | cut -d' ' -f1).${f##*.}"; done
