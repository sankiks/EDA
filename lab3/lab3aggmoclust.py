from sklearn.cluster import AgglomerativeClustering
import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat , whosmat

path = r'C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3\lungB.mat'
print("=====",whosmat(path))
data = loadmat(path,simplify_cells=True)
data