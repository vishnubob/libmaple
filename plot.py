#!/usr/bin/env python

import matplotlib
matplotlib.use('AGG')
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import pylab


def plot(data, fofn, title, xlabel, ylabel, log=False, xlog=False, legend=None, legend_location="lower right", xticklabels=None, **kw):
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)
    if log:
        ax.set_yscale('log')
    if xlog:
        ax.set_xscale('log')
    if type(data[0]) in (tuple, list):
        for subdata in data:
            ax.plot(subdata, **kw)
    else:
        ax.plot(data, **kw)
    if xticklabels:
        ax.set_xticklabels(xticklabels)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    if legend:
        plt.legend(legend, loc=legend_location)
    plt.savefig(fofn)

f = open("accel.txt")
data = [map(int, line.split(',')) for line in f]
data = data[::10]
plot(zip(*data), "accel.png", "Accelerometer data", "Time", "Value", legend=('X', 'Y', 'Z'))
