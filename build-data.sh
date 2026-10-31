#!/usr/bin/env sh
# Re-inline src/casestudy-data.js into version files, between the DATA:START and DATA:END markers.
# All versions:  sh build-data.sh        One file:  sh build-data.sh v4-aurora-glass.html
cd "$(dirname "$0")" || exit 1
if [ $# -gt 0 ]; then files="$*"; else files=$(ls v*.html); fi
for f in $files; do
  grep -q '<!-- DATA:START -->' "$f" || { echo "skipped $f (no DATA markers)"; continue; }
  awk -v src=src/casestudy-data.js '
    /<!-- DATA:START -->/{print; print "<script>"; while((getline l < src) > 0) print l; close(src); print "</script>"; skip=1; next}
    /<!-- DATA:END -->/{skip=0}
    !skip' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  echo "updated $f"
done
