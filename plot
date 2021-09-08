import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('/home/zach/catkin_ws/path')



x = data[:, 0]
y = data[:, 1]
print(x)
print(y)
plt.scatter(x, y)
plt.show()
