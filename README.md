[Apache NetBeans](https://netbeans.apache.org) is an integrated development environment (IDE) for Java, with extensions for PHP, C, C++, HTML5, JavaScript, and other languages. Applications based on NetBeans, including the NetBeans IDE, can be extended by third-party developers.

This repository creates the [Strictly NetBeans Snap package](https://snapcraft.io/strictly-netbeans), which provides the latest release of NetBeans built directly from its [source code](https://github.com/apache/netbeans) on GitHub. If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, this package connects to it during installation for the location of its Java Development Kit runtime and tools.

**Note:** This Snap package is strictly confined, running in complete isolation with only limited access to your system resources. It's an experiment to see what problems occur when running NetBeans in a restricted environment. If you're not interested in participating in the experiment, please install the official [Apache NetBeans Snap package](https://snapcraft.io/netbeans) instead.

## Motivation

It's getting more and more difficult for Linux distributions to keep up with every new release of the various developer tools. As a result, their package repositories are getting more and more [out of date](https://packages.ubuntu.com/search?keywords=netbeans&searchon=names&exact=1).

One alternative is to get these tools directly from their upstream projects. Yet that involves tracking the updates, downloading each new release, trusting the build infrastructure, verifying the checksum and signatures, unpacking the archive, and setting up environment variables.

I wanted a release of NetBeans with the following attributes:

* built directly from source, identified by a branch or tag on GitHub,
* built transparently, using transient containers created from trusted images,
* downloaded, verified, and installed automatically with each update, and
* confined strictly, having limited access to my development workstation.

The Strictly NetBeans Snap package built by this repository is an experiment in doing just that. It's actually easier for me to keep this Snap package up to date than it is to track, download, trust, verify, unpack, and set up each new release from Apache.

## Trust

The steps in building the packages are open and transparent so that you can gain trust in the process that creates them instead of having to put all of your trust in their publisher. Below is a link to each step of the build process:

* [Snap Source](snap/snapcraft.yaml) - build file used to create the Snap package
* [NetBeans Source](https://github.com/apache/netbeans/branches) - release branches used to obtain the NetBeans source code
* [Snap Package](https://launchpad.net/~jgneff/+snap/strictly-netbeans) - information about the package and its latest builds

The [Launchpad build farm](https://launchpad.net/builders) runs each build in a transient container created from trusted images to ensure a clean and isolated build environment. Snap packages built on Launchpad include a manifest file, called `manifest.yaml`, that lets you verify the build and identify its dependencies.

## Installing

Install the Strictly NetBeans Snap package with the command:

```console
$ sudo snap install strictly-netbeans
```

The Snap package is [strictly confined](https://snapcraft.io/docs/snap-confinement) and adds the following interfaces to its permissions:

* the [desktop interfaces](https://snapcraft.io/docs/gnome-3-34-extension) for access to the desktop and the GNOME platform and themes,
* the [home interface](https://snapcraft.io/docs/home-interface) to be able to read and write files under your home directory,
* the [network interface](https://snapcraft.io/docs/network-interface) to be able to download NetBeans plugins and Maven artifacts, and
* the [network-bind interface](https://snapcraft.io/docs/network-bind-interface) to be able listen on local server sockets.

If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is already installed, the Strictly NetBeans Snap package connects to it automatically for its JDK runtime and tools. Otherwise, you can connect them manually with the command:

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

## Running

First, verify that the Strictly NetBeans Snap package is working and connected to the OpenJDK Snap package by running it from the command line:

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

You should be presented with the Apache NetBeans window. If you see the following error message, make sure the Strictly NetBeans Snap package is connected to the OpenJDK Snap package as describe above under *Installing*.

```console
$ strictly-netbeans
Cannot find java. Please use the --jdkhome switch.
```

For Maven to work, add the following two options under Tools > Options > Java > Maven > Execution > Global Execution Options:

```
--strict-checksums
--settings /home/USER/snap/strictly-netbeans/common/maven/settings.xml
```

where `USER` is your actual user name on the system.

## Building

You can build the Snap package on Linux by installing [Snapcraft](https://snapcraft.io/snapcraft) on your development workstation. Run the following commands to install Snapcraft, clone this repository, and start building the package:

```console
$ sudo snap install snapcraft
$ git clone https://github.com/jgneff/strictly-netbeans.git
$ cd strictly-netbeans
$ snapcraft
```
See the [Snapcraft Overview](https://snapcraft.io/docs/snapcraft-overview) page for more information on building Snap packages.

## License

This project is licensed under the Apache License 2.0, the same license used by the Apache NetBeans project. Apache NetBeans and the NetBeans logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.
