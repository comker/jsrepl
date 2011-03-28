class JSREPL::Engines::Lisp
  constructor: (input_func, output_func, result_func, error_func, ready) ->
    Environment.prototype['print'] = (str, callback) ->
      this._value str, (val) ->
        output_func Environment.stringify val
        callback []

    Environment.prototype['input'] = (callback) ->
      input_func (str) ->
        callback new Atom str

    Environment.prototype['_error'] = (message) ->
      error_func message

    for f in ['print', 'input', '_error']
      Environment.prototype[f].toString = -> '{library macro}'

    @result_handler = (r) ->
      result_func r.toString()

    Javathcript.evalMulti JSREPL::Engines::Lisp::Library, (->), -> ready()

  Destroy: ->
    delete Javathcript
    delete JavathcriptParser
    delete JavathcriptTokenizer

  Eval: (command) ->
    Javathcript.eval command, @result_handler

  Highlight: (element) ->
    # TODO(amasad): Implement.
    console.log 'Higlighting of Lisp code not yet implemented.'
