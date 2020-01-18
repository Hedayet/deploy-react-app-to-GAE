# deploy-react-app-to-GAE
A script I run to build an optimised deployable for my react apps and to deploy them on GAE

Context:
* The React app was created with the `create-react-app` tool
* The server and the `app.yaml` files are in `/node` directory

# Setup
* You need to have,
  1. Google Cloud Appengine project
  2. `gcould` SDK installed.
  3. Google Cloud Storage bucket to host the static contents.
* Clone the repo
* grep for `TODO(user): ` and change params accordingly
* run `npm i` to install node modules
* run `build.sh`
* profit
