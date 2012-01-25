# Dependencies #

* brunch (0.9-beta1)
* PGT (Android Version) ([github https://github.com/SuperSkunk/PGT/]

# Installation #

## Android ##
Modify the android/local.properties file.

## iOS ##

# Usage #

## Web version ##
Run <code>brunch watch</code> in the brunch folder.<br>

## Android version ##
Run <code>pgt debug</code> in the android folder.<br>

# Limitations #

You need to put the <strong>same structure</strong> in the brunch/.android, brunch/.ios and brunch/.web folders.<br>
There is <strong>no automatism</strong> to copy the brunch/.web in the vendor folder, you'll need to do it manually.

# Architecture #

<pre>
.
├── android # Android Application
│
├── ios iOS # Application
│
└── brunch # HTML5 Application
    │
    ├── .android  # Android Javascript Specific Files
    │   └── vendor
    │       ├── scripts
    │       └── styles
    │
    ├── .ios # iOS Javascript Specific Files
    │   └── vendor
    │       ├── scripts
    │       └── styles
    │
    ├── .web # Web Javascript Specific Files
    │   └── vendor
    │       ├── scripts
    │       └── styles
    │
    ├── android # Android HTML5 Application
    │
    ├── ios iOS # HTML5 Application
    │
    ├── build # Web HTML5 Application
    │
    ├── app
    │   ├── assets # will be copied to build automatically (see brunch AssetsPlugin)
    │   │   └── images
    │   │       index.html
    │   │
    │   ├── collections
    │   ├── controllers
    │   ├── helpers
    │   ├── models
    │   ├── routers
    │   ├── styles
    │   ├── templates
    │   └── views
    │
    └── vendor
</pre>