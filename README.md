pyfuncview
==========

A simple ctypes-based tool to call C functions from Python and Python functions from C  
(for mixed usage of C and Python)

============
INSTALLATION
============

1. You can build package in place with command

```bash
python setup.py build_ext --inplace
```
that will generate `pyfuncview.so` in `pyfuncview` folder, that can easily be imported in python.

2. Another way to install package is to install it into system with command

```bash
python setup.py build_ext install
```
=====
USAGE
=====

0. Module uses **ctypes**, so argument types (both input and output) need to be ctypes.c_*
1. How to get C-view for Python function:  
**Require:** `pyfunc` with return argument of type `typeres` and types of input arguments `typeargs`  
**Ensure:** get C-pointer to call function `pyfunc` from C-code

```python
from pyfuncview import pyfuncview as pfv
fview = pfv(pyfunc, typeres, typeargs)
c_pointer = fview.c_ptr
```
**EXAMPLE:**

```python
def pyfunc(data, i, j):
    return data[i,j]
#data - ctypes.py_object
#i, j - ctypes.c_int
#data[i,j] - ctypes.c_double

from pyfuncview import pyfuncview as pfv
import ctypes as ct
fview = pfv(pyfunc, ct.c_double, ct.py_object, ct.c_int, ct.c_int)
c_pointer = fview.c_ptr
```

2) How to get Python function based on pointer to C-function  
**Require:** `cfunc` pointer to a C-function with return argument of type `typeres`  
and types of input arguments `typeargs`  
**Ensure:** get Python-func that is able to call the required C-function


```python
from pyfuncview import pyfuncview as pfv
fview = pfv(pyfunc, typeres, typeargs)
```
`fview` can be called just as Python function with required parameters

**EXAMPLE:**

```python
# double cfunc(double *, int, int) passed as python variable of "int" type
from pyfuncview import pyfuncview as pfv
import ctypes as ct
fview = pfv(cfunc, ct.c_double, ct.pointer(ct.c_double), ct.c_int, ct.c_int)
#Got fview(data, i, j)
```
