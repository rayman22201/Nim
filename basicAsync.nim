import asyncdispatch

type Buffer = ref object
  value: int

type SomeObj = object
  buffer: Buffer

proc `=`(dst: var SomeObj; src: SomeObj) =
  dst.buffer = new(Buffer)
  dst.buffer.value = src.buffer.value

#proc `=destroy`(x: var SomeObj) =
  #echo "inside destroy SomeObj"
  #deepDispose(x.buffer)

proc asyncProc(a: SomeObj): Future[SomeObj] {.async.} =
  result = a # this creates an intermediate string that I can't reach with dispose?

echo "start"
GC_disable()
dumpNumberOfInstances()
var obj = SomeObj(buffer: new(Buffer))
obj.buffer.value = 42
var fut = asyncProc(obj)
var res = waitFor fut
dispose(fut)
deepDispose(res.buffer)
#`=destroy`(res)
echo "finish"
dumpNumberOfInstances()
