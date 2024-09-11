actor Computer
  var _checker : Checker
  
  new create(checker : Checker) =>
    _checker = checker
  
  be compute(k : F64, start : F64) =>
    var sum = (((-1+k+start)*((2*(-1+k+start))+1)*(k+start)) / 6) - (((-1+start)*((2*(-1+start))+1)*(start)) / 6)
    var sqrt = sum.sqrt().u64()
    _checker.is_perfect_square(sqrt, sum, start)

actor Checker
  var _main : Main
  
  new create(main : Main) =>
    _main = main
  
  be is_perfect_square(sqrt : U64, sum : F64, start : F64) =>
    if (sqrt * sqrt) == F64(sum).u64() then
      _main.display(start)
    end

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
    var computer = Computer(checker)
    while count <= _n do
      computer.compute(_k, count)
      count = count + 1
    end
  
  be display(result : F64) =>
    _env.out.print(result.string())
