from setuptools import setup, find_packages
#from distutils.core import setup
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
    ext_modules=extensions,
    py_modules = ['__init__']
    cmdclass = {'build_ext': build_ext},
    version='1.0',
    description='Frame for mixed use of C, Cython and Python (based on ctypes)',
    author='Alexander Mikhalev',
    author_email='muxasizhevsk@gmail.com',
    url='https://github.com/Muxas/pyfuncview',
)
