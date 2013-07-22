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

PACKAGE   = pacrepo
PROG      = pacrepo
#VERSION   = 0.0.0
BUGREPORT = https://github.com/DMBuce/pacrepo/issues
URL       = https://github.com/DMBuce/pacrepo

BINFILES         = bin/$(PROG)
ETCFILES         = etc/$(PROG).conf
CLEANFILES       = bin/$(PROG)

INSTALL_FILES    = $(DESTDIR)$(bindir)/$(PROG) $(DESTDIR)$(bindir)/addpkg \
                   $(DESTDIR)$(bindir)/rmpkg $(DESTDIR)$(sysconfdir)/$(PROG).conf
INSTALL_DIRS     = $(DESTDIR)$(bindir) $(DESTDIR)$(sysconfdir)

.PHONY: all
all: $(BINFILES) $(ETCFILES)

.PHONY: clean
clean:
	rm -f $(CLEANFILES)

.PHONY: install
install: all installdirs $(INSTALL_FILES)

.PHONY: uninstall
uninstall:
	rm -f $(INSTALL_FILES)

.PHONY: installdirs
installdirs: $(INSTALL_DIRS)

$(INSTALL_DIRS):
	$(INSTALL) -d $@

$(DESTDIR)$(sysconfdir)/$(PROG).conf: etc/$(PROG).conf
	$(INSTALL) $< $@

$(DESTDIR)$(bindir)/addpkg:
	ln -s $(PROG) $@

$(DESTDIR)$(bindir)/rmpkg:
	ln -s $(PROG) $@

$(DESTDIR)$(bindir)/$(PROG): bin/$(PROG)
	$(INSTALL_PROGRAM) $< $@

bin/$(PROG): bin/$(PROG).in
	cp $< $@
	sed -i '/CONFIG=/  s?@sysconfdir@?$(sysconfdir)?'   $@

# vim: set ft=make:
