string  = require 'string'
through2 = require 'through2'



module.exports = ->
  words = 0
  lines = 1

  transform = (chunk, encoding, cb) ->

    #check and update number of lines and build chunk string for other checks
    if chunk.includes('\n')
      lines =0;
      chunkSplit = chunk.split('\n');
      lines += chunkSplit.length;
      chunk = '';
      for item of chunkSplit
        chunk += chunkSplit[item];


    #check in case the string includes quotes
    if chunk.includes('"')

      indexQuotesArray = [];
      i = 0;
      #build array with index for each quote
      while i< chunk.length
        if chunk.charAt(i) == '"'
          indexQuotesArray.push(i);
        i++;


      j = 0;
      iterationsNumber = 0;
      lastIndex = 0;

      #variable to create the new chunk without the words between quotes
      newChunk = '';

      


      while j< indexQuotesArray.length
        end =  null;
        end = indexQuotesArray[j+1];

        #check in case number of quotes is not even
        if end
          k = 0;
          while k < chunk.length
            if k >= indexQuotesArray[j] && k <= end
              #substitution in the new chunk to be able to count the single words with the space split
              #only in the positions of the current range between quotes
              newChunk +=' '
            else
              if iterationsNumber == 0
                #concatenation of the first part of the string in case it's the first iteration
                if k < indexQuotesArray[j]
                  newChunk += chunk.charAt(k);
              else
                #concatenation of the part of string included between the last quote and the first one of
                #the current range 
                if lastIndex && k > lastIndex && k < indexQuotesArray[j]
                  newChunk += chunk.charAt(k);
            k++;
          #check on content of the string before increasing the counter
          if chunk.substring(indexQuotesArray[j],end+1) != '" "' && chunk.substring(indexQuotesArray[j],end+1) != '""'
            words++;
        else
          #in case the number of quotes is odd and there is no end, it implements the concatenation 
          #until the end of the string
          k = 0;
          while k < chunk.length
            if k> lastIndex 
              newChunk += chunk.charAt(k);
            k++;


        iterationsNumber++;
        #last index to check from which index it needs to concatenate 
        lastIndex = end;
        j+=2;


      #double check that all the string has been copied into the new chunk
      if lastIndex!=chunk.length
        k = 0;
        while k < chunk.length
          if k>lastIndex
            newChunk += chunk.charAt(k);
          k++;

      #split where there is space and push in the tokens array only of the non empty cells
      temporaryTokens = newChunk.split(' ');
      tokens = [];
      for item of temporaryTokens
        #add checks on other special characters
        if temporaryTokens[item]!=''
          tokens.push(temporaryTokens[item]);
      
      #increase the words counter based on the number of tokens
      words += tokens.length;
      for item of tokens
        i =0;
        while i <= tokens[item].length
          #check of each character of each token in case the camel case is applied and it needs to count more words
          character = tokens[item].charAt(i);
          if isNaN(character * 1) && i!=0 && character!=''
            #add checks on other special characters
            if character == character.toUpperCase() && !character.includes('!') && !character.includes('"')
              words++;
          i++;
    else
      # in case there are no quotes it splits and checks the number of words and the camel case 
      #straight away, should create a function to be able to not repeat the code
      temporaryTokens = chunk.split(' ');
      tokens = [];
      for item of temporaryTokens
        if temporaryTokens[item]!=''
          tokens.push(temporaryTokens[item]);

      words = tokens.length;
      for item of tokens
        i =0;
        while i <= tokens[item].length
          character = tokens[item].charAt(i);
          if isNaN(character * 1) && i!=0 && character!=''
            if character == character.toUpperCase()
              words++;
          i++;
    
    # console.log("tokens");
    # console.log(tokens);
    # console.log("words");
    # console.log(words);
    return cb()


  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  

  return through2.obj transform, flush
