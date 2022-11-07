# Repeato Test Runner Step for Bitrise

<!-- [![Step changelog](https://shields.io/github/v/release/bitrise-steplib/steps-avd-manager?include_prereleases&label=changelog&color=blueviolet)](https://github.com/repeato-qa/bitrise-repeato-cli-step.git/releases) -->

Run tests created with [Repeato Studio](https://www.repeato.app) as part of your Bitrise workflow.

## 🏁 Get started

Add this step to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).
You can also run this step directly with [Bitrise CLI](https://github.com/bitrise-io/bitrise).

This step takes care of checking the system requirements as well as installing and starting the headless Repeato CLI testrunner. After running the tests, it sets the environment variables which can be used in consecutive steps.

### Configuring the Step
1. Add the **Repeato Test Runner** Step to your Workflow as one of the Steps in your Workflow.
2. Make sure your test workspace is checked out. 
2. Set the **Workspace Path** to point to the  repeato workspace directory. 
3. Set the **Batch Id**. The batch ID of the test batch you want to execute.
4. Set the **License Key**.

Please make sure [AVD](https://www.bitrise.io/integrations/steps/avd-manager) or IOS emulator is configured properly. Further your Android/iOS app build must be installed on the emulator before running the test batch. 
We recommend to run the tests on the same device / emulator you originally used for creating them. This way you will get the most stability and performance.

For iOS Simulator there isn't any step, that starts the simulator, as the `xcodebuild test` command for iOS Testing step boot’s the simulator by default.

### Inputs

| Key | Description | Flags | Default |
| --- | --- | --- | --- |
| `repeato_cli_version` | Set the repeato CLI version compatible to your workspace tests. | required | `latest` |
| `workspace_path` | Repeato test runner need workspace path for setting up the workspace before executing batch. | required | $BITRISE_SOURCE_DIR |
| `batch_id` | Set batch id for the tests execution. | required | `0` |
| `license_key` | Set license key for the tests execution. | required | `none` |
| `log_level` | Set log level. | required | `INFO` |


### Outputs

| Environment Variable | Description |
| --- | --- |
| `REPEATO_REPORT` | Repeato Batch Report Zip File |
| `REPEATO_JUNIT_REPORT` | Repeato JUnit XML File |

### Tips & Troubleshooting
The emulator needs some time to boot up. The earlier you place the step in your workflow, the more tasks, such as cloning or caching, you can complete in your workflow before the emulator starts working.
We recommend that you also add **Wait for Android emulator** Step (in case of android) to your workflow as it acts as a shield preventing the AVD manager to kick in too early. Make sure you add the **Wait for Android emulator** Step BEFORE the `Repeato Test Runner Step` so our step can use **AVD Manager**. 

### Demo Pipeline (Android / Flutter)
Here is the our demo pipeline on Bitrise, which we've setup for our step testing:
 1. [AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager)
 2. [Git Clone Repository](https://www.bitrise.io/integrations/steps/git-clone)
 3. [Flutter Install](https://www.bitrise.io/integrations/steps/flutter-installer) for building our flutter-based app.
 4. [Bitrise Cache pull](https://www.bitrise.io/integrations/steps/cache-pull)
 5. [Bitrise Cache push](https://www.bitrise.io/integrations/steps/cache-push)
 6. [Wait For Androind Emulator](https://www.bitrise.io/integrations/steps/wait-for-android-emulator)
 7. [Script](https://www.bitrise.io/integrations/steps/script) - As our next final Repeato step needs fully ready & configured emulator, we are using commands for building the APK (`flutter build apk --split-per-abi`) and sending to emulator using `adb install` (make sure you send/install the apk compatible to your emulator settings `x86_64 or arm64` etc...). You might have to configure different step for making the build and sending to device (depending upon your APP). Also make sure before the next step workspace-tests are cloned (if they are in separate repository) - See `Useful links` section below.  
 8. [Repeato Test Runner Step](https://github.com/repeato-qa/bitrise-repeato-cli-step)
 9. [Deploy to Bitrise.io - Artifacts](https://www.bitrise.io/integrations/steps/deploy-to-bitrise-io) The Repeato step copies the `batch-reports` zip file and JUnit XML file into the bitrise upload directory(`$BITRISE_DEPLOY_DIR`). You can use this step to upload the reports into the test artifacts section. You could also use [FTP Upload](bitrise.io/integrations/steps/ftp-upload) or a [Deploy to S3](https://www.bitrise.io/integrations/steps/amazon-s3-deploy) step for uploading reports.
10. [Export test results to Test Reports add-on](https://www.bitrise.io/integrations/steps/custom-test-results-export) This Step is to export the results to the Test Reports add-on. The Step creates the required test-info.json file and deploys the test results in the correct directory for export.

### Useful links
- [Getting started with AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager/)
- [Gradle Runner for build](https://www.bitrise.io/integrations/steps/gradle-runner/)
- [Android Build](https://www.bitrise.io/integrations/steps/android-build/)

### Related Steps
- [AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager)
- [Wait for Android emulator](https://www.bitrise.io/integrations/steps/wait-for-android-emulator)

## 🙋 Contributing

We welcome [pull requests](https://github.com/repeato-qa/bitrise-repeato-cli-step/pulls) and [issues](https://github.com/repeato-qa/bitrise-repeato-cli-step/issues) against this repository.

For pull requests, work on your changes in a forked repository and use the Bitrise CLI to [run step tests locally](https://devcenter.bitrise.io/bitrise-cli/run-your-first-build/).
