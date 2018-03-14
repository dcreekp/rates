# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

name = 'rates3'
description = (
    'exchange rates'
)
version = '0.0.0'


setup(
    name=name,
    version=version,
    description=description,
    author='',
    author_email='',
    packages=find_packages(),
    namespace_packages=name.split('.')[:-1],
    include_package_data=True,
    zip_safe=False,
    platforms='any',
    install_requires=[
        'morepath'
    ],
    extras_require=dict(
        test=[
            'pytest',
            'webtest',
            'werkzeug',
            'selenium'
        ],
    ),
    entry_points=dict(
        console_scripts=[
            'run-app = rates3.run:run',
        ],
    ),
    classifiers=[
        'Intended Audience :: Developers',
        'Environment :: Web Environment',
        'Topic :: Internet :: WWW/HTTP :: WSGI',
        'Programming Language :: Python :: 3.5',
    ]
)
