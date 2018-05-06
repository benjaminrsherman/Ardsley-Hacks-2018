var express = require('express')
var app = express()

app.set('port', (process.env.PORT || 5000))
app.use(express.static(__dirname + '/public'))

app.listen(app.get('port'), function() {
  console.log("Node app is running at localhost:" + app.get('port'))
})

app.get('/', function(request, response) {
  response.send('http://localhost:5000/addscore?name=testname&score=10')
})


app.get("/addscore", function (req, res) {
  console.log(req.query.name);
  console.log(req.query.score);
  //res.send('score: ' + req.query.score);
  //res.sendFile(__dirname + '/views/index.html');
});