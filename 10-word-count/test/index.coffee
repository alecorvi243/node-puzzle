assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  #to test the camel case counter
  it 'Should count 8 words', (done) ->
    input = 'FunPuzzleFunPuzzleFunPuzzleFunPuzzle FunPuzzleFunPuzzleFunPuzzleFunPuzzle'
    expected = words: 16, lines: 1
    helper input, expected, done

  #to test the words counter
  it 'Should count 9 words', (done) ->
    input = 'The quick brown fox jumps over the lazy dog'
    expected = words: 9, lines: 1
    helper input, expected, done

  #to test camel case and quoted words
  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!" word word WordWord "this is one word!"word word'
    expected = words: 8, lines: 1
    helper input, expected, done

  #to test camel case and quoted words
  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!" word word WordWord "this is one word! word word'
    expected = words: 11, lines: 1
    helper input, expected, done

  #to test camel case and quoted words
  it 'should count quoted characters as a single word', (done) ->
    input = 'word word word "this is one word!" word word WordWord "this is one word!"word word'
    expected = words: 11, lines: 1
    helper input, expected, done

  #to test camel case, quoted words and lines
  it 'Should count 3 lines and 7 words', (done) ->
    input = 'The\n
    "Quick Brown Fox"\n
    jumps over the lazyDog '
    expected = words: 7, lines: 3
    helper input, expected, done

  #to test camel case, quoted words and lines
  it 'should count quoted characters as a single word', (done) ->
    input = 'word word word "this is one word!" word word WordWord "this is one word!"\n
    word word word "this is one word!" word word WordWord "this is one word!"\n
    word word word "this is one word!" word word WordWord "this is one word!"'
    expected = words: 27, lines: 3
    helper input, expected, done

  #to test camel case and lines
  it 'Should count 8 words', (done) ->
    input = 'FunPuzzleFunPuzzleFunPuzzleFunPuzzle FunPuzzleFunPuzzleFunPuzzleFunPuzzle \n
    FunPuzzleFunPuzzleFunPuzzleFunPuzzle FunPuzzleFunPuzzleFunPuzzleFunPuzzle'
    expected = words: 32, lines: 2
    helper input, expected, done
  
  #to test quoted words
  it "this is 4 words!", (done) ->
    input = '"word""word""word""word"'
    expected = words: 4, lines: 1
    helper input, expected, done
  
  #to test quoted words
  it "this is 4 words!", (done) ->
    input = '"word" "word" "word" "word"'
    expected = words: 4, lines: 1
    helper input, expected, done
  
  #to test quoted words
  it "this is 3 words!", (done) ->
    input = '"word word" "word" "word"'
    expected = words: 3, lines: 1
    helper input, expected, done

  #to test quoted words
  it "this is 4 words!", (done) ->
    input = '"word " word " " word " " word" '
    expected = words: 4, lines: 1
    helper input, expected, done

  it "this is 3 words!", (done) ->
    input = '"word word word'
    expected = words: 3, lines: 1
    helper input, expected, done



  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
