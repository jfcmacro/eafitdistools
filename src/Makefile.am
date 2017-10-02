#
bin_SCRIPTS = edtinit edtgetrepos edtsetevalunit edtctrl
CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = edtinit.sh edtgetrepos.sh edtsetevalunit.sh edtctrl.sh

edtinit: $(srcdir)/edtinit.sh
	cp $(srcdir)/edtinit.sh edtinit
	chmod +x edtinit

edtgetrepos: $(srcdir)/edtgetrepos.sh
	cp $(srcdir)/edtgetrepos.sh edtgetrepos
	chmod +x edtgetrepos

edtsetevalunit: $(srcdir)/edtsetevalunit.sh
	cp $(srcdir)/edtsetevalunit.sh edtsetevalunit
	chmod +x edtsetevalunit

edtctrl: $(srcdir)/edtctrl.sh
        cp $(srcdir)/edtctrl.sh edtctrl
        chmod +x edtctrl
