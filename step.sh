#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Workspace Path: ${workspace_dir}"

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'arm64' ]; then
  curl https://www.repeato.app/releases/repeato-cli-1.0.0-mac-arm.zip -o repeato-cli.zip
else
  curl https://www.repeato.app/releases/repeato-cli-1.0.0-mac.zip -o repeato-cli.zip
fi

rm -rf repeato-cli
unzip repeato-cli.zip -d repeato-cli/
rm -rf workspace-tests
git clone "https://github.com/ahmedmukhtar1133/repeato-testing-workspace.git" workspace-tests
cp -r repeato-cli/resources/ ./resources

cd repeato-cli
node testrun.js --workspaceDir "${workspace_dir}" --batchId 0

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
envman add --key REPEATO_REPORT --value '/report/path/fake'
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
