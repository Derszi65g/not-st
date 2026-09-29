# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = src/st.c src/x.c src/rowcolumn_diacritics_helpers.c src/graphics.c src/boxdraw.c src/hb.c src/st_config.c
OBJ = $(SRC:.c=.o)

all: st

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $< -o $@

src/st.o: config.h src/st.h src/win.h src/graphics.h
src/x.o: src/arg.h config.h src/st.h src/win.h src/graphics.h src/hb.h src/st_config.h
src/graphics.o: src/graphics.h src/khash.h src/kvec.h src/st.h
src/boxdraw.o: config.h src/st.h src/boxdraw_data.h
src/hb.o: src/st.h
src/st_config.o: src/st_config.h

$(OBJ): config.h config.mk

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ) config.h st-$(VERSION).tar.gz *.o

dist: clean
	mkdir -p st-$(VERSION)
	cp -R LICENSE Makefile README.md config.mk \
		config.def.h st.info st.1 src assets examples tools \
		st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)

install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin/not-st
	chmod 755 $(DESTDIR)$(PREFIX)/bin/not-st
	[ -f tools/st-urlhandler ] && cp -f tools/st-urlhandler $(DESTDIR)$(PREFIX)/bin && chmod 755 $(DESTDIR)$(PREFIX)/bin/st-urlhandler || :
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx st.info
	mkdir -p $(DESTDIR)$(PREFIX)/share/applications
	[ -f assets/st.desktop ] && cp -f assets/st.desktop $(DESTDIR)$(PREFIX)/share/applications/st.desktop || :
	mkdir -p $(DESTDIR)$(PREFIX)/share/pixmaps
	[ -f assets/st.png ] && cp -f assets/st.png $(DESTDIR)$(PREFIX)/share/pixmaps/st.png || :
	mkdir -p $(DESTDIR)/etc/st
	[ -f examples/st.conf.example ] && cp -f examples/st.conf.example $(DESTDIR)/etc/st/st.conf.example || :
	@echo Please see the README.md file regarding the terminfo entry of st.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/not-st $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(PREFIX)/bin/st-urlhandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1
	rm -f $(DESTDIR)$(PREFIX)/share/applications/st.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/pixmaps/st.png

.PHONY: all clean dist install uninstall
