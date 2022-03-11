echo off
cls
set program=DRUM ERASER v1.1
echo #################################################################################################### >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo %date%, %time:~0,8%: %program% started.  >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo %program%
echo The batch is created to help to delete an odd drum from Ignalina Drum Measurement sytem database
echo Created by Jevgenij Kariagin
echo 2020-01 - 2020-02
echo ---------------------------------------------------
set /p id="Enter a drum ID to be deleted: "
echo %date%, %time:~0,8%: drum ID: "%id%" is entered  >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo The drum number "%id%" is to be deleted
sqlcmd -S CE-IGNALINA\WINCCPLUSMIG2014 -d IGNALINA-DMS -Q "select barrel as Drum_id, abfmas as Mass, astime as Measured_on from Barrel where barrel = %id%; select fullname as Operator, container as Loaded_into_container from Barrel where barrel = %id%; select NCLName as Nuclide, NCLAct as Activity from BarrelNucList where barrel = %id%;"
sqlcmd -S CE-IGNALINA\WINCCPLUSMIG2014 -d IGNALINA-DMS -Q "select barrel as Drum_id, abfmas as Mass, astime as Measured_on from Barrel where barrel = %id%; select fullname as Operator, container as Loaded_into_container from Barrel where barrel = %id%; select NCLName as Nuclide, NCLAct as Activity, NCLMDA as MDA from BarrelNucList where barrel = %id%;" >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo Please ensure the drum "%id%" is not loaded to a container.
set /p answer="Please confirm to delete the drum %id% from the database (y/n): "
if %answer% equ y (
echo %date%, %time:~0,8%: drum "%id%" deletion is confirmed  >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo drum "%id%" deletion is confirmed
sqlcmd -S CE-IGNALINA\WINCCPLUSMIG2014 -d IGNALINA-DMS -Q "delete from Barrel where barrel = %id%; delete from BarrelNucList where barrel = %id%;"
echo %date%, %time:~0,8%: deletion the drum "%id%" is supposed to has been done >> D:\DrumScannerIgnalina\Data\drum_eraser.log
echo The drum "%id%" is supposed to has been deleted from the database ^(if no error occured above^)
) else (
echo drum "%id%" deletion is refused
echo %date%, %time:~0,8%: drum "%id%" deletion is refused with "%answer%" instead of confimation >> D:\DrumScannerIgnalina\Data\drum_eraser.log
)
pause
echo %date%, %time:~0,8%: program is closed >> D:\DrumScannerIgnalina\Data\drum_eraser.log