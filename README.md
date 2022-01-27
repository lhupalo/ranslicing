# Heterogeneous Orthogonal Multiple Access (H-OMA) 

## General Concept of H-OMA
  The word "heterogeneous" is introduced by professor **Petar Popoviski** on **"5G Wireless Network Slicing for eMBB, URLLC,and mMTC: A Communication-Theoretic View"**.
  
  The 5G wireless systems will support three generic services:
  - mMTC: Massive Machine Type Communications;
  - eMBB: Enhanced Mobile Broadband;
  - URLLC: Ultra Reliable Low-Latency Communications;
  
  The paper cited above discuss how one can allow the sharing of physical resources among the different services. This is widely known as **Network Slicing**, and in this case, the slicing is performed on the physical layer.


### H-OMA for mMTC and eMBB
  This particular case is achieved by the code availabe [here](https://github.com/lhupalo/ranslicing/blob/master/homa.m).
  
  Basically, the two type of services are allowed to access the Base Station and use the available resources bey the following time-division scheme:
  
  - Let 
  <img src="https://latex.codecogs.com/svg.image?\alpha&space;\;&space;\in&space;\;&space;[0,1]" title="\alpha \; \in \; [0,1]" />,
  and &alpha; is the fraction of time when the resources are allocated to mMTC and 1-&alpha; the fraction of time when the resources are allocated to eMBB:
  
  **mMTC**
  <img src="https://latex.codecogs.com/svg.image?\lambda_M&space;=&space;\lambda_M\left&space;(&space;\frac{r_M}{1-\alpha}&space;\right&space;)&space;" title="\lambda_M = \lambda_M\left ( \frac{r_M}{1-\alpha} \right )" />
  
  **eMBB**
  <img src="https://latex.codecogs.com/svg.image?r_{B,f}&space;=&space;\alpha&space;r_{B,f}^{orth}&space;" title="r_{B,f} = \alpha r_{B,f}^{orth}" />
  
  ### Results
  
  - The region below the red line represents the pairs of r<sub>B,f</sub> and &lambda;<sub>M</sub> that can be achieved. Therefore, the red line represents the theoretical limit that can be reached using Orthogonal Access.
  - The y-axis is the maximum number of mMTC devices that can be active at the same time accessing the BS.
  - The x-axis is the channel use by the eMBB service
  
  ![This is an image](https://github.com/lhupalo/ranslicing/blob/master/homa.jpg)
