const lynx = require('lynx');
const express = require("express");
const request = require("request");
const app = express();
// instantiate a metrics client
//  Note: the metric hostname is hardcoded here
const metrics = new lynx('localhost', 8125);

// sleep for a given number of milliseconds
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
//try to add homepage 
app.get("/", (req, res) => {
    res.send("Welcome to HomePage");
    metrics.increment('HomePage.hitcount');
});

async function main() {
  // send message to the metrics server
  metrics.timing('test.core.delay', Math.random() * 1000);

  // sleep for a random number of milliseconds to avoid flooding metrics server
  return sleep(3000);
}

// infinite loop
(async () => {
  console.log("🚀🚀🚀");
  while (true) { await main() }
})()
  .then(console.log, console.error);
