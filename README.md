# RunAsGPU
Allows you to run programs on your secondary GPU [inspired by Kernel Kue on the LTT forums](https://linustechtips.com/main/topic/940423-setting-2nd-gpu-as-power-saving-in-graphics-settings-on-windows-10/) in order to save resources on your primary GPU. Now you finally have a use for your old GTX 1050!

Read more on the LTT Forums: https://linustechtips.com/main/topic/1215225-run-rtx-voice-or-any-program-on-second-graphics-card/

AMD Support is experimental, please report any bugs!

## To Use:
1. Download runasgpu.bat and devcon.exe
2. Run it
3. Select your Primary GPU (only has to be done once. To change, delete card.ini)
4. Choose a program to launch on your secondary GPU
5. It will prompt for admin access and launch it!

Command line options:
`-cd directory`
Use the `-cd` option before the program you wish to launch to launch it in that directory.
Example: `call RunAsGPU.bat -cd "C:\Windows" "C:\program files\google\chrome\chrome.exe" -user 1`

#### NOTICE: Your screen will go black twice when launching the program.
#### WARNING: Do not use this while a game is running!

![Setup](https://i.imgur.com/M14r6yW.png)
![Setup2](https://i.imgur.com/ywxtSTN.png)
![Prompt](https://i.imgur.com/y6U0AvM.png)

Note: devcon.exe was obtained from an official microsoft release found [here](https://superuser.com/questions/1002950/quick-method-to-install-devcon-exe).
