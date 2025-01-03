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

echo "Release process for version $VERSION completed."
dart run auto_updater:sign_update https://github.com/albertpurnawan/BeOne-POS/releases/download/untagged-b546517c130ced91d8bb/pos_fe-1.0.19%2B1.0.19-windows-setup.exe

EXE_PATH="./build/your-app-$VERSION.exe"
EXE_URL="https://github.com/albertpurnawan/BeOne-POS/releases/download/v$VERSION/your-app-$VERSION.exe"
APPCAST_PATH="./build/appcast.xml"
SIGNATURE=$(openssl dgst -sha256 -sign private_key.pem "$EXE_PATH" | base64)

cat > "$APPCAST_PATH" <<EOL
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
  <channel>
    <title>Your App Updates</title>
    <link>https://github.com/albertpurnawan/BeOne-POS/releases</link>
    <description>Latest updates for Your App</description>
    <language>en</language>

    <item>
      <title>Version $VERSION</title>
      <sparkle:releaseNotesLink>https://github.com/albertpurnawan/BeOne-POS/releases/tag/v$VERSION</sparkle:releaseNotesLink>
      <pubDate>$(date -R)</pubDate>
      <enclosure
        url="$EXE_URL"
        sparkle:version="$VERSION"
        sparkle:dsaSignature="$SIGNATURE"
        length="$(stat -c%s "$EXE_PATH")"
        type="application/octet-stream" />
    </item>
  </channel>
</rss>
EOL


echo "Version $VERSION has been released."
read -p "Press [Enter] key to close terminal..."