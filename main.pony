actor SequenceSubset
  var _sum : F64 = -1
  var _sqrt : U64 = 0
  var _start : F64 = -1
  var _main : Main
  
  new create(main : Main) =>
    _main = main
  
  be compute(k : F64, start : F64) =>
    _sum = (((-1+k+start)*((2*(-1+k+start))+1)*(k+start)) / 6) - (((-1+start)*((2*(-1+start))+1)*(start)) / 6)
    _sqrt = _sum.sqrt().u64()
    _start = start
  
  be is_perfect_square() =>
    if (_sqrt * _sqrt) == F64(_sum).u64() then
      _main.display(_start)
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
    end
    
    _n = 3
    _k = 2
    
    solve()
  
  be solve() =>
    var count : F64 = 1
    var subproblem = SequenceSubset(this)
    while count <= _n do
      subproblem.compute(_k, count)
      subproblem.is_perfect_square()
      count = count + 1
    end
    
  
  be display(result : F64) =>
    _env.out.print(result.string())
