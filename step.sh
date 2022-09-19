#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# install relevant repeato cli based on machine types
MACHINE_TYPE=`uname -m`
OS_TYPE=`uname`

PLATFORM='mac'
ARCH=''
REQUIRED_NODE_VERSION='14.18'

if [[ "$OS_TYPE" == "Linux" ]]; then
   PLATFORM='linux'
fi
if [[ "$MACHINE_TYPE" == "arm64" ]]; then
   REQUIRED_NODE_VERSION='16.14'
   ARCH='-arm'
fi

## Avoid Github api call due to rate limits error on bitrise - bitrise using shared IP
# RELEASE_URL=$(node ${THIS_SCRIPT_DIR}/scripts/latest-cli-release.js "${MACHINE_TYPE}" "${RELEASE_DATA}")

# Specific version installation - directly from github releases old way
# RELEASE_URL=https://github.com/repeato-qa/Repeato-CLI-prebuilt/releases/download/v${repeato_cli_version}/repeato-cli-${PLATFORM}${ARCH}.zip 
# wget -q "${RELEASE_URL}" -O repeato-cli.zip

# setup workspace and repeato cli tool
# rm -rf repeato-cli 
# unzip -qq repeato-cli.zip -d repeato-cli/
# cp -r repeato-cli/resources/ ./resources

# configure specific node version
curl -q -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" >/dev/null 2>&1 # This loads nvm
nvm install $REQUIRED_NODE_VERSION >/dev/null 2>&1
nvm use $REQUIRED_NODE_VERSION >/dev/null 2>&1

# start repeato batch run tests & upload report
rm -rf batch-report
mkdir ./userdata
mkdir ./userdata/tessdata
npm install -g prebuild # needed for node-native-ocr (instead of installing node-gyp)
npm_config_yes=true npx @repeato/cli-testrunner@${repeato_cli_version} --licenseKey "${license_key}" --workspaceDir "${workspace_path}" --batchId "${batch_id}" --outputDir "../batch-report"
zip -r batch_report_$batch_id.zip batch-report
cp batch_report_$batch_id.zip $BITRISE_DEPLOY_DIR/batch_report_$batch_id.zip
cp repeato-cli/jUnitReport.xml $BITRISE_DEPLOY_DIR/UnitTest.xml

# --- Export Environment Variables for other Steps:
envman add --key REPEATO_REPORT --value "$BITRISE_DEPLOY_DIR/batch_report_$batch_id.zip"
envman add --key REPEATO_JUNIT_REPORT --value "$BITRISE_DEPLOY_DIR/UnitTest.xml"

# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY REPEATO_REPORT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
