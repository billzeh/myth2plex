#!/bin/bash

# variables
mythlink="/usr/share/doc/mythtv-backend/contrib/user_jobs/mythlink.pl"

plexDestDir="/media/md0/Plex/Myth TV/"
outFormat='%T/%T-%S'

# create media symlinks to myth recordings in the plex destination dir
echo "Linking Myth TV Recordings..."
"${mythlink}" --link "${plexDestDir}" --format "${outFormat}"

cd "${plexDestDir}"

# manually rename show directories to make plex a little happier
mkdir "Sherlock"
for ep in ./"Masterpiece Mystery!"/*; do
	echo "${ep}"
    mv "${ep}" "Sherlock/"
done
for ep in ./"Sherlock on Masterpiece"/*; do
	echo "${ep}"
    mv "${ep}" "Sherlock/"
done

# remove unwanted shows, shows that should be entirely deleted
rm -rf "The Mentalist" "Masterpiece Mystery!" "Sherlock on Masterpiece"

# let filebot work it's magic to add season & episode information
for show in ./*/; do
    echo "Renaming ${show}..." 
    filebot -rename "${show}" --db thetvdb -non-strict
done

ls -R *

cd -

# todo: lastly we could trigger plex to do a library refresh
