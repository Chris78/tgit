REM clean up a little before packing all that stuff into a tarball:
del /Y tmp\sessions\*.*
copy /Y log\clean_development.log log\development.log
copy /Y log\clean_development.log log\standalone.log

REM create the tar ball and make an EXE from it.
cd..
tar2rubyscript tgit\
REM =================================================
REM ====                                         ====
REM ==== WHEN THE RAILS ENVIRONMENT HAS LOADED:  ====
REM ==== USE YOUR APPLICATION TO MAKE SURE       ====
REM ==== ANY REQUIRED LIBRARIES ARE LOADED!      ====
REM ====                                         ====
REM ==== THEN COME BACK HERE AND PRESS *CTRL-C*  ====
REM ====                                         ====
REM =================================================
ruby rubyscript2exe.rb tgit.rb
cd tgit

REM =================================================
REM ====                                         ====
REM ==== RUN YOUR {APP}.EXE WITH -e standalone ! ====
REM ====                                         ====
REM ====              HAVE FUN!                  ====
REM ====                                         ====
REM ====                                         ====
REM =================================================