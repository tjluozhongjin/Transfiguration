var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var multer = require('multer');
var fs = require('fs');

var index = require('./routes/index');
var users = require('./routes/users');

var app = express();

let contentType = {
  "css": "text/css",
  "gif": "image/gif",
  "html": "text/html",
  "ico": "image/x-icon",
  "jpeg": "image/jpeg",
  "jpg": "image/jpeg",
  "js": "text/javascript",
  "json": "application/json",
  "pdf": "application/pdf",
  "png": "image/png",
  "svg": "image/svg+xml",
  "swf": "application/x-shockwave-flash",
  "tiff": "image/tiff",
  "txt": "text/plain",
  "wav": "audio/x-wav",
  "wma": "audio/x-ms-wma",
  "wmv": "video/x-ms-wmv",
  "xml": "text/xml"
}

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, '../uploads')
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '.png')
  }
})

var upload = multer({
  storage: storage,
});

app.post('/file', upload.single('file'), function(req, res, next) {
  res.end("file saved!");
});

app.get('/getFile', function(req, res, next) {
  res.setHeader("Content-Type", contentType);
  var content =  fs.readFileSync('../uploads/file.png', "binary");
  res.writeHead(200, "Ok");
  res.write(content, "binary");
  res.end();
});

var unlock = false;

function setUnlockFalse() {
  unlock = false;
  console.log(unlock);
}

app.get('/getUnlock', function(req, res) {
  res.json(unlock);
})

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

/*
var deadlock = true;

app.post('/deadlock', function(req, res) {
  deadlock = (req.body['deadlock'] == 'true');
  console.log(deadlock);
  res.end('success');
})

app.get('/getDeadlock', function(req, res) {
  res.json(deadlock);
})
*/

app.post('/unlock', function(req, res) {
  unlock = (req.body['unlock'] == 'true');
  console.log(req.body);
  console.log(unlock);
  res.end('success');
  setTimeout(setUnlockFalse, 10000);
})

var present = [false, false, false, false];

app.post('/present', function(req, res) {
  console.log(req.body);
  for(var i=0; i<4; i++) {
    present[i] = req.body[i];
  }
  res.send(present);
})

app.get('/getPresent', function(req, res) {
  res.json(present);
})

var currentData;

app.post('/data', function(req, res) {
  currentData = req.body;
  res.send(req.body);
});

app.get('/getData', function(req, res) {
  res.json(currentData);
})

var sensorData;

app.post('/sensor', function(req, res) {
  sensorData = req.body;
  res.send(sensorData);
});

app.get('/getSensor', function(req, res) {
  res.json(sensorData);
})

app.use('/', index);
app.use('/users', users);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});



// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
