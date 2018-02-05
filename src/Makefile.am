#
bin_SCRIPTS = edtinit edtgetrepos edtsetevalunit edtcabinst edtrrinitscript
CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = edtinit.sh edtgetrepos.sh edtsetevalunit.sh edtcabinst.sh edtrrinitscript.sh

edtinit: $(srcdir)/edtinit.sh
	cp $(srcdir)/edtinit.sh edtinit
	chmod +x edtinit

edtgetrepos: $(srcdir)/edtgetrepos.sh
	cp $(srcdir)/edtgetrepos.sh edtgetrepos
	chmod +x edtgetrepos

edtsetevalunit: $(srcdir)/edtsetevalunit.sh
	cp $(srcdir)/edtsetevalunit.sh edtsetevalunit
	chmod +x edtsetevalunit

edtcabinst: $(srcdir)/edtcabinst.sh
	cp $(srcdir)/edtcabinst.sh edtcabinst
	chmod +x edtcabinst

edtrrinitscript: $(srcdir)/edtrrinitscript.sh
	cp $(srcdir)/edtrrinitscript.sh edtrrinitscript
	chmod +x edtrrinitscript
