var express = require('express')
var app = express()

app.get('/', function(req, res) {
  res.send('pls no hack thx')
})

app.listen(3000, () => console.log("Listening on port 3000"))
