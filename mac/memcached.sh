#!/bin/sh

PREFIX=/usr/local

mkdir -p ~/src
cd ~/src

# Install libevent dependency
cd ~/src/ && curl -O http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz
tar xfz libevent-1.4.14b-stable.tar.gz
cd ~/src/libevent-1.4.14b-stable
./configure --prefix=${PREFIX} && make
sudo make install
cd ..

# Install memcached and fixes
cd ~/src/ && curl -O http://www.danga.com/memcached/dist/memcached-1.4.0.tar.gz
tar xfz memcached-1.4.0.tar.gz
cd ~/src/memcached-1.4.0
./configure --prefix=${PREFIX}

# in Makefile
# LDFLAGS =  -L/lib
# LDFLAGS =  -L${libdir}
sed -e 's/-L\/lib/-L${libdir}/' Makefile > Makefile.new
mv Makefile.new Makefile

# also in Makefile
# CFLAGS = -g -O2 -I/include
# CFLAGS = -g -O2 -I${includedir}
sed -e 's/-I\/include/-I${includedir}/' Makefile > Makefile.new
mv Makefile.new Makefile

# insert in memcached.c...
# #undef TCP_NOPUSH
# #ifdef TCP_NOPUSH
cd ~/src/memcached-1.1.12 && curl -O http://topfunky.net/svn/shovel/memcached/fixmemcached_c.rb
ruby fixmemcached_c.rb > memcached.c.new
mv memcached.c.new memcached.c

make
sudo make install
cd ../..

echo "Installation complete. Please add EVENT_NOKQUEUE=1 to your shell environment."
