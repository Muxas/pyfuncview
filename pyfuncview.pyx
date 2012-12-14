import ctypes as ct

cdef class pyfuncview:
    cdef object c_func, py_func, cfunctype, pyfunctype
    cdef long c_ptr
    def __init__(self, func, restype, *argtypes):
        self.c_func = None
        self.py_func = None
        self.cfunctype = ct.CFUNCTYPE(restype, *argtypes)
        self.pyfunctype = ct.PYFUNCTYPE(restype, *argtypes)
        if type(func) == int:
            #print 'got C-func pointer'
            self.c_ptr = func
            self.c_func = self.pyfunctype(func)
        elif callable(func):
            #print 'got Py-func'
            self.py_func = func
            self.c_func = self.cfunctype(func)
            self.c_ptr = <long>ct.cast(self.c_func, ct.c_void_p).value
        #print self.c_func, self.py_func, self.cfunctype, self.c_ptr
    def __call__(self, *args):
        if self.py_func is None:
            if self.c_func is None:
                print "no function set for this func_ptr object"
                return
            #print args
            return self.c_func(*args)
        return self.py_func(*args)
    property c_ptr:
        def __get__(self):
            return self.c_ptr
    property c_func:
        def __get__(self):
            return self.c_func
    property py_func:
        def __get__(self):
            return self.py_func
