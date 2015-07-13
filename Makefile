SHELL = /bin/sh

# root for installation
prefix      = /usr/local
exec_prefix = ${prefix}

# executables
bindir     = ${exec_prefix}/bin
sbindir    = ${exec_prefix}/sbin
libexecdir = ${exec_prefix}/libexec

# data
datarootdir    = ${prefix}/share
datadir        = ${datarootdir}
sysconfdir     = ${prefix}/etc
sharedstatedir = ${prefix}/com
localstatedir  = ${prefix}/var

# misc
includedir    = ${prefix}/include
oldincludedir = /usr/include
docdir        = ${datarootdir}/doc/${PACKAGE_TARNAME}
infodir       = ${datarootdir}/info
libdir        = ${exec_prefix}/lib
localedir     = ${datarootdir}/locale
mandir        = ${datarootdir}/man
man1dir       = $(mandir)/man1
man2dir       = $(mandir)/man2
man3dir       = $(mandir)/man3
man4dir       = $(mandir)/man4
man5dir       = $(mandir)/man5
man6dir       = $(mandir)/man6
man7dir       = $(mandir)/man7
man8dir       = $(mandir)/man8
man9dir       = $(mandir)/man9
manext        = .1
srcdir        = .

INSTALL         = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA    = ${INSTALL} -m 644

LN_S        = ln -s
SED_INPLACE = sed -i

PACKAGE   = pacrepo
#PROG      = pacrepo
#VERSION   = 0.0.0
BUGREPORT = https://github.com/DMBuce/pacrepo/issues
URL       = https://github.com/DMBuce/pacrepo

BINFILES         = bin/pacrepo bin/addpkg bin/rmpkg bin/mirrorlist bin/pacpatch
ETCFILES         = etc/pacrepo.conf
EXECFILES        = lib/bootstrap.sh
CLEANFILES       = $(BINFILES)

INSTALL_FILES    = $(DESTDIR)$(bindir)/pacrepo $(DESTDIR)$(bindir)/addpkg \
                   $(DESTDIR)$(bindir)/rmpkg $(DESTDIR)$(bindir)/mirrorlist \
                   $(DESTDIR)$(bindir)/pacpatch \
                   $(DESTDIR)$(sysconfdir)/pacrepo.conf $(DESTDIR)$(libexecdir)/pacrepo/bootstrap.sh
INSTALL_DIRS     = $(DESTDIR)$(bindir) $(DESTDIR)$(sysconfdir) $(DESTDIR)$(libexecdir)/pacrepo

.PHONY: all
all: $(BINFILES) $(ETCFILES) $(EXECFILES)

.PHONY: clean
clean:
	rm -f $(CLEANFILES)

.PHONY: install
install: all $(INSTALL_FILES)

$(INSTALL_FILES): installdirs

.PHONY: uninstall
uninstall:
	rm -f $(INSTALL_FILES)

.PHONY: installdirs
installdirs: $(INSTALL_DIRS)

$(INSTALL_DIRS):
	$(INSTALL) -d $@

$(DESTDIR)$(libexecdir)/pacrepo/bootstrap.sh: lib/bootstrap.sh
	$(INSTALL) $< $@

$(DESTDIR)$(sysconfdir)/pacrepo.conf: etc/pacrepo.conf
	$(INSTALL) $< $@

$(DESTDIR)$(bindir)/%: bin/%
	$(INSTALL_PROGRAM) $< $@

bin/%: bin/%.in
	cp $< $@
	$(SED_INPLACE) 's?@sysconfdir@?$(sysconfdir)?g'   $@
	$(SED_INPLACE) 's?@libexecdir@?$(libexecdir)?g'   $@

lib/%: lib/%.in
	cp $< $@
	$(SED_INPLACE) 's?@sysconfdir@?$(sysconfdir)?g'   $@
	$(SED_INPLACE) 's?@libexecdir@?$(libexecdir)?g'   $@

# vim: set ft=make:
