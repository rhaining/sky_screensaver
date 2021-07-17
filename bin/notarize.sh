#!/bin/sh

#
# to notarize your screensaver, add this to your Archive post-release:
#       APPLE_USERNAME="you@yourdomain.com" APPLE_PROVIDER="yourappleprovider" $SRCROOT/bin/notarize.sh
#
#

ARCHIVE_SCREENSAVER_PATH="$ARCHIVE_PATH/Products$INSTALL_PATH/$PRODUCT_NAME.saver"
EXPORT_PATH="$TEMP_DIR/Export"
EXPORT_SCREENSAVER_PATH="$EXPORT_PATH/$PRODUCT_NAME.saver"
ZIP_PATH="$EXPORT_PATH/$PRODUCT_NAME.zip"
LOG_PATH="/tmp/screensaver_notarized.txt"

echo "Starting…" > $LOG_PATH


# open log, so the user can see what's going on
open -a Terminal.app "$SRCROOT/bin/open_log.sh"

sleep 10s


# creates the export directory
echo "/bin/mkdir \"$EXPORT_PATH\"" >> $LOG_PATH
/bin/mkdir "$EXPORT_PATH" >> $LOG_PATH

sleep 10s


# copy our screensaver to the new directory
echo "/bin/cp -r \"$ARCHIVE_SCREENSAVER_PATH\" \"$EXPORT_SCREENSAVER_PATH\"" >> $LOG_PATH
/bin/cp -r "$ARCHIVE_SCREENSAVER_PATH" "$EXPORT_SCREENSAVER_PATH" >> $LOG_PATH

echo "\n\n" >> $LOG_PATH


# compresses our screensaver 'directory' into a zip
echo "/usr/bin/ditto -c -k --sequesterRsrc --keepParent \"$EXPORT_SCREENSAVER_PATH\" \"$ZIP_PATH\"" >> $LOG_PATH
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$EXPORT_SCREENSAVER_PATH" "$ZIP_PATH" >> $LOG_PATH

echo "\n\n" >> $LOG_PATH


# notarize the screensaver with apple
echo "/usr/bin/xcrun altool -t osx -f \"$ZIP_PATH\" --primary-bundle-id  $PRODUCT_BUNDLE_IDENTIFIER --notarize-app --username \"$APPLE_USERNAME\" -p \"@keychain:AC_PASSWORD\" --asc-provider $APPLE_PROVIDER" >> $LOG_PATH
NOTARIZE_OUTPUT=`/usr/bin/xcrun altool -t osx -f "$ZIP_PATH" --primary-bundle-id  $PRODUCT_BUNDLE_IDENTIFIER --notarize-app --username "$APPLE_USERNAME" -p "@keychain:AC_PASSWORD" --asc-provider $APPLE_PROVIDER`
echo $NOTARIZE_OUTPUT >> $LOG_PATH

echo "\n\n" >> $LOG_PATH


# let's keep checking to see if the notarization was successful
request_uuid_regex="RequestUUID = (.+)$"
if [[ $NOTARIZE_OUTPUT =~ $request_uuid_regex ]]
then
  REQUEST_UUID=${BASH_REMATCH[1]}

  echo "the request uuid: $REQUEST_UUID\n\n" >> $LOG_PATH

  while [ TRUE ]
  do
    echo "/usr/bin/xcrun altool --notarization-info $REQUEST_UUID --username \"$APPLE_USERNAME\" -p \"@keychain:AC_PASSWORD\" --asc-provider $APPLE_PROVIDER" >> $LOG_PATH
    NOTARIZATION_INFO=`/usr/bin/xcrun altool --notarization-info $REQUEST_UUID --username "$APPLE_USERNAME" -p "@keychain:AC_PASSWORD" --asc-provider $APPLE_PROVIDER`
    echo "$NOTARIZATION_INFO\n\n" >> $LOG_PATH

    if [[ $NOTARIZATION_INFO =~ "Status Message: Package Approved" ]]
    then
       break
    elif [[ $NOTARIZATION_INFO =~ "Status Message: Package Invalid" ]] && [[ $NOTARIZATION_INFO =~ "LogFileURL:" ]]
    then
        break
    else
       sleep 20s
    fi
    
  done


  # staple the notarization to the exported screensaver
  echo "/usr/bin/xcrun stapler staple \"$EXPORT_SCREENSAVER_PATH\"" >> $LOG_PATH
  /usr/bin/xcrun stapler staple "$EXPORT_SCREENSAVER_PATH" >> $LOG_PATH


  # make the final export directory
  FINAL_DIR_PATH="$EXPORT_PATH/$PRODUCT_NAME"
  echo "/bin/mkdir \"$FINAL_DIR_PATH\"" >> $LOG_PATH
  /bin/mkdir "$FINAL_DIR_PATH" >> $LOG_PATH

  echo "\n\n" >> $LOG_PATH


  # copy over
  echo "/bin/cp -r \"$EXPORT_SCREENSAVER_PATH\" \"$FINAL_DIR_PATH\"" >> $LOG_PATH
  /bin/cp -r "$EXPORT_SCREENSAVER_PATH" "$FINAL_DIR_PATH" >> $LOG_PATH

  echo "\n\n" >> $LOG_PATH


  # gets rid of the old zip
  echo "/bin/mv \"$ZIP_PATH\" ~/.Trash/" >> $LOG_PATH
  bin/mv "$ZIP_PATH" ~/.Trash/ >> $LOG_PATH


  # compresses our final product
  echo "/usr/bin/ditto -c -k --sequesterRsrc --keepParent \"$FINAL_DIR_PATH\" \"$ZIP_PATH\"" >> $LOG_PATH
  /usr/bin/ditto -c -k --sequesterRsrc --keepParent "$FINAL_DIR_PATH" "$ZIP_PATH" >> $LOG_PATH


  # opens the directory so the user can see it
  echo "open \"$EXPORT_PATH\"" >> $LOG_PATH
  open "$EXPORT_PATH"

fi
