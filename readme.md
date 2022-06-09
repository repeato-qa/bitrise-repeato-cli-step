# Repeato CLI Step

<!-- [![Step changelog](https://shields.io/github/v/release/bitrise-steplib/steps-avd-manager?include_prereleases&label=changelog&color=blueviolet)](https://github.com/repeato-qa/bitrise-repeato-cli-step.git/releases) -->

Run repeato recorded tests in bitrise workflow.

<details>
<summary>Description</summary>

Run repeato tests on a virtual Android or IOS device. Once some basic inputs are set, the Step checks the requirements, downloads the workspace before executing the tests.

### Configuring the Step
1. Add the **Repeato CLI** Step to your Workflow as one of the Steps in your Workflow.
2. Set the **Workspace Repo** to pull a repeato workspace tests. Fow now only git URL option is supported for workspaces setup.
3. Set the **Batch Id**. The batch id to execute the specified Batch tests.

Please make sure [AVD](https://www.bitrise.io/integrations/steps/avd-manager) or IOS emulator is ready and configured properly according to the workspace tests. Your android/ios app build must be installed on the emulator before this step. 
You must configure the AVD/IOS emulator with according to your local emulator on which repeato workspaces tests were recorded.
For iOS Simulator there isn't any step, that starts the simulator, as the `xcodebuild test` command for iOS Testing step boot’s the simulator by default.

### Troubleshooting
The emulator needs some time to boot up. The earlier you place the Step in your Workflow, the more tasks, such as cloning or caching, you can complete in your Workflow before the emulator starts working.
We recommend that you also add **Wait for Android emulator** Step (in case of android) to your Workflow as it acts as a shield preventing the AVD Manager to kick in too early. Make sure you add the **Wait for Android emulator** Step BEFORE the `Repeato CLI Step` so our step can use **AVD Manager**. 

### Demo Pipeline
Here is the our demo pipeline on Bitrise, which we've setup for our Step testing. Below pipline is based on `hello-world-flutter-app`:
 - [AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager) is our first Step, we've set the Step inputs based on the our `repeato-workspace` (same as of recording emulator).
 - [Git Clone Repository](https://www.bitrise.io/integrations/steps/git-clone)
 - [Flutter Install](https://www.bitrise.io/integrations/steps/flutter-installer) as our app is flutter based so we must need to install flutter on Bitrise VM.
 - [Bitrise Cache pull](https://www.bitrise.io/integrations/steps/cache-pull)
 - [Bitrise Cache push](https://www.bitrise.io/integrations/steps/cache-push)
 - [Wait For Androind Emulator](https://www.bitrise.io/integrations/steps/wait-for-android-emulator) as next step needs booted emulator for app install on emulator so we've added this step to make sure next step have booted emulator.
 - [Script](https://www.bitrise.io/integrations/steps/script) - As our next final Repeato step needs fully ready & configured emulator, we are using commands for building the APK (`flutter build apk --split-per-abi`) and sending to emulator using `adb install` (make sure you send/install the apk compatible to your emulator settings `x86_64 or arm64` etc...). You might have to configure different step for making the build and sending to device (depending upon your APP) - See `Useful links` section below. 
 - [Repeato Cli Integration Step](https://github.com/repeato-qa/bitrise-repeato-cli-step) Set the required inputs needed for tests execution, check the `configuration section` below. This step will provide you the ENV Varialbe `REPEATO_REPORT` for tests reports which you can use for uploading reports to any 3rd party serivce of your preference. 

### Useful links
- [Getting started with AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager/)
- [Gradle Runner for build](https://www.bitrise.io/integrations/steps/gradle-runner/)
- [Android Build](https://www.bitrise.io/integrations/steps/android-build/)

### Related Steps
- [AVD Manager](https://www.bitrise.io/integrations/steps/avd-manager)
- [Wait for Android emulator](https://www.bitrise.io/integrations/steps/wait-for-android-emulator)

</details>

## 🧩 Get started

Add this step directly to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).

You can also run this step directly with [Bitrise CLI](https://github.com/bitrise-io/bitrise).

## ⚙️ Configuration

<details>
<summary>Inputs</summary>

| Key | Description | Flags | Default |
| --- | --- | --- | --- |
| `workspace_repo_url` | Repeato CLI need workspace path for setting up the workspace before executing batch. | required | none |
| `batch_id` | Set batch id for the tests execution. | required | `0` |
</details>

<details>
<summary>Outputs</summary>

| Environment Variable | Description |
| --- | --- |
| `REPEATO_REPORT` | Repeato Batch Report Path |
</details>

## 🙋 Contributing

We welcome [pull requests](https://github.com/repeato-qa/bitrise-repeato-cli-step/pulls) and [issues](https://github.com/repeato-qa/bitrise-repeato-cli-step/issues) against this repository.

For pull requests, work on your changes in a forked repository and use the Bitrise CLI to [run step tests locally](https://devcenter.bitrise.io/bitrise-cli/run-your-first-build/).

Learn more about developing steps:

- [Create your own step](https://devcenter.bitrise.io/contributors/create-your-own-step/)
- [Testing your Step](https://devcenter.bitrise.io/contributors/testing-and-versioning-your-steps/)
