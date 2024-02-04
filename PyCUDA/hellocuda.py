import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule
import numpy

mod = SourceModule("""
  #include <stdio.h>

  __global__ void hellocuda()
  {
    printf("I am tx:%d.ty:%d bx:%d.by:%d\\n", threadIdx.x, threadIdx.y, blockIdx.x, blockIdx.y);
  }
  """)


func = mod.get_function("hellocuda")
func(block=(2,2,1), grid=(2,2))

# Flush context printf buffer
cuda.Context.synchronize()
