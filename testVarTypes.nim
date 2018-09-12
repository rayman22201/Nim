type
  Foos = enum
    foo, bar, baz, bum, but, foobarbazbumbut
    
  FooBarBazBumBut = object
    case foos: Foos
    of foo..bar: nil
    of baz: foobaz: string
    of bum, but: c, d: int, bumbut: seq[FooBarBazBumBut]
    else: 
      a, b: int
      sons: seq[FooBarBazBumBut]
