var exec = require('child_process').exec

var express = require('express')
var app = express()

app.use(express.json())

app.get('/', (req, res) => {
  res.send('pls no hack thx')
})

app.post('/score', (req, res) => {
  var name = req.body.name
  var map_id = req.body.map_id
  var score = req.body.score
  var str = "touch 'data/" + name + '@' + map_id + '@' + score + "'"
  exec(str)
  console.log("Executing command: " + str)
})

app.get('/score', (req, res) => {
  var map_id = req.body.map_id
  var score = ""
  exec("ls -1 /data | grep '@" + map_id + "@' | sort -t '@" + map_id + "@' -k 2 | head -1", // unix piping amirite
    (err, stdout, stderr) => { res.send(stdout) } )
})

app.listen(3000, () => console.log("Listening on port 3000"))
