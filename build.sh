#!/usr/bin/env bash

#setup
bucket_name="taman-test-1-bucket"

# Delete old deployables
rm -rf build deployables

npm run build
gzip build/static/css/* build/static/js/* build/static/images/*
for old in build/static/css/*.gz build/static/js/*.gz build/static/images/*.gz; do mv "$old" "${old%???}"; done

# create a folder from scratch and move all deployables items to it

mkdir deployables

# copy app.yaml for your node application
cp node/app.yaml deployables/
# copy package.json for your node application, not the one for your react app
cp node/package.json deployables/
# copy node application's index.js to the deployables.
cp node/index.js deployables/
# copy react app's build to deploables
cp -r build deployables/

# rsync static objects hosted on cloud storage
# this is similar doing
# gsutil -m rsync -r ./deployables/build/static/css gs://${bucket_name}/build/static/css
# gsutil -m rsync -r ./deployables/build/static/images gs://${bucket_name}/build/static/images
# gsutil -m rsync -r ./deployables/build/static/js gs://${bucket_name}/build/static/js
for f in css images js; do gsutil -m rsync -r ./deployables/build/static/$f gs://"${bucket_name}"/build/static/$f; done

# set metadata for static objects hosted on cloud storage
gsutil -m setmeta -h "Content-Encoding: gzip" gs://${bucket_name}/build/static/css/* \
                     gs://${bucket_name}/build/static/js/* \
                     gs://${bucket_name}/build/static/images/*
gsutil -m setmeta -h "Cache-Control: public, max-age=31536000" gs://${bucket_name}/build/static/css/* \
                  gs://${bucket_name}/build/static/js/* \
                  gs://${bucket_name}/build/static/imgs/* \
                  gs://${bucket_name}/build/static/images/*

gcloud app deploy deployables/app.yaml -q
