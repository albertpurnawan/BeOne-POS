#!/bin/bash

# Add Dart global executables to PATH
export PATH="$PATH:$HOME/.pub-cache/bin"

# Check if an argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

# Get the version from the first argument
VERSION=$1

# Update version in pubspec.yaml
sed -i -e "s/version: .*/version: $VERSION/" pubspec.yaml

# Release
dart pub global activate flutter_distributor || true
flutter_distributor release --name prod --jobs windows-exe --publish

# Update appcast.xml
DSA_SIGNATURE=$(grep "sparkle:dsaSignature" dist/appcast.xml | cut -d\" -f4)
sed -i -e "s/<sparkle:version>.*<\/sparkle:version>/<sparkle:version>$VERSION<\/sparkle:version>/" dist/appcast.xml
sed -i -e "s|<sparkle:dsaSignature>.*</sparkle:dsaSignature>|<sparkle:dsaSignature>$DSA_SIGNATURE</sparkle:dsaSignature>|" dist/appcast.xml
sed -i -e "s|<sparkle:shortVersionString>.*</sparkle:shortVersionString>|<sparkle:shortVersionString>$DSA_SIGNATURE</sparkle:shortVersionString>|" dist/appcast.xml
sed -i -e "s|<enclosure url=\"\(.*\)/\(.*\)-\(.*\)+\(.*\)-windows-setup.exe\".*>|<enclosure url=\"\1/$VERSION-$VERSION+\4-windows-setup.exe\" sparkle:dsaSignature=\"$DSA_SIGNATURE\" sparkle:version=\"$VERSION\" sparkle:os=\"windows\" length=\"0\" type=\"application/octet-stream\" />|" dist/appcast.xml

echo "Version $VERSION has been released."
read -p "Press [Enter] key to close terminal..."
