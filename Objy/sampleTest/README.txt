Standard usage:
1. Open mainSample.pl and verify the INSTALL_DIR.
2. In command prompt (Visual Studio Command Prompt on Windows), run:
 perl mainSample.pl | tee out.txt
3. Verify the sample output.

NOTE: In Windows, the script sqlSampleRunner.pl uses nmake to compile the sample.
To run sqlSampleRunner.pl, the main script mainSample.pl or the script sqlSampleRunner.pl itself should be run in Visual Studio Command Prompt (instead of standard Command Prompt).