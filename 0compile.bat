Utilities\astyle\astyle.exe --style=allman --recursive DoomRPG/scripts/*.c,*.h DoomRPG/zscript/*.zs DoomRPG-CorruptionCards/zscript/*.zs DoomRPG-CorruptionCards/zscript/corruptioncards/*.zscript
Utilities\python\python.exe compile.py 
del IR\*.obj