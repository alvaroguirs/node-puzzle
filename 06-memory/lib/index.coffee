fs = require 'fs'
stream = require('stream')

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  
  fileName = "#{__dirname}/../data/geo.txt"  

  fs.stat fileName, 'utf8', (err, data) ->
    if err then return cb err
  
  total = 0
  readabale = fs.createReadStream(fileName, 'utf8')
    
  readabale.on 'data', (chunk) ->     
    readabale.pause()
    data = chunk.toString().split '\n'    
    
    for line in data when line
      line = line.split '\t'
      # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
      # line[0],       line[1],       line[3]              
      if line.length >= 4 && line[3] == countryCode then total += +line[1] - +line[0]
    readabale.resume()  

  readabale.on 'end', (e) ->
    cb null, total 
    
  readabale.on 'error', (err) ->
    cb err
   
