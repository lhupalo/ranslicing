# Heterogeneous Orthogonal Multiple Access (H-OMA) 

### General Concept of H-OMA
  The word "heterogeneous" is introduced by professor **Petar Popoviski** on **"5G Wireless Network Slicing for eMBB, URLLC, and mMTC: A Communication-Theoretic View"**.
  
  The 5G wireless systems will support three generic services:
  - mMTC: Massive Machine Type Communications;
  - eMBB: Enhanced Mobile Broadband;
  - URLLC: Ultra Reliable Low-Latency Communications;
  
  The paper cited above discuss how one can allow the sharing of physical resources among the different services for the **uplink**. This is widely known as **Network Slicing**, and in this case, the slicing is performed on the physical layer.


### H-OMA for mMTC and eMBB
  This particular case is achieved by the code availabe [here](https://github.com/lhupalo/ranslicing/blob/master/homa.m).
  
  Basically, the two type of services are allowed to access the Base Station and use the available resources by the following time-division scheme:
  
  Let 
 
  <img src="https://latex.codecogs.com/svg.image?\alpha&space;\;&space;\in&space;\;&space;[0,1]" title="\alpha \; \in \; [0,1]" />,
  
  with &alpha; being the fraction of time when the resources are allocated to eMBB and 1-&alpha; the fraction of time when the resources are allocated to mMTC:
  
  **mMTC**
  
  <img src="https://latex.codecogs.com/svg.image?\lambda_M&space;=&space;\lambda_M^{orth}\left&space;(&space;\frac{r_M}{1-\alpha}&space;\right)" title="\lambda_M = \lambda_M^{orth}\left ( \frac{r_M}{1-\alpha} \right)" />
  
  P.S.: Beware, the term in parenthesis is the argument of the fuction of &lambda;<sub>M</sub><sup>orth</sup>. It's more explicit in the code.
  
  **eMBB**
  
  
  <img src="https://latex.codecogs.com/svg.image?r_{B,f}&space;=&space;\alpha&space;r_{B,f}^{orth}&space;" title="r_{B,f} = \alpha r_{B,f}^{orth}" />
  
  ### Results
  
  - The region below the red line represents the pairs of r<sub>B,f</sub> and &lambda;<sub>M</sub> that can be achieved. Therefore, the red line represents the theoretical limit that can be reached using Orthogonal Access in a time-division scheme.
  - The y-axis is the maximum number of mMTC devices that can be active at the same time accessing the BS.
  - The x-axis is the channel use by the eMBB service
  
  ![This is an image](https://github.com/lhupalo/ranslicing/blob/master/homa.jpg)
  
  ### Conclusions
  
  - When &alpha; is equal to 0, we have the maximum value of mMTC devices that can access the BS, i.e. the minimum number of mMTC devices in outage. At this scenario, the mMTC devices have all the resources availabe to transmit to the BS, explaining the high value in the graph.
  - When &alpha; is equal to 1, we have the maximum use of channel that can be reached by eMBB users. Similarly to mMTC, in this case all the resources are available to eMBB devices
  - As &alpha; goes from 0 to 1, the time allowed to mMTC transmissions decreseas, forcing the devices to transmit at a faster rate than r<sub>M</sub>
