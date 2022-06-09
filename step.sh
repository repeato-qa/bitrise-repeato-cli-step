#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Workspace Repo: ${workspace_repo_url}"

# install relevant repeato cli based on machine types
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'arm64' ]; then
  curl -q -s https://www.repeato.app/releases/repeato-cli-1.0.0-mac-arm.zip -o repeato-cli.zip
else
  curl -q -s https://www.repeato.app/releases/repeato-cli-1.0.0-mac.zip -o repeato-cli.zip
fi

# setup workspace and repeato cli tool
rm -rf repeato-cli
unzip -qq repeato-cli.zip -d repeato-cli/
rm -rf workspace-tests
git clone ${workspace_repo_url} workspace-tests
cp -r repeato-cli/resources/ ./resources

# configure specific node version
curl -q -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" >/dev/null 2>&1 # This loads nvm
nvm install 14.18 >/dev/null 2>&1
nvm use 14.18 >/dev/null 2>&1

# start repeato batch run tests
rm -rf batch-report
cd repeato-cli
node testrun.js --workspaceDir "../workspace-tests" --batchId 0 --outputDir "${THIS_SCRIPT_DIR}/batch-report"
ls
cd .. && ls


# --- Export Environment Variables for other Steps:
envman add --key REPEATO_REPORT --value "${THIS_SCRIPT_DIR}/batch-report"

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
