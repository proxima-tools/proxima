package be.uantwerpen.msd.icm.sympy.tests

class Scripts {
	public static val script1='''
		import sys
		sys.path.append('c:\\Program Files (x86)\\Python\\Python35-32\\Lib')
		from __future__ import division
		from sympy import *
		t, p, m, b = symbols('t p m b')
		eq1 = Ge(t, p+m+b)
		eq2 = Lt(t, 150)
		
		eq1 = eq1.subs([(b, 10), (m, 50)])
		print(solve([eq1, eq2], t))
	'''
	
	public static val script1b='''
		eq1 = eq1.subs([(p, 80)])
		print(solve([eq1, eq2], t))
	'''
	
	public static val script2='''
		from __future__ import division
		from sympy import *
		a, b = symbols('a b')
	'''
	
	public static val script3='''
		import sys
		print(sys.path)
«««		sys.path.append('c:\\Program Files (x86)\\Python\\Python35-32\\Lib')
«««		print(sys.path)
«««		import sympy
	'''
}