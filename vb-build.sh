#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export buildlog=$HOME/buildlog
#export hdf5dir=/home/pyne-user/opt/hdf5-1.8.12-linux-x86_64-shared
export hdf5dir=/home/pyne-user/opt/hdf5
echo "Starting build" > $buildlog
sudo apt-get install python-numpy python-scipy cython python-nose git cmake vim emacs
echo "apt" >> $buildlog
cd $HOME
mkdir opt
cd opt
#echo "slib" >> $buildlog
#wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.12/bin/linux-x86_64/hdf5-1.8.12-linux-x86_64-shared.tar.gz
#tar zxvf hdf5-1.8.12-linux-x86_64-shared.tar.gz
#rm hdf5-1.8.12-linux-x86_64-shared.tar.gz
mkdir hdf5
cd hdf5
wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.11/src/hdf5-1.8.11.tar.gz
tar zxvf hdf5-1.8.11.tar.gz
rm hdf5-1.8.11.tar.gz
mkdir build
cd build
../hdf5-1.8.11/configure --enable-shared --prefix=$HOME/opt/hdf5 --enable-cxx
make
make install
cd ../../
echo "export LD_LIBRARY_PATH=$hdf5dir/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=$hdf5dir/lib:\$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=$hdf5dir/include:\$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=$hdf5dir/include:\$C_INCLUDE_PATH" >> ~/.bashrc
source ~/.bashrc
echo "hdf5" >> $buildlog
git clone https://github.com/pydata/numexpr.git
cd numexpr
python setup.py install --user
cd ..
echo "numexpr" >> $buildlog
git clone https://github.com/PyTables/PyTables.git
cd PyTables
python setup.py install --user --hdf5=/home/pyne-user/opt/hdf5
cd ..
echo "pytables" >> $buildlog
mkdir moab
cd moab
wget http://ftp.mcs.anl.gov/pub/fathom/moab-4.6.2.tar.gz
tar zxvf moab-4.6.2.tar.gz
rm moab-4.6.2.tar.gz
mkdir build
cd build
../moab-4.6.2/configure --enable-shared --with-hdf5=/home/pyne-user/opt/hdf5 --prefix=/home/pyne-user/.local
make
make install
echo "export LD_LIBRARY_PATH=/home/pyne-user/.local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=/home/pyne-user/.local/lib:\$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=/home/pyne-user/.local/include:\$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=/home/pyne-user/.local/include:\$C_INCLUDE_PATH" >> ~/.bashrc
source ~/.bashrc
echo "moab" >> $buildlog
cd ../../
wget https://pypi.python.org/packages/source/P/PyTAPS/PyTAPS-1.4.tar.gz
tar zxvf PyTAPS-1.4.tar.gz
rm PyTAPS-1.4.tar.gz
cd PyTAPS-1.4/
python setup.py --iMesh-path=/home/pyne-user/.local/ install --user
echo "pytaps" >> $buildlog
cd ..
git clone https://github.com/pyne/pyne.git
cd pyne
python setup.py install --user
echo "export PATH=/home/pyne-user/.local/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/home/pyne-user/.local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc
cd scripts
./nuc_data_make
cd ..
cd tests
nosetests
echo "pyne" >> $buildlog
cd $HOME
echo "done!" >> $buildlog
