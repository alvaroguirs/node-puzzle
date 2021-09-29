through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0

  transform = (chunk, encoding, cb) -> 
    
    data = chunk.toString().split '\n'

    for line in data when line
      line = line.replace /([a-z])([A-Z])/g, '$1 $2'
      lines++      
      tokens = line.split ///\s+(?=[^"]*(?:"[^"]*"[^"]*)*$)///
      words += tokens.length    
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
