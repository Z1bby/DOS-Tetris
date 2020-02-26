del %1.lst
del %1.crf
del %1.obj
del %1.exe
masm %1.asm,,,;
link %1.obj;
%1.exe
