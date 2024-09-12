actor Computer
  var _checker : Checker
  var _n : F64
  
  new create(checker : Checker, n : F64) =>
    _checker = checker
    _n = n
  
  be compute(k : F64, start' : F64, batch_size : F64) =>
    var sums =
    recover
      var sums : Array[F64] = []
      var count : F64 = 0
      var sum : F64 = 0
      var start = start'
      while (count < batch_size) and (count < _n) do
        sum = (((-1+k+start)*((2*(-1+k+start))+1)*(k+start)) / 6) - (((-1+start)*((2*(-1+start))+1)*(start)) / 6)
        sums.push(sum)
        start = start + 1
        count = count + 1
      end
      sums
    end
    
    _checker.is_perfect_square(consume sums, start', batch_size)

actor Checker
  var _main : Main
  
  new create(main : Main) =>
    _main = main
  
  be is_perfect_square(sums : Array[F64] iso, start' : F64, batch_size : F64) =>
    var size : F64 = 0
    var perfect_squares =
    recover
      var start = start'
      var count : F64 = 0
      var squares : Array[F64] = []
      
      while count < batch_size do
        try
          var sum = sums.apply(count.usize())?
        
          var sqrt = sum.sqrt().u64()
          if (sqrt * sqrt) == F64(sum).u64() then
            squares.push(start)
            size = size + 1
          end
        end
        start = start + 1
        count = count + 1
      end
      
      squares
    end
    
    _main.display(consume perfect_squares, size)

actor Main
  var _env : Env
  var _n : F64
  var _k : F64
  
  new create(env: Env) =>
    _env = env
    _n  = -1
    _k = -1
    
    try
      _n = env.args(1)?.f64()?
      _k = env.args(2)?.f64()?
    else
      return
    end
    
    solve()
  
  be solve() =>
    var count : F64 = 1
    var checker = Checker(this)
    var computer = Computer(checker, _n)
    while count <= _n do
      computer.compute(_k, count, 10000)
      count = count + 10000
    end
  
  be display(results : Array[F64] iso, size : F64) =>
    var count : F64 = 0
    while count < size do
      try
       _env.out.print(results.apply(count.usize())?.string())
      end
      count = count + 1
    end
