const https = require('https');

const args = process.argv.slice(2); // first arg is usually the path to nodejs, and the second arg is the location of the script you're executing
const arch = args[0] || process.arch;
const releaseData = args[1]; // we might recieve release data as param
const releaseName = `repeato-cli-mac${arch === 'arm64' ? '-arm' : ''}.zip`;

const getDownloadURL = (data) => {
  const releases = JSON.parse(data);
  const latestRelease = releases[0]; // at first index latest release data
  const foundRelease = latestRelease?.assets?.find((release) => release.label === releaseName);
  console.log(foundRelease.browser_download_url); // this will output the url for curl to download release
  return foundRelease.browser_download_url;
}

const parseData = (data) => {
  if (data) {
    // we already have release data so don't send any api call
    return getDownloadURL(data);
  }

  const options = {
    hostname: 'api.github.com',
    port: 443,
    path: '/repos/repeato-qa/repeato-cli-prebuilt/releases',
    method: 'GET',
    headers: { 'User-Agent': 'Repeato-Bitrise-Step' }
  };

  https.get(options, (res) => {
    let body = "";

    res.on("data", (chunk) => {
      body += chunk;
    });

    res.on("end", () => {
      try {
        return getDownloadURL(body);
      } catch (error) {
        console.error(error.message);
      };
    });

  }).on("error", (error) => {
    console.error(error.message);
  });

}

parseData(releaseData);
