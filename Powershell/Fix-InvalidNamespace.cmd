cd \windows\system32\wbem

net stop winmgmt
rename Repository Repository.old
net start winmgmt

for /f %s in ('dir /b *.mof *.mfl') do mofcomp %s
