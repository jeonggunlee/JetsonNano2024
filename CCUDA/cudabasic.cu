#include <iostream>
#include <cuda.h>
using namespace std;

int *host_A, *host_C1, *host_C2;       // host data
int *device_A, *device_C;   // results

__global__ void vecAddOne(int *A, int *C, int N)
{
   int i = blockIdx.x * blockDim.x + threadIdx.x;
    
   if( i < N )
      C[i] = A[i] + 1; 
}

void vecAddOne_h(int *A1, int *C1, int N)
{
   for(int i=0;i<N;i++)
      C1[i] = A1[i] + 1;
}

int main(int argc,char **argv)
{
   int n=1024*1024;
   int nBytes = n*sizeof(int);
   int block_size = 32, block_no = n / block_size; 

   // ===============================================================
   // CPU 메모리 설정 
   //
   host_A = (int *)malloc(nBytes);
   host_C1 = (int *)malloc(nBytes);    
   host_C2 = (int *)malloc(nBytes);    

   // ===============================================================    
   printf("Allocating device memory on host..\n");
   cudaMalloc((void **)&device_A, n*sizeof(int));
   cudaMalloc((void **)&device_C, n*sizeof(int));
   // ===============================================================    
   printf("Copying to device..\n");
   cudaMemcpy(device_A, host_A, n*sizeof(int),cudaMemcpyHostToDevice);
   // ===============================================================
   printf("Doing GPU Vector + 1 \n");
   vecAddOne<<<block_no,block_size>>>(device_A, device_C, n);   
   cudaDeviceSynchronize();
   // ===============================================================
   printf("Doing a CPU Vector add\n");    
   vecAddOne_h(host_A, host_C1, n);
   
   cudaMemcpy(host_C2, device_C, n*sizeof(int), cudaMemcpyDeviceToHost);

   // 결과 비교
   printf("결과 비교\n");
   for(int i=0; i<n;i++)
   {
       if(host_C1[i] != host_C2[i])
       {
           printf("Something Wrong ! \n");
           break;
       }
   }
   cudaFree(device_A);
   cudaFree(device_C);
   free(host_A);
   free(host_C1);
   free(host_C2);
   return 0;
}  
