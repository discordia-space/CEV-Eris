SET z_levels=6
cd

FOR /R ../../maps/ %%f IN (*.dmm) DO (
  java -jar MapPatcher.jar -clean %%f.backup %%f %%f
)

pause