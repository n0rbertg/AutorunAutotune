#!/bin/bash

echo "Getting profile"
python3 get_profile.py --nightscout $SITE_URL  write --directory ./myopenaps/settings/ --name baseline
if [ $? -eq 0 ]
then
  echo "Successfully retrived profile fron nightscout"
else
  echo "ERROR: Failed to get profile from nightscout" 1>&2
  exit 1 
fi

echo "Running autotune"
#oref0-autotune --dir=/usr/src/autot/myopenaps --ns-host=$SITE_URL  --start-days-ago=$DAYS --categorize-uam-as-basal=true
oref0-autotune --dir=/usr/src/autot/myopenaps –-tune-insulin-curve=true --ns-host=$SITE_URL  --start-days-ago=$DAYS

if [ $? -eq 0 ]
then
  echo "Autotune successfull"
else
  echo "ERROR: Autotune failed!" 1>&2
  exit 1 
fi

echo "Uploading profile:" ./myopenaps/autotune/profile.json
oref0-upload-profile ./myopenaps/autotune/profile.json $SITE_URL $API_SECRET
if [ $? -eq 0 ]
then
  echo "Upload successfull"
else
  echo "ERROR: upload failed!" 1>&2
  exit 1 
fi

#echo "triggering updated profile"
#python3 profile_trigger.py --site=$SITE_URL --api_key=$API_SECRET
#if [ $? -eq 0 ]
#then
#  echo "trigger successfull"
#else
#  echo "ERROR: trigger failed!" 1>&2
#  exit 1 
#fi
