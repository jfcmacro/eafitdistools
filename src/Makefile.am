#
bin_SCRIPTS = edtinit edtgetrepos edtsetevalunit edtctrl edtcabinst edtrrinitscript
CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = edtinit.sh edtgetrepos.sh edtsetevalunit.sh edtctrl.sh edtcabinst.sh edtrrinitscript.sh

edtinit: $(srcdir)/edtinit.sh
	cp $(srcdir)/edtinit.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x $@

edtgetrepos: $(srcdir)/edtgetrepos.sh
	cp $(srcdir)/edtgetrepos.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x $@

edtsetevalunit: $(srcdir)/edtsetevalunit.sh
	cp $(srcdir)/edtsetevalunit.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x $@

edtctrl: $(srcdir)/edtctrl.sh
	cp $(srcdir)/edtctrl.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x edtctrl

edtcabinst: $(srcdir)/edtcabinst.sh
	cp $(srcdir)/edtcabinst.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x $@

edtrrinitscript: $(srcdir)/edtrrinitscript.sh
	cp $(srcdir)/edtrrinitscript.sh $@
	sed -i 's/EDTPACKAGE/$(PACKAGE_VERSION)/' $@
	chmod +x $@
