#from setuptools import setup, find_packages
from distutils.core import setup
from distutils.extension import Extension

# we'd better have Cython installed, or it's a no-go
try:
    from Cython.Distutils import build_ext
except:
    print "You don't seem to have Cython installed. Please get a"
    print "copy from www.cython.org and install it"
    sys.exit(1)

pyfuncview = Extension("pyfuncview", ["pyfuncview.pyx"], extra_compile_args = ["-O3", "-Wall"], include_dirs = ['.'])

extensions = [pyfuncview]

# finally, we can pass all this to distutils
setup(
    name="pyfuncview",
    #packages=find_packages(),
    ext_modules=extensions,
    cmdclass = {'build_ext': build_ext},
)
