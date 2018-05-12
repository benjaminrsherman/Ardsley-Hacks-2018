var exec = require('child_process').exec

var express = require('express')
var app = express()

app.use(express.json())

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/', (req, res) => {
  res.send('pls no hack thx')
  console.log(req.query)
})

app.get('/post-score', (req, res) => {
  var name = req.query.name
  var map_id = req.query.map_id
  var score = req.query.score
  var str = "touch 'data/" + name + '@' + map_id + '@' + score + "'"
  exec(str)
  console.log("Uploading " + name + "'s score of " + score + " on " + map_id)
})

app.get('/get-score', (req, res) => {
  var map_id = req.query.map_id
  var score = ""
  exec("ls -1 ./data | grep '@" + map_id + "@' | sort -t '@" + map_id + "@' -k 2 | head -1 | cut -f 3 -d '@'", // unix piping amirite
    (err, stdout, stderr) => { res.send(stdout) } )
  console.log("Retrieving score for map " + map_id)
})

app.get('/get-top-score', (req, res) => {
  exec("ls -1 ./data | awk -F '@' '{print $3}' | sort | sed '1!G;h;$!d' | head -1",
    (err, stdout, stderr) => { res.send(stdout) });
  console.log("Retrieving top score")
})

app.get('/post-map', (req, res) => {
  var map_id = req.query.map_id
  exec("echo '" + req.query + "' >> data/" + map_id + ".AHMAP")
  console.log("Uploaded map " + map_id)
})

app.get('/get-map', (req, res) => {
  var map_id = req.query.map_id
  var str = ""
  exec("cat data/" + map_id + ".AHMAP",
    (err, stdout, stderr) => { str = stdout } )
  res.send(str)
  console.log("Retrieving map " + map_id)
})

app.get('/get-total-maps', (req, res) => {
  exec("ls -1 ./data | awk -F '@' '{print $2}' | uniq | wc -l",
    (err, stdout, stderr) => { res.send(stdout) })
  console.log("Retrieving total number of maps")
})

//app.get('/online', (req, res) => {


app.listen(3000, () => console.log("Listening on port 3000"))
