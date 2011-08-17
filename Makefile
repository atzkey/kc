.POSIX:

sourcedir = ./src
distdir = ./dist

programs = kc kc+ kc-
docs = README
distfiles = config.mk $(distdir)

VPATH=.:$(distdir)

.PHONY: all
all::

config.mk:
	@echo "Please run './configure -h' before trying to make"
	exit 1

include config.mk

all:: build

.PHONY: build
build: $(programs)
	@echo
	@echo "Ka-Ching! just have been built"

kc:
	cp $(sourcedir)/kc.sh $(distdir)/kc

kc+: kc
	ln -s kc $(distdir)/kc+

kc-: kc
	ln -s kc $(distdir)/kc-

.PHONY: install
install: build
	install -d $(bindir); \
	for i in $(programs); do \
		install -m 755 $(distdir)/$$i $(bindir)/$$i; \
	done

$(distdir):
	+@[ -d $@ ] || mkdir -p $@

%:: $(distdir); :

.PHONY: clean
clean:
	for i in $(programs); do \
		rm -f $(distdir)/$$i; \
	done

.PHONY: distclean
distclean: clean
	rm -rf $(distfiles)

