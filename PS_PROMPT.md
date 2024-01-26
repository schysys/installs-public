Prompt - install or update: 
I'm need a PowerShell script to install an application on new installs windows but also could be used on existing installs.  It must:
1. check to see if the software is installed and if installed what version the software is at. 
2. check the what latest version of the software is
3. If not installed, install the software to the version passed in as an argument or to the laterst version if not provided.  
4. If installed, and the version installed is earlier than either the latest or the version poassed in as an argument, prompt the user to (U) update or  (S) skip update for that package and keep the one installed. 
5. The script should also take in these options as arguments so that the   -s and -u arguments -v (version) can be passed in so that the script can be used in automations. also if there are any arguments the package requires also, ie: Y to continue, please include these.

If a specific version is passed in as an argument -v , then check the 


Prompt - Specific Version w/ Github Binary:
I'm need a PowerShell script to install an application on new Windows installs but also could be used on existing installs.  Could you write a script which checks to see if the following software is installed, and if not,  install the program , and if it is already installed check the version is excactly as the one required and if the version is not then prompt the user to update to the specified version, (U) update or  (S) skip update for that package and keep the existing. The script should also take in these options as arguments so that the   -s and -u arguments can be passed in so that the script can be used in automations. also if there are any arguments the package requires also, ie: Y to continue, please include these. 
packages: 
Dell Display Manager 2.2.0.43
Bianary location: 
https://github.com/schysys/winstalls-public/blob/c08bb20efb4aac48d352eb593015a7f85084d807/DellDisplayManager/2.2.0.43/ddmsetup.exe