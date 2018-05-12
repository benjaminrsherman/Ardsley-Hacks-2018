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
  res.send("Score successfully posted!")
  console.log("Uploading " + name + "'s score of " + score + " on " + map_id)
})

app.get('/get-score', (req, res) => {
  var map_id = req.query.map_id
  var score = ""
  exec("ls -1 data/ | grep '@" + map_id + "@' | sort -t '@" + map_id + "@' -k 2 | head -1 | cut -f 3 -d '@'", // unix piping amirite
    (err, stdout, stderr) => { res.send(stdout) } )
  console.log("Retrieving score for map " + map_id)
})

app.get('/get-top-score', (req, res) => {
  exec("ls -1 data/ | awk -F '@' '{print $3}' | sort | sed '1!G;h;$!d' | head -1",
    (err, stdout, stderr) => { res.send(stdout) });
  console.log("Retrieving top score")
})

app.get('/get-top-scores-name', (req, res) => {
  exec("ls -1 data/ | sort -t '@' -k 3 -nr | awk -F '@' '{print $1}' | head -5",
    (err, stdout, stderr) => { res.send(stdout) })
  console.log("Retrieving top score names")
})

app.get('/get-top-scores-map', (req, res) => {
  exec("ls -1 data/ | sort -t '@' -k 3 -nr | awk -F '@' '{print $2}' | head -5",
    (err, stdout, stderr) => { res.send(stdout) })
  console.log("Retrieving top score maps")
})

app.get('/get-top-scores-score', (req, res) => {
  exec("ls -1 data/ | sort -t '@' -k 3 -nr | awk -F '@' '{print $3}' | head -5",
    (err, stdout, stderr) => { res.send(stdout) })
  console.log("Retrieving top scores")
})

app.get('/post-map', (req, res) => {
  var map_id = req.query.map_id
  var points = req.query.points
  exec("echo '" + req.query.points + "' >> data/" + map_id + ".AHMAP")
  console.log("Uploaded map " + map_id)
  res.send("Map successfully uploaded!")
})

app.get('/get-map', (req, res) => {
  var map_id = req.query.map_id
  var str = ""
  exec("cat ./data/" + map_id + ".AHMAP",
    (err, stdout, stderr) => { res.send(stdout) } )
  console.log("Retrieving map " + map_id)
})

app.get('/get-total-maps', (req, res) => {
<<<<<<< HEAD
  exec("ls -1 data/ | awk -F '@' '{print $2}' | uniq | wc -l",
=======
  exec("ls -1 ./data | grep 'AHMAP' | uniq | wc -l",
>>>>>>> f4c3eab15fc812c6444ebd81cc43d3883b35c245
    (err, stdout, stderr) => { res.send(stdout) })
  console.log("Retrieving total number of maps")
})

app.get('/get-online', (req, res) => {
  var game_id = req.query.game_id
  var player_id = req.query.player_id
<<<<<<< HEAD
  exec("cat data/" + game_id + "@" + player_id + " | tail -1",
    (err, stdout, stderr) => {res.send(stdout) })
=======
  exec("cat ./data/" + game_id + "@" + player_id + " | tail -1",
    (err, stdout, stderr) => { res.send(stdout) })
>>>>>>> f4c3eab15fc812c6444ebd81cc43d3883b35c245
  console.log("Retrieving game data for game " + game_id + " for player " + player_id)
})

app.get('/post-online', (req, res) => {
  var game_id = req.query.game_id
  var player_id = req.query.player_id

  var lap = req.query.lap
  var point = req.query.point
  var distance = req.query.distance

  exec("echo '" + lap + "," + point + "," + distance + "' >> 'data/" + game_id + "@" + player_id + "'")

  res.send("Info posted!")

  console.log("Uploaded game information for game " + game_id + " by player " + player)
})

app.get('/post-gen-game', (req, res) => {
  var game_id = req.query.game_id
  var file_exists = false
  exec("file 'data/" + game_id + "@1'",
    (err, stdout, stderr) => { file_exists = (stdout.indexOf("No such file or directory") === -1) })
  if (file_exists) {
    console.log("Tried to create game that already exists!")
    res.send("no")
    return
  }
<<<<<<< HEAD
  exec("touch 'data/" + game_id + "@1'")
=======
  exec("touch '" + game_id + "@1'")
  res.send("yes")
>>>>>>> f4c3eab15fc812c6444ebd81cc43d3883b35c245
})

app.get('/post-join-game', (req, res) => {
  var game_id = req.query.game_id
  var file_exists = false
  exec("file '" + game_id + "@2'",
      (err, stdout, stderr) => { file_exists = (stdout.indexOf("No such file or directory") === -1) })
    if (file_exists) {
      console.log("Tried to create game that already exists!")
      res.send("no")
      return
    }
<<<<<<< HEAD
    exec("touch 'data/" + game_id + "@2'")
=======
    exec("touch '" + game_id + "@2'")
    res.send("yes")
>>>>>>> f4c3eab15fc812c6444ebd81cc43d3883b35c245
 })

app.get('/handshake', (req, res) => {
  var game_id = req.query.game_id
  var player_id = req.query.player_id
  var c_time = req.query.time
  var s_time = Math.floor(new Date() / 1000) + 10000
  var diff = s_time - c_time
  exec("echo " + diff + " >> 'data/" + game_id + "@" + player_id + "'")
})

app.listen(3000, () => console.log("Listening on port 3000"))
