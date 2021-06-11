// Imports the Google Cloud client library
const { PubSub } = require('@google-cloud/pubsub');
const http = require('http');
const projectID = 'staffzo-316512';
const topicName = 'event-coordinator-topic';
const running = true;

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}
const startServer = async () => {
  let app = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello World!\n');
  });
  app.listen(8080, '127.0.0.1');
  console.log('Node server running on port 8080');
}

const run = async () => {
  startServer();
  const pubsub = new PubSub({ projectID });
  while (running) {
    await publish(pubsub);
    await sleep(600000);
  }
}

const publish = async (pubSubClient) => {
  try {
    const messageId = await pubSubClient
      .topic(`projects/${projectID}/topics/${topicName}`)
      .publish(Buffer.from('event sent'));
    console.log(`Event ${messageId} published.`);
  } catch (error) {
    console.error(`Received error while publishing: ${error.message}`);
    process.exitCode = 1;
  }
}

run();