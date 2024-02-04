#include <stdio.h>

__global__ void helloCUDA(void)
{
  printf("Hello thread %d in block %d\n", threadIdx.x, blockIdx.x);
}

int main()
{
  int n = 12;
  int blockDim = 4;            // Block내의 Thread의 수
  int gridDim = n / blockDim;  // Grid에서 Block의 수
  
  // 따라서, 전체 생성 thread의 수는 blockDim * threadDim  
    
  helloCUDA<<<gridDim, blockDim>>>();
    
  cudaDeviceSynchronize();
  return 0;
}
