#!/bin/sh
#
#  apt-env.sh
#
#  apt-env - apt palsu!
#  Copyright (c) 2003 Fajran Iman Rusadi
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

#
# @version  1.2
#


CURRDIR=`pwd`
SRCLIST=/etc/apt/sources.list

BASH_RC=$CURRDIR/apt-env.bashrc

[ -f $BASH_RC ] && rm -f $BASH_RC
cat > $BASH_RC <<BASHRC

CURRDIR=`pwd`
SRCLIST=/etc/apt/sources.list

ENVDIR=\$CURRDIR/virtual

ETCAPT_DIR=\$ENVDIR/etc/apt
DPKG_DIR=\$ENVDIR/var/lib/dpkg
APT_DIR=\$ENVDIR/var/lib/apt
ARCH_DIR=\$ENVDIR/var/cache/apt/archives
TMP_DIR=\$ENVDIR/tmp

export APTENV_DIR=\$ENVDIR

install -d \$ENVDIR
pushd \$ENVDIR > /dev/null

install -d \$ETCAPT_DIR
install -d \$DPKG_DIR
install -d \$APT_DIR/lists/partial
install -d \$ARCH_DIR/partial
install -d \$TMP_DIR

[ -d \$ENVDIR/debs ] || ln -s \$ARCH_DIR \$ENVDIR/debs

touch \$APT_DIR/lock
touch \$APT_DIR/status
touch \$APT_DIR/lists/lock
touch \$APT_DIR/lock
touch \$DPKG_DIR/status

[ -f \$ETCAPT_DIR/sources.list ] || cp \$SRCLIST \$ETCAPT_DIR/sources.list

[ -f \$ETCAPT_DIR/apt.conf ] || cat > \$ETCAPT_DIR/apt.conf <<APTCONF

APT {
	Get {
		Download-Only	"true";
	};
};

Dir {
	State "\$APT_DIR" {
		Status	"\$DPKG_DIR/status";
	};
	Cache "\$TMP_DIR" {
		Archives	"\$ARCH_DIR";
	};
	Etc "\$APT_DIR" {
		SourceList	"\$ETCAPT_DIR/sources.list";
	};
};

APTCONF

declare -x APT_CONFIG=\$ETCAPT_DIR/apt.conf

export PS1="\n\033[32m\]\u@\h \[\033[33m\w\033[0m\]\n$ "
export PS1="\n\\\\\\\$[\033[32m\]apt-env\033[0m\]]# "
alias ls="ls --color=auto"

BASHRC

bash --rcfile $BASH_RC


