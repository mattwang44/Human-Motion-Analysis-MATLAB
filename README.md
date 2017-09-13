# Human Motion Analysis Programming
*Supervised by Prof. [Tung-Wu Lu](http://oemal.bme.ntu.edu.tw/professor/professorE.htm), Dept. of BioMedical Engineering, NTU*

Implemented MATLAB programs with a motion capture system and force plates for motion analysis, including motion tracking, evaluation of body balance, and derivation of joint forces and torques of the lower body.

## Requirements
1. MATLAB 2015 (or newer versions)
2. [MTIMESX function](https://www.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support)(Fast Matrix Multiply with Multi-Dimensional)
3. Programs are tested in Win10 & Ubuntu 16.04

## Functions & Execution Results
### Week1: Transformation between Global & Local Coordinate 
**Functions**: CoordG2L.m, CoordL2G.m, CoordPelvis.m, CoordThigh.m, CoordShank.m, CoordFoot.m

### Week2: COP Tracking
Derive the COP from signals of two force plates and display the positions relative to force plates.

**Functions**: 
  ForcePlate.m: Derive COP from single force plate.
  
  ForcePlateN.m: Derive overall COP from multiple force plates.
![COP Tracking](/results/COP.gif) 

