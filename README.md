# LocalOctaTilt
Matlab code used for phenomenological model in publication: Dynamic nanodomains dictate macroscopic properties in lead halide perovskites.

Use **Simulation_QEDS.m** to simulate S(q) that arrises from local I4/mcm (P4/mbm) nanodomains in cubic perovskite structures. 
Currently, when you run the file, you will get S(q) with parameters determined from experimental data. This will reporduce S(q) presented in Fig. 1. Structure factor .txt files are needed. These are present in the folder Structure_Factor_Files. These files were generated using https://crystalmaker.com/singlecrystal/. Diffuse scattering can be generated for any symmetry be generating appropriate structure factor files using the singlecrystal software. 

All the main functions required for this code to run are present in functions folder. 


**Just_plot_MD.m** loads Molecular Dynamics (MD) S(q,E) and reproduces data from Fig. 1. 

**plot_A_cation_orientations.m** reproduces A-cation ortientations from Fig. 1. 
