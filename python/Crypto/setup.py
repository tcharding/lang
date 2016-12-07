try:
    from setuptools import setup
except ImportError:
    from distutils.cor import setup

config = {
    'name': 'Crypto'
    'description': 'the matasano crypto challenges'
    'author': 'Tobin Harding',
    'author_email': 'me@tobin.cc',
    'version': '0.1',
    'install_requires': ['nose'],
    'packages':['Crypt']
    'scripts': [main.py]
}
#    'py_modules': ['']

setup(**config)
