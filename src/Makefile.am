#
bin_SCRIPTS = edtinit edtgetrepos edtsetevalunit edtnewcmd
CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = edtinit.sh edtgetrepos.sh edtsetevalunit.sh edtnewcmd.sh

edtinit: $(srcdir)/edtinit.sh
	cp $(srcdir)/edtinit.sh edtinit
	chmod +x edtinit

edtgetrepos: $(srcdir)/edtgetrepos.sh
	cp $(srcdir)/edtgetrepos.sh edtgetrepos
	chmod +x edtgetrepos

edtsetevalunit: $(srcdir)/edtsetevalunit.sh
	cp $(srcdir)/edtsetevalunit.sh edtsetevalunit
	chmod +x edtsetevalunit


edtnewcmd: $(srcdir)/edtnewcmd.sh
	cp $(srcdir)/edtnewcmd.sh edtnewcmd
	chmod +x edtnewcmd
