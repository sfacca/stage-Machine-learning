# requisiti windows

1. ZLIB http://gnuwin32.sourceforge.net/packages/zlib.htm#:~:text=zlib%20is%20designed%20to%20be,is%20itself%20portable%20across%20platforms.  
1. G++ / http://www.mingw.org   
1. MAKE / http://gnuwin32.sourceforge.net/packages/make.htm   
1. JPEG / http://gnuwin32.sourceforge.net/packages/jpeg.htm  
1. GFORTRAN / https://gcc.gnu.org/wiki/GFortranBinariesWindows  
1. BISON / http://gnuwin32.sourceforge.net/packages/bison.htm  
1. FLEX / http://gnuwin32.sourceforge.net/packages/flex.htm    
1. FILE / http://gnuwin32.sourceforge.net/packages/file.htm 



dopo aver installato requisiti, lancia powershell-> wsl

# compilazione api hdf
1. installa requisiti
2. scarica https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/hdf5-1.8.19.tar.gz
3. estrai gz contenuto, estrai contenuti del secondo gz in una cartella
4. lancia powershell, cambia dir a dove hai estratto i contenuti della cartella
5. lancia wsl
6. esegui comando # ./configure --prefix=/usr/local/; \ make;
7. esegui comando # make install

# compilazione api hdf eos
1. installa requisiti
2. scarica  https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/HDF-EOS5.1.16.tar.Z
3. estrai in una cartella
4. powershell -> cd a quella cartella
5. lancia wsl da powershell
6. ./configure --prefix=/usr/local/ --enable-install-include --with-hdf5=/usr/local; \
    make && make install