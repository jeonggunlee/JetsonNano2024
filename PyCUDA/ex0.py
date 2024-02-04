import pycuda.driver as cuda
import pycuda.autoinit

print("%d device(s) found." % cuda.Device.count())
 
dev = cuda.Device(0)
print("Device: %s", dev.name())
print(" Compute Capability: %d.%d" % dev.compute_capability())
print(" Total Memory: %s KB" % (dev.total_memory()//(1024)))

atts = [(str(att), value) for att, value in dev.get_attributes().items()]
atts.sort()
 
for att, value in atts:
    print(" %s: %s" % (att, value))
