import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule
import numpy

mod = SourceModule("""
  __global__ void doublify(float *a)
  {
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    int idy = threadIdx.y + blockIdx.y*blockDim.y;
    int id = idx + idy*4;
    a[id] *= 2;
  }
  """)

# create two timers so we can speed-test each approach
start = cuda.Event()
end = cuda.Event()


a = numpy.random.randn(4,4)
a = a.astype(numpy.float32)
a_doubled = numpy.empty_like(a)

start.record() # start timing
a_gpu = cuda.mem_alloc(a.nbytes)
cuda.memcpy_htod(a_gpu, a)

func = mod.get_function("doublify")
func(a_gpu, block=(2,2,1), grid=(2,2))

cuda.memcpy_dtoh(a_doubled, a_gpu)
end.record() # end timing
# calculate the run length
end.synchronize()


secs = start.time_till(end)*1e-3
print("SourceModule time and first three results:")
print("%fs" % (secs))

print(a_doubled)
print(a)
