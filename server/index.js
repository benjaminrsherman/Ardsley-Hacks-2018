var exec = require('child_process').exec

var express = require('express')
var app = express()

app.use(express.json())

app.get('/', (req, res) => {
  res.send('pls no hack thx')
})

app.post('/score', (req, res) => {
  var name = req.body.name
  var score = req.body.score
  var str = 'touch data/' + name + '@' + score
  exec(str)
})

app.listen(3000, () => console.log("Listening on port 3000"))
