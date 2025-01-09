# #!/bin/bash

# # Check if version argument is passed
# if [ -z "$1" ]; then
#   echo "Usage: $0 <version>"
#   exit 1
# fi

# # Get the version from the first argument
# VERSION=$1

# # Define the Flutter app directory (optional if running inside your Flutter project)
# FLUTTER_APP_DIR="."

# # Go to the Flutter app directory (optional)
# cd "$FLUTTER_APP_DIR" || exit

# # Update version in pubspec.yaml
# echo "Updating version to $VERSION in pubspec.yaml..."
# sed -i -e "s/version: .*/version: $VERSION/" pubspec.yaml

# # Ensure flutter_distributor is installed
# echo "Activating flutter_distributor..."
# dart pub global activate flutter_distributor || { echo "flutter_distributor activation failed"; exit 1; }

# # Run the release command for the specified version
# echo "Running release for version $VERSION..."
# dart pub global run flutter_distributor:main release --name prod --jobs windows-exe

# # Add tag in git
# echo "Adding tag v$VERSION to git..."
# git add -A
# git commit -m "Release v$VERSION $(date '+%Y-%m-%d %H:%M:%S')" || { echo "git commit failed"; exit 1; }
# git tag "v$VERSION" || { echo "git tag failed"; exit 1; }
# git push origin "v$VERSION" || { echo "git push origin v$VERSION failed"; exit 1; }

# echo "Editing appcast.xml..."
# sed -i -e "s|<item>.*</item>||g" dist/appcast.xml
# cat >> dist/appcast.xml <<EOF
# <item>
#   <title>Version $VERSION</title>
#   <sparkle:version>$VERSION</sparkle:version>
#   <sparkle:shortVersionString></sparkle:shortVersionString>
#   <sparkle:releaseNotesLink>https://github.com/albertpurnawan/BeOne-POS/blob/feat/auto_updater/release_notes.html</sparkle:releaseNotesLink>
#   <pubDate>$(date -R)</pubDate>
#   <enclosure url="https://github.com/albertpurnawan/BeOne-POS/releases/download/v$VERSION/pos_fe-$VERSION+$VERSION-windows-setup.exe"
#     sparkle:dsaSignature=$(dart run auto_updater:sign_update dist/$VERSION/pos_fe-$VERSION+$VERSION-windows-setup.exe | jq -r '.signature')
#     sparkle:version="$VERSION"
#     sparkle:os="windows"
#     length="0"
#     type="application/octet-stream" />
# </item>
# EOF

# echo "Logging in to GitHub..."
# gh auth login --with-token $GITHUB_TOKEN || { echo "gh auth login failed"; exit 1; }

# echo "Adding appcast.xml..."
# gh release upload "v$VERSION" build/appcast.xml

# echo "Publishing release on GitHub..."
# gh release create "v$VERSION" --title "v$VERSION" --notes "Release v$VERSION" || { echo "gh release create failed"; exit 1; }

# echo "Version $VERSION has been released."
# read -p "Press [Enter] key to close terminal..."



#!/bin/bash

# Check if version argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

# Get the version from the first argument
VERSION=$1

# Define the Flutter app directory (optional if running inside your Flutter project)
FLUTTER_APP_DIR="."

# Go to the Flutter app directory (optional)
cd "$FLUTTER_APP_DIR" || exit

# Update version in pubspec.yaml
echo "Updating version to $VERSION in pubspec.yaml..."
sed -i -e "s/version: .*/version: $VERSION/" pubspec.yaml

# Ensure flutter_distributor is installed
echo "Activating flutter_distributor..."
dart pub global activate flutter_distributor || { echo "flutter_distributor activation failed"; exit 1; }

# Run the release command for the specified version
echo "Running release for version $VERSION..."
dart pub global run flutter_distributor:main release --name prod --jobs windows-exe

# Add tag in git
echo "Adding tag v$VERSION to git..."
git add -A
git commit -m "Release v$VERSION $(date '+%Y-%m-%d %H:%M:%S')" || { echo "git commit failed"; exit 1; }
git tag "v$VERSION" || { echo "git tag failed"; exit 1; }
git push origin "v$VERSION" || { echo "git push origin v$VERSION failed"; exit 1; }

# Extract signature and length
output=$(dart run auto_updater:sign_update dist/$VERSION/pos_fe-$VERSION+$VERSION-windows-setup.exe)
signature=$(echo "$output" | awk -F 'sparkle:dsaSignature="' '{print $2}' | awk -F '"' '{print $1}')
length=$(echo "$output" | awk -F 'length="' '{print $2}' | awk -F '"' '{print $1}')

# Remove existing item for the current version
sed -i -e "/<item>/,/<\/item>/d" dist/appcast.xml

# Add the new item
cat >> dist/appcast.xml <<EOF
<item>
  <title>Version $VERSION</title>
  <sparkle:version>$VERSION</sparkle:version>
  <sparkle:shortVersionString></sparkle:shortVersionString>
  <sparkle:releaseNotesLink>https://github.com/albertpurnawan/BeOne-POS/blob/feat/auto_updater/release_notes.html</sparkle:releaseNotesLink>
  <pubDate>$(date -R)</pubDate>
  <enclosure url="https://github.com/albertpurnawan/BeOne-POS/releases/download/v$VERSION/pos_fe-$VERSION+$VERSION-windows-setup.exe"
    sparkle:dsaSignature="$signature"
    sparkle:version="$VERSION"
    sparkle:os="windows"
    length="$length"
    type="application/octet-stream" />
</item>
EOF

echo "Logging in to GitHub..."
gh auth login --with-token $GITHUB_TOKEN || { echo "gh auth login failed"; exit 1; }

echo "Adding appcast.xml..."
gh release upload "v$VERSION" dist/appcast.xml

echo "Publishing release on GitHub..."
gh release create "v$VERSION" --title "v$VERSION" --notes "Release v$VERSION" || { echo "gh release create failed"; exit 1; }

echo "Version $VERSION has been released."
read -p "Press [Enter] key to close terminal..."