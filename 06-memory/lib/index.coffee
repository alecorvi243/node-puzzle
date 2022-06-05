fs = require 'fs';
eventStream = require('event-stream');


exports.countryIpCounter = (countryCode, cb) ->
  
  return cb() unless countryCode

  counter = 0;
  
  #reading the file line by line to make the usage of the heap memory more efficient
  fs
  .createReadStream("#{__dirname}/../data/geo.txt")
  .pipe(eventStream.split())
  .pipe(
    eventStream
    .mapSync((line) ->
      line = line.toString().split '\t'
      if line[3] == countryCode then counter += +line[1] - +line[0]
    ).on('error', (err) ->
      if err then return cb err
    )
    .on('end', () ->
      cb null, counter
    )
  )


  # console.log('end of file.');
  # used = process.memoryUsage().heapUsed / 1024 / 1024;
  # console.log(Math.round(used * 100) / 100);




  # fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    
  #   if err then return cb err

  #   data = data.toString().split '\n'
  #   counter = 0
    
  #   for line in data when line
  #     line = line.split '\t'
  #     if line[3] == countryCode then counter += +line[1] - +line[0]

  #   cb null, counter




