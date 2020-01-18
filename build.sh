#!/usr/bin/env bash

# TODO(user): setup required
bucket_name="taman-test-1-bucket"
# TODO(user): setup required
cloud_project_name="taman-test-1"


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
# copy react app's build files to deploables
cp -r build deployables/

# optimize images in the /deployables/build/static/images/ dir. see the gulpfile.js
gulp

# rsync static objects hosted on cloud storage
gsutil -m rsync -r ./deployables/build/ gs://"${bucket_name}"/build

# set metadata for static objects hosted on cloud storage
gsutil -m setmeta -h "Content-Encoding: gzip" \
  gs://${bucket_name}/build/static/css/* \
  gs://${bucket_name}/build/static/js/* \
  gs://${bucket_name}/build/static/images/*
gsutil -m setmeta -h "Cache-Control: public, max-age=31536000" \
  gs://${bucket_name}/build/static/css/* \
  gs://${bucket_name}/build/static/js/* \
  gs://${bucket_name}/build/static/images/*

gcloud app deploy deployables/app.yaml --project=${cloud_project_name} -q
