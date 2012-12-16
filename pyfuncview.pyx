import ctypes as ct

cdef class pyfuncview:
    cdef object c_func, py_func, cfunctype, pyfunctype
    cdef long long c_ptr
    def __init__(self, func, restype, *argtypes):
        self.cfunctype = ct.CFUNCTYPE(restype, *argtypes)
        self.pyfunctype = ct.PYFUNCTYPE(restype, *argtypes)
        if type(func) is long or type(func) is int:
            #print 'got C-func pointer'
            self.py_func = self.pyfunctype(func)
            self.c_ptr = <long long>func
            self.c_func = self.cfunctype(func)
        elif callable(func):
            #print 'got Py-func'
            self.py_func = func
            self.c_func = self.cfunctype(func)
            self.c_ptr = <long>ct.cast(self.c_func, ct.c_void_p).value
        #print self.c_func, self.py_func, self.cfunctype, self.c_ptr
        else:
            self.py_func = None
            self.c_func = None
            self.c_ptr = 0
    def __call__(self, *args):
        if self.py_func is None and self.c_func is None and self.c_ptr == 0:
                print "no function set for this pyfuncview object"
                return
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

def __c_run__(long long func_addr, x, i):
    return (<int (*)(object, int)>func_addr)(x, i)
    
cdef int __c_func__(object x, int i):
    return x[i]

def __c_func_addr__(x):
    if x == 'long long':
        return <long long>&__c_func__
    else:
        return <long>&__c_func__

def __py_func__(x, i):
    return x[i]

def __test__():
    func0 = pyfuncview(__c_func_addr__('long long'), ct.c_int, ct.py_object, ct.c_int)
    func1 = pyfuncview(__c_func_addr__('long'), ct.c_int, ct.py_object, ct.c_int)
    func2 = pyfuncview(__py_func__, ct.c_int, ct.py_object, ct.c_int)
    data = [11,22,33,44,55,66]
    i = 4
    print func0.py_func, func0.c_func, 
    print func0.c_ptr, __c_func_addr__('long long')
    print func1.py_func, func1.c_func, 
    print func1.c_ptr, __c_func_addr__('long')
    print 'Python calls:'
    print data[i], func0(data, i), func1(data, i), func2(data, i)
    print 'C calls:'
    print __c_func__(data, i), __c_run__(func0.c_ptr, data, i), __c_run__(func1.c_ptr, data, i), __c_run__(func2.c_ptr, data, i)
