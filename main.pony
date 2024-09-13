actor Computer
  var _checker : Checker
  var _n : F64
  var _k : F64
  var _batch_size : F64

  new create(checker : Checker, n : F64, k : F64, batch_size : F64) =>
    _checker = checker
    _n = n
    _k = k
    _batch_size = batch_size

  be compute(start' : F64) =>
    var sums =
    recover
      var sums : Array[F64] = []
      var count : F64 = 0
      var sum : F64 = 0
      var start = start'
      while (count < _batch_size) and (count < _n) do
        sum = (((-1+_k+start)*((2*(-1+_k+start))+1)*(_k+start)) / 6) - (((-1+start)*((2*(-1+start))+1)*(start)) / 6)
        sums.push(sum)
       start = start + 1
        count = count + 1
      end
      sums
    end

    _checker.is_perfect_square(consume sums, start')

actor Checker
  var _displayer : Displayer
  var _batch_size : F64

  new create(displayer : Displayer, batch_size : F64) =>
    _displayer = displayer
    _batch_size = batch_size

  be is_perfect_square(sums : Array[F64] iso, start' : F64) =>
    var size : F64 = 0
    var perfect_squares =
    recover
      var start = start'
      var count : F64 = 0
      var squares : Array[F64] = []
      
      while count < _batch_size do
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

    if size > 0 then
      _displayer.display(consume perfect_squares, size)
    end
    
actor Displayer
  var _env : Env

  new create(env : Env) =>
    _env = env
  
  be display(results : Array[F64] iso, size : F64) =>
    var count : F64 = 0
    while count < size do
      try
       _env.out.print(results.apply(count.usize())?.string())
      end
      count = count + 1
    end

actor Main
  var _env : Env
  
  new create(env: Env) =>
      _env = env
  
      var n : F64 = -1
      var k : F64 = -1
  
      try
        n = env.args(1)?.f64()?
        k = env.args(2)?.f64()?
      else
        return
      end
  
      var index : F64 = 0
      var batch_size : F64 = 10000

      var displayer = Displayer((env))
      var checkers : Array[Checker] = []
      var computers : Array[Computer] = []
      
      while index <= (n / batch_size).floor() do
        try
          checkers.push(Checker(displayer, batch_size))
          computers.push(Computer(checkers.apply(index.usize())?, n, k, batch_size))
        end
        index = index + 1
      end
      
      var count : F64 = 1
      index = 0
  
      while count <= n do
        try
          computers.apply(index.usize())?.compute(count)
        end
        
        count = count + batch_size
        index = index + 1
      end
