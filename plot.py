#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import ScalarFormatter, FuncFormatter
from matplotlib.backends.backend_pdf import PdfPages

    
def plot(version, data):
    # Extract columns
    zips =    data[:, 0]
    x_drug =  data[:, 1]
    y_covid = data[:, 2]
    income =  data[:, 3]
    
    # Plot the data
    sc = plt.scatter(x_drug, y_covid, c=income, cmap="CMRmap_r", s=10, vmin = 25000, vmax=250000)
    plt.title(f"Correlation between 2019 DRUG cases and Peak {version} COVID cases per NY zipcode", fontsize=9, pad=20)
    plt.xlabel("Drug related EMS calls per capita (log)")
    plt.ylabel("Covid related EMS calls per capita (log)")
    
    # Label colorbar and show numbers with commas
    plt.colorbar(label='Median Income').ax.yaxis.set_major_formatter(FuncFormatter(lambda x, pos: f'{x:,.0f}'))

    # Set axes to be equal, log scale, and use ScalarFormatter to show normal numbers
    plt.xlim(0.01, 20)
    plt.ylim(0.01, 20)
    plt.xscale('log')
    plt.yscale('log')
    plt.gca().xaxis.set_major_formatter(ScalarFormatter())
    plt.gca().yaxis.set_major_formatter(ScalarFormatter())
    
    ## Annotate points with zipcodes
    #for i, zipcode in enumerate(zips):
    #   color = sc.cmap(sc.norm(income[i]))
    #   plt.annotate(int(zipcode), (x_drug[i], y_covid[i]), fontsize=6, color=color)


# Plot data and save to pdf
# pass in `version` for plot title
def plot_to_pdf(version, data, pdf):
    plt.figure()
    plot(version, data)
    pdf.savefig()
    plt.close()
    

def main():
    # Initialize list to hold data for plotting
    l = []
    
    # Load the data from each of the three combined histogram versions/peaks of COVID
    # Filter into low, middle, and high income (for the purpose of easy comparison)
    # and save in the list (so that I can save in a pdf in the specific order I want)
    for version in ["1", "2", "3"]:
        data = np.loadtxt(f'./comboHisto{version}', delimiter='\t', skiprows=1)
        data_low  = data[data[:, 3] <= 75000]
        data_mid  = data[(data[:, 3] > 75000) & (data[:, 3] < 135000)]
        data_high = data[data[:, 3] >= 135000]
        l.append((version, data, data_low, data_mid, data_high))

    # Safe create pdf to save plots
    with PdfPages('plots.pdf') as pdf:
        # for each version
        # for each of all data, low income data, mid income data, and high income data
        # plot the data with the correct version title and save to the pdf
        for d in range(1, len(l[0])):
            for v in range(len(l)):
                plot_to_pdf(l[v][0], l[v][d], pdf)

            
main()
