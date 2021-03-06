#!/bin/bash
# ----------------------------------------------------------------------
# Numenta Platform for Intelligent Computing (NuPIC)
# Copyright (C) 2013, Numenta, Inc.  Unless you have an agreement
# with Numenta, Inc., for a separate license for this software code, the
# following terms and conditions apply:
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# http://numenta.org/licenses/
# ----------------------------------------------------------------------

echo
echo Running after_success-release.sh...
echo

echo Updating python modules for wheel...
sudo pip install -U "pip==1.5.6" "setuptools>=0.9" "wheel>=0.21" || exit

echo Installing twine...
sudo pip install twine || exit

# Creates wheel in dist/nupic-0.0.X-py2-none-any.whl
python setup.py bdist_wheel || exit

generic_filename=`ls dist/*.whl`
# Change the name of the wheel based on our platform if on OS X...
if [ "${TRAVIS_OS_NAME}" = "osx" ]; then
    platform=`python -c "import distutils.util; print distutils.util.get_platform()"` || exit
    new_filename=$(echo $generic_filename | sed -e "s/none/${platform}/")
    mv $generic_filename $new_filename
else
    new_filename=generic_filename
fi

twine upload "$new_filename" -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
