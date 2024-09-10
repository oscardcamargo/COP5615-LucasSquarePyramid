actor Main
  new create(env: Env) =>
    var n : F64 = -1
    var k : F64 = -1
    
    try
    n = env.args(1)?.f64()?
    k = env.args(2)?.f64()?
    else
      return
    end

    var count : F64 = 1
    while count <= (n+k) do
      var result : F64 = (((-1+k+count)*((2*(-1+k+count))+1)*(k+count))/6)-(((-1+count)*((2*(-1+count))+1)*(count))/6)
      var res : U64 = result.sqrt().u64()
      if (res * res) == F64(result).u64() then
        env.out.print(count.string())
      end
      count = count + 1
    end
