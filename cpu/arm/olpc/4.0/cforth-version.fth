\ This file controls which CForth source version to include in the OFW build
\ and the method for fetching it

\ If CFORTH_FETCH_METHOD is "tarball", the source code will be downloaded as a tarball from
\ the GitHub repository specified by CFORTH_REPO_URL at the commit specified by CFORTH_VERSION.
\ Note that this may not work for non-GitHub repositories.

\ If CFORTH_FETCH_METHOD is "clone", the source code will be cloned from the Git repository
\ specified by CFORTH_REPO_URL at the commit specified by CFORTH_VERSION

macro: CFORTH_FETCH_METHOD glone

macro: CFORTH_REPO_URL https://github.com/MitchBradley/cforth

macro: CFORTH_VERSION d111f9ffe1732b706addb08a96d4cba7e26bb93a

macro: CFORTH_BUILD_DIR cforth/build/arm-xo-cl4
