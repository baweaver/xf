# v0.1.1 (2018-06-21)

Added `Scope#get` and `Trace#get` function arguments:

```
scope_get = Xf.scope(:a, :b).get { |v| v * 10 }
=> #<Proc:0x00007fc56911aab8@/Users/lemur/dev/xf/lib/xf/scope.rb:21>
scope_get.call({a: {b: 1}})
=> 10

trace_get = Xf.trace(:c).get { |h,k,v| [h[:name], v] }
=> #<Proc:0x00007fc5688b0d00@/Users/lemur/dev/xf/lib/xf/trace.rb:32>
trace_get.call({
  name: 'parent', c: 1, data: {
    name: 'child', c: 20, data: {
      name: 'subchild', c: 200
    }
  }
}).to_h
=> {"parent"=>1, "child"=>20, "subchild"=>200}
```

# v0.1.0 (2018-04-21)

- Initial version.
