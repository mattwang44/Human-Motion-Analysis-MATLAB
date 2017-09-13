# Human Motion Analysis Programming
*Supervised by Prof. [Tung-Wu Lu](http://oemal.bme.ntu.edu.tw/professor/professorE.htm), Dept. of BioMedical Engineering, NTU*

Implemented MATLAB programs with a motion capture system and force plates for motion analysis, including motion tracking, evaluation of body balance, and derivation of joint forces and torques of the lower body.

## Requirements
1. MATLAB 2015 (or newer versions)
2. [MTIMESX function](https://www.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support)(Fast Matrix Multiply with Multi-Dimensional)
3. Programs are tested in Win10 & Ubuntu 16.04

## Functions & Execution Results
### Week1: Transformation between Global & Local Coordinate  
The transformation of marker position between global & local coordinate of lower body segemnts.  

### Week2: COP Tracking  
Derive the COP from signals of two force plates and display the positions relative to force plates.  
  
![COP Tracking](/results/COP.gif) 

### Week3: Euler Angle & Fixed Angle
1. Represent the rotations of body segemnts with **Euler angle** and **fixed angle**.  
2. Display the difference of Euler angle before and after **static calibration** of indivisual during motion.  
![Static calibration](/results/hw3.png)  

### Week4: Curve Fitting
1. Smoothen the data curve and display the **angular velocity** of lower body.  
2. Consider right foot only, compare the results of **analytic solution of angular acceleration** & **1st derivation of angular velocity**.  
3. Consider right thigh only, compare the angular velocity derive from 12 sequence of Euler angle.  
The one with **Gimbal** lock during motion can be easily detemined and then be avoided.  
<img src="/results/hw4_AngVel.jpg" width="280"><img src="/results/hw4_AngAcc.jpg" width="280"><img src="/results/hw4_12RotSeq.jpg" width="280">  

### Week5: Quaternions (Euler Parameters)
1. Write the function "unwrapEP.m" to eliminate the discontinuity of Quaternions data.    
2. Compare angular velocity & angular acceleration derived from Euler angle and Quaternions(EP).  
<img src="/results/hw5_unwrapEP().jpg" width="280"><img src="/results/hw5_AngVel.jpg" width="280"><img src="/results/hw5_AngAcc.jpg" width="280">  

### Week6: Screw Axis (Helical Axis)  
1. Compare the rotation axis and angle derived from Screw axis and Quaternoins.  
2. Determine the **joint center & rotation axis with least-square error** from several rotation axes dervied during the motion.  
<img src="/results/hw6_n&phi.jpg" width="300"><img src="/results/hw6_1.jpg" width="500">  

### Week7: COM Tracking 
1. Derive & compare the COM position of whole body using Dempster's anthropometrical data with simplified the body model as 7, 11, 12, & 13 segments.  
2. Display the COM positions. (Yellow: markers' position, green: COM of body segments, purple: COM of whole body).  
<img src="/results/hw7.jpg" width="400"> <img src="/results/walk.gif" width="400"> 

### Week8: Evaluation of Body Balance
Derive the COP data during the recipient is standing still. Determined the eclipse covering 95% of COPs with **Principal COmponent Analysis (PCA)**. The area of the eclipse and length of its axes can be a tool for evaluation of body dalance.  
<img src="/results/hw8_COP95.jpg" width="400">

### Week9: Angular Momentum  
Derive the angular momentum and 1st derivation of angular momentum during the motion.
<img src="/results/hw9_AngMoment.jpg" width="430"> <img src="/results/hw9_1der.jpg" width="430"> 
