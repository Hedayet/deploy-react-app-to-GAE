const express = require('express');
const path = require('path');
const app = express();
const fs = require('fs')

var https = require("https");

app.get('/robots.txt', function (_req, res) {
    res.type('text/plain');
    res.send("User-agent: *\nAllow: /");
});

app.get('/manifest.json', express.static(path.join(__dirname, 'build')));

app.use('/static', express.static(path.join(__dirname, 'build', 'static')));

function serveBaseHTML (req, resp) {
    const filePath = path.resolve(__dirname, './build', 'index.html');
    fs.readFile(filePath, 'utf8', function (err,data) {
        if (err) {
            return console.log(err);
        }
        const title =  'Test Website';
        const description = 'This is a test web app to try out GCE deployment';
        // TODO(Taman): Add url later
        const img_url = "SOME_URL_LATER_TO_BE_ADDED";
        data = data.replace(/\$OG_URL/g, req.protocol + '://' + req.get('host') + req.originalUrl);
        data = data.replace(/\$OG_TITLE/g, title);
        data = data.replace(/\$OG_DESCRIPTION/g, description);
        // const result = data.replace(/\$OG_IMAGE/g, img_url);
        resp.send(result);
    });
}

app.get('/', serveBaseHTML);

const server = app.listen(8080, () => {
  const host = server.address().address;
  const port = server.address().port;
  console.log(`test server listening at http://${host}:${port}`);
})