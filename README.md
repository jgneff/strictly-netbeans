## Summary

[Apache NetBeans](https://netbeans.apache.org) is an integrated development environment (IDE) for Java, with extensions for PHP, C, C++, HTML5, JavaScript, and other languages. Applications based on NetBeans, including the NetBeans IDE, can be extended by third-party developers.

This repository creates the [Strictly NetBeans Snap package](https://snapcraft.io/strictly-netbeans), which provides the latest release of NetBeans built directly from its [source code](https://github.com/apache/netbeans) on GitHub. If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, this package connects to it automatically for the location of its Java Development Kit runtime and tools.

This Snap package is **strictly confined**, running in complete isolation with only limited access to your system resources. This project is an experiment to determine whether NetBeans can run in a restricted environment. Please install this Snap package only if you're interested in such a test. Otherwise, refer to the official [Apache NetBeans Snap package](https://snapcraft.io/netbeans).

## Motivation

It's getting more and more difficult for Linux distributions to keep up with every new release of the various developer tools. As a result, their package repositories are getting more and more [out of date](https://packages.ubuntu.com/search?keywords=netbeans&searchon=names&exact=1).

One alternative is to get these tools directly from their upstream projects. Yet that often involves a tedious series of tasks, such as tracking the updates, downloading each new release, trusting the build infrastructure, verifying the checksum and signatures, unpacking the archive, and setting up the environment variables.

I wanted a release of NetBeans that was:

* built directly from source, identified strictly by its Git release tag or branch,
* built transparently, using transient containers created from trusted images,
* downloaded, verified, and installed automatically with each update,
* confined strictly, having limited access to my development workstation, and
* configured to strictly verify the checksum of each artifact that it downloads.

The Strictly NetBeans Snap package created by this repository does just that. It's actually easier for me to keep this Snap package up to date than it is to track, download, trust, verify, unpack, and set up each new release from Apache.

## Description

### Trusting

The steps in building the packages are open and transparent so that you can gain trust in the process that creates them instead of having to put all of your trust in their publisher. Below is a link to each step of the build process:

* [Snap Source](snap/snapcraft.yaml) - build file used to create the Snap package
* [NetBeans Source](https://github.com/apache/netbeans/branches) - release branches used to obtain the NetBeans source code
* [Snap Package](https://launchpad.net/~jgneff/+snap/strictly-netbeans) - information about the package and its latest builds
* [Snap Listing](https://snapcraft.io/strictly-netbeans) - listing for the package in the Snap Store

The [Launchpad build farm](https://launchpad.net/builders) runs each build in a transient container created from trusted images to ensure a clean and isolated build environment. It's the same build farm that creates the Debian packages installed on my Ubuntu system, so I'm already trusting its build infrastructure by running Ubuntu. Snap packages built on Launchpad include a manifest file, called `manifest.yaml`, that lets you verify the build and identify its dependencies.

### Installing

Install the Strictly NetBeans Snap package with the command:

```console
$ sudo snap install strictly-netbeans
```

The Snap package is [strictly confined](https://snapcraft.io/docs/snap-confinement) and adds the following interfaces to its permissions:

* the [desktop interfaces](https://snapcraft.io/docs/gnome-3-34-extension) to run as a graphical desktop application,
* the [home interface](https://snapcraft.io/docs/home-interface) to read and write files under your home directory,
* the [network interface](https://snapcraft.io/docs/network-interface) to download NetBeans plugins and Maven artifacts, and
* the [network-bind interface](https://snapcraft.io/docs/network-bind-interface) to listen on local server sockets.

If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, the Strictly NetBeans Snap package connects to it automatically for its JDK runtime and tools. You can connect them manually with the command:

```console
$ sudo snap connect strictly-netbeans:jdk-18-1804 openjdk
```

Once installed and connected, you'll see the JDK listed among its interfaces:

```console
$ snap connections strictly-netbeans
Interface             Plug                           Slot                 Notes
    ...
content[jdk-18-1804]  strictly-netbeans:jdk-18-1804  openjdk:jdk-18-1804  -
    ...
```

You may use a different Java Development Kit by setting the `JAVA_HOME` environment variable, but because the Strictly NetBeans Snap package is strictly confined, the JDK must be located in a non-hidden folder of your home directory.

### Running

First, verify that the Strictly NetBeans Snap package is working and connected to the OpenJDK Snap package by starting it from the command line:

```console
$ strictly-netbeans
WARNING: package com.apple.eio not in java.desktop
WARNING: A terminally deprecated method in java.lang.System has been called
WARNING: System::setSecurityManager has been called by
    org.netbeans.TopSecurityManager
    (file:/snap/strictly-netbeans/2/netbeans/platform/lib/boot.jar)
WARNING: Please consider reporting this to the maintainers of
    org.netbeans.TopSecurityManager
WARNING: System::setSecurityManager will be removed in a future release
```

You should be presented with the Apache NetBeans window. If you see the following error message instead of the warnings above, make sure the Strictly NetBeans Snap package is connected to the OpenJDK Snap package as describe earlier under *Installing*.

```console
$ strictly-netbeans
Cannot find java. Please use the --jdkhome switch.
```

For Apache Maven to work, add the following two options under Tools > Options > Java > Maven > Execution > Global Execution Options:

```
--strict-checksums
--settings /home/USER/snap/strictly-netbeans/common/maven/settings.xml
```

where `USER` is your actual user name on the system.

### Building

You can build the Snap package on Linux by installing [Snapcraft](https://snapcraft.io/snapcraft) on your development workstation. Run the following commands to install Snapcraft, clone this repository, and start building the package:

```console
$ sudo snap install snapcraft
$ git clone https://github.com/jgneff/strictly-netbeans.git
$ cd strictly-netbeans
$ snapcraft
```

To run the build remotely on Launchpad, enter the command:

```console
$ snapcraft remote-build
```

See the [Snapcraft Overview](https://snapcraft.io/docs/snapcraft-overview) page for more information on building Snap packages.

## License

This project is licensed under the Apache License 2.0, the same license used by the Apache NetBeans project. Apache NetBeans and the NetBeans logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.
