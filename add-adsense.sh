#!/bin/bash
# NxtCraft AdSense Injector
# Usage: ./add-adsense.sh ca-pub-XXXXXXXXXXXXXXXX
#
# Adds Google AdSense auto-ads script to ALL nxtcraft tool index.html files
# and commits + pushes each repo.
#
# Prerequisites: PAT in /Users/pradeepkumarkesharwani/vscode-code/saasscout/.env

set -e

PUB_ID="${1:-}"
if [ -z "$PUB_ID" ]; then
  echo "Usage: $0 ca-pub-XXXXXXXXXXXXXXXX"
  echo "Get your publisher ID from https://adsense.google.com"
  exit 1
fi

PAT=$(grep GITHUB_PAT /Users/pradeepkumarkesharwani/vscode-code/saasscout/.env | cut -d= -f2 | tr -d '[:space:]')

ADSENSE_SCRIPT="<script async src=\"https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${PUB_ID}\" crossorigin=\"anonymous\"></script>"

# All tool directories and their GitHub repo names
declare -A REPOS=(
  ["nxtcraft.github.io"]="nxtcraft.github.io"
  ["emicalc"]="emicalc"
  ["sipcalc"]="sipcalc"
  ["taxcalc"]="taxcalc"
  ["tradecalc"]="tradecalc"
  ["fdcalc"]="fdcalc"
  ["qrcraft"]="qrlab"
  ["devlab"]="devlab"
  ["wordkit"]="wordlab"
  ["passkit"]="passgen"
  ["unitconv"]="unitconv"
  ["agecalc"]="agecalc"
  ["aadhaar-mask"]="aadhaar-mask"
  ["promptkit"]="promptlab"
  ["pdfcraft"]="pdflab"
  ["resumekit"]="resumeforge"
  ["biodatakit"]="biodatakit"
  ["invoicekit"]="invoicelab"
  ["salaryslip"]="salaryslip"
  ["rentreceipt"]="rentreceipt"
  ["shopbook"]="shopbook"
  ["imagecraft"]="imglab"
  ["huelab"]="huelab"
  ["gstcalc"]="gstcalc"
  ["bmi-calc"]="bmi-calc"
  ["wa-link"]="wa-link"
  ["pomodoro"]="pomodoro"
  ["color-contrast"]="color-contrast"
  ["css-gradient"]="css-gradient"
  ["pdf-text"]="pdf-text"
  ["ai-grammar"]="ai-grammar"
  ["ai-transcribe"]="ai-transcribe"
)

BASE="/Users/pradeepkumarkesharwani/vscode-code"
GIT_EMAIL="249218787+nxtcraft@users.noreply.github.com"
GIT_NAME="nxtcraft"

echo "=============================="
echo "AdSense Publisher ID: $PUB_ID"
echo "=============================="
echo ""

SKIPPED=0
UPDATED=0

for dir in "${!REPOS[@]}"; do
  repo="${REPOS[$dir]}"
  file="$BASE/$dir/index.html"

  if [ ! -f "$file" ]; then
    echo "⚠️  SKIP: $dir — index.html not found"
    ((SKIPPED++))
    continue
  fi

  # Check if AdSense already added
  if grep -q "pagead2.googlesyndication.com" "$file"; then
    echo "✅ SKIP: $dir — AdSense already present"
    ((SKIPPED++))
    continue
  fi

  # Insert AdSense script after <head> open tag (or after charset meta)
  # Strategy: insert after the first <meta charset line
  if grep -q '<meta charset' "$file"; then
    sed -i '' "s|<meta charset.*|&\n$ADSENSE_SCRIPT|" "$file"
  elif grep -q '<head>' "$file"; then
    sed -i '' "s|<head>|<head>\n$ADSENSE_SCRIPT|" "$file"
  else
    echo "⚠️  SKIP: $dir — cannot find insertion point"
    ((SKIPPED++))
    continue
  fi

  echo "📝 Updated: $dir"

  # Commit and push
  cd "$BASE/$dir"
  git config user.email "$GIT_EMAIL"
  git config user.name "$GIT_NAME"
  git add index.html
  git commit -m "Add Google AdSense auto-ads script

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
  GIT_ASKPASS=/bin/echo git push "https://nxtcraft:$PAT@github.com/nxtcraft/$repo.git" main
  echo "   pushed → github.com/nxtcraft/$repo"
  ((UPDATED++))
done

echo ""
echo "=============================="
echo "Done. Updated: $UPDATED | Skipped: $SKIPPED"
echo "=============================="
echo ""
echo "Next steps:"
echo "1. Go to https://adsense.google.com"
echo "2. Add site: https://nxtcraft.github.io"
echo "3. Wait for Google review (usually 1-7 days)"
echo "4. Once approved, ads will auto-appear on all pages"
