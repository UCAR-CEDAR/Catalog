
# Build the new idl client.

AUTOMAKE_OPTIONS = foreign check-news
ACLOCAL_AMFLAGS = -I conf

bin_PROGRAMS = cedarinventory

cedarinventory_SOURCES = cedarinventory.cc
cedarinventory_CPPFLAGS = $(CEDARPP_INC)
cedarinventory_LDFLAGS = $(CEDARPP_LIB)

EXTRA_DIST = 

CLEANFILES = *~ *.sum *.log

###########################################################################

# Build linux RPMs

srpm:
	rpmbuild -ts idl-client-@PACKAGE_VERSION@.tar.gz

rpm:
	rpmbuild -tb idl-client-@PACKAGE_VERSION@.tar.gz
