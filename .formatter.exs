[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test,scripts}/**/*.{ex,exs}"],
  import_deps: [:stream_data, :nimble_parsec, :plug, :benchee_dsl],
  locals_without_parens: [prove: 1, prove: 2]
]
