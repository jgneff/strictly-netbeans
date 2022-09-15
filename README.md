![Strictly NetBeans: Apache NetBeans® in a strictly-confined snap](images/banner.svg)

[Apache NetBeans](https://netbeans.apache.org) is an integrated development environment (IDE) for Java, with extensions for PHP, C, C++, HTML5, JavaScript, and other languages. This project builds [Snap packages](https://snapcraft.io/strictly-netbeans) of NetBeans directly from its [source repository](https://github.com/apache/netbeans) on GitHub. These packages are strictly confined, running in complete isolation with only limited access to your system. See the **Install** and **Usage** sections below for details.

## Install

Install the Strictly NetBeans Snap package with the command:

```console
$ sudo snap install strictly-netbeans
```

The Snap package is [strictly confined](https://snapcraft.io/docs/snap-confinement) and adds only the following interfaces to its permissions:

* the [desktop interfaces](https://snapcraft.io/docs/gnome-3-34-extension) to run as a graphical desktop application,
* the [home interface](https://snapcraft.io/docs/home-interface) to read and write files under your home directory,
* the [network interface](https://snapcraft.io/docs/network-interface) to download NetBeans plugins and Maven artifacts, and
* the [network-bind interface](https://snapcraft.io/docs/network-bind-interface) to listen on local server sockets.

If the [OpenJDK Snap package](https://snapcraft.io/openjdk) is also installed, the Strictly NetBeans Snap package connects to it automatically for its Java Development Kit (JDK):

```console
$ sudo snap install openjdk
```

Once both packages are installed, you'll see the following interface among the list of connections:

```console
$ snap connections strictly-netbeans
Interface             Plug                           Slot                 Notes
content[jdk-18-1804]  strictly-netbeans:jdk-18-1804  openjdk:jdk-18-1804  -
```

You can also connect them manually with the command:

```console
$ sudo snap connect strictly-netbeans:jdk-18-1804 openjdk
```

You can use a different JDK by disconnecting the OpenJDK Snap package and setting the `JAVA_HOME` environment variable. Because the Strictly NetBeans Snap package is strictly confined, the JDK must be located in a non-hidden folder of your home directory. For example:

```console
$ sudo snap disconnect strictly-netbeans:jdk-18-1804
$ export JAVA_HOME=$HOME/opt/jdk-20
$ strictly-netbeans
```

## Trust

The steps in building the packages are open and transparent so that you can gain trust in the process that creates them instead of having to put all of your trust in their publisher.

Each step of the build process is documented below:

* [Build File](snap/snapcraft.yaml) - the Snapcraft build file that creates the Snap package
* [Source Code](https://github.com/apache/netbeans/branches) - the release branches used to obtain the NetBeans source code
* [Snap Package](https://launchpad.net/~jgneff/+snap/strictly-netbeans) - information about the package and its latest builds on Launchpad
* [Snap Store](https://snapcraft.io/strictly-netbeans) - the listing for Strictly NetBeans in the Snap Store

The [Launchpad build farm](https://launchpad.net/builders) runs each build in a transient container created from trusted images to ensure a clean and isolated build environment. Snap packages built on Launchpad include a manifest that lets you verify the build and identify its dependencies.

## Verify

Each Strictly NetBeans package provides a software bill of materials (SBOM) and a link to its build log. This information is contained in a file called `manifest.yaml` in the directory `/snap/strictly-netbeans/current/snap`. The `image-info` section of the manifest provides a link to the package's page on Launchpad with its build status, including the complete log file from the container that ran the build. You can use this information to verify that the Strictly NetBeans Snap package installed on your system was built from source on Launchpad using only the software in [Ubuntu 18.04 LTS](https://cloud-images.ubuntu.com/bionic/current/).

For example, I'll demonstrate how I verify the Strictly NetBeans Snap package installed on my system at the time of this writing. The `snap info` command shows that I installed Strictly NetBeans version 15 with revision 10:

```console
$ snap info strictly-netbeans
...
channels:
  latest/stable:    15 2022-09-15 (10) 551MB -
  latest/candidate: ↑
  latest/beta:      ↑
  latest/edge:      ↑
installed:          15            (10) 551MB -
```

The following command prints the build information from the manifest file:

```console
$ grep -A3 image-info /snap/strictly-netbeans/current/snap/manifest.yaml
image-info:
  build-request-id: lp-73868090
  build-request-timestamp: '2022-09-06T19:00:24Z'
  build_url: https://launchpad.net/~jgneff/+snap/strictly-netbeans/+build/1872566
```

The `build_url` in the manifest is a link to the [page on Launchpad](https://launchpad.net/~jgneff/+snap/strictly-netbeans/+build/1872566) with the package's **Build status** and **Store status**. The store status shows that Launchpad uploaded revision 10 to the Snap Store, which matches the revision installed on my system. The build status shows a link to the log file with the label *buildlog*.

The end of the log file contains a line with the SHA512 checksum of the package just built, shown below with the checksum edited to fit on this page:

```
Snapping...
Snapped strictly-netbeans_15_multi.snap
727134069ab142f0...a6b6168a7394b768  strictly-netbeans_15_multi.snap
Revoking proxy token...
```

The command below prints the checksum of the package installed on my system:

```console
$ sudo sha512sum /var/lib/snapd/snaps/strictly-netbeans_10.snap
727134069ab142f0...a6b6168a7394b768  /var/lib/snapd/snaps/strictly-netbeans_10.snap
```

The two checksum strings are identical. Using this procedure, I verified that the Strictly NetBeans Snap package installed on my system and the Strictly NetBeans Snap package built and uploaded to the Snap Store by Launchpad are in fact the exact same package. For more information, see [Launchpad Bug #1979844](https://bugs.launchpad.net/launchpad/+bug/1979844), "Allow verifying that a snap recipe build corresponds to a store revision."

## Usage

First, verify that the Strictly NetBeans Snap package is working and connected to the OpenJDK Snap package by starting it from the command line:

```console
$ strictly-netbeans
WARNING: package com.apple.eio not in java.desktop
WARNING: A terminally deprecated method in java.lang.System has been called
WARNING: System::setSecurityManager has been called by org.netbeans.TopSecurityManager
  (file:/snap/strictly-netbeans/10/netbeans/platform/lib/boot.jar)
WARNING: Please consider reporting this to the maintainers of org.netbeans.TopSecurityManager
WARNING: System::setSecurityManager will be removed in a future release
```

You should be presented with the Apache NetBeans window. If you instead see the error message below, make sure that the OpenJDK Snap package is installed and connected as described earlier under the **Install** section:

```console
$ strictly-netbeans
Cannot find java. Please use the --jdkhome switch.
```

The Snap package does not have access to hidden files or folders in your home directory, so it uses the following alternative locations for the NetBeans user settings and user cache and for the Maven user settings and local repository:

| Apache NetBeans Default | Strictly NetBeans Alternative |
|-------------------------|-------------------------------|
| `~/.netbeans`           | `~/snap/strictly-netbeans/current` |
| `~/.cache/netbeans`     | `~/snap/strictly-netbeans/common`  |
| `~/.m2/settings.xml`    | `~/snap/strictly-netbeans/common/settings.xml` |
| `~/.m2/repository`      | `~/snap/strictly-netbeans/common/repository`   |

### A Note on Git

The Strictly NetBeans Snap package has no access to the system-wide Git configuration file `/etc/gitconfig` nor the user-specific "global" configuration files `~/.gitconfig` and `~/.config/git/config`. As a result, you might see error messages like the following when you first open a project that is also a Git repository:

```
java.io.FileNotFoundException: /home/john/.gitconfig (Permission denied)
```

There is a way to make NetBeans skip this file and still use the repository-specific configuration file `.git/config`. Unfortunately, the [Eclipse JGit](https://git.eclipse.org/c/jgit/jgit.git/tree/org.eclipse.jgit/src/org/eclipse/jgit/util/SystemReader.java#n74) library used by NetBeans does not yet support the new environment variables that make this possible. In the meanwhile, the Strictly NetBeans [startup script](bin/netbeans.sh) sets the variables so that at least some of the Git features can work once JGit adds the support.

The disadvantage for now is that NetBeans fails to display the changes in the editor since the last commit. On the other hand, for full Git support, NetBeans would require access to the system and global Git configuration files and also to your private keys for signing commits. Instead, I simply run all Git commands in the Terminal outside of NetBeans.

## Build

You can build the Snap package on Linux by installing [Snapcraft](https://snapcraft.io/snapcraft) on your development workstation. Run the following commands to install Snapcraft, clone this repository, and start building the package:

```console
$ sudo snap install snapcraft --classic
$ git clone https://github.com/jgneff/strictly-netbeans.git
$ cd strictly-netbeans
$ snapcraft
```

To run the build remotely on Launchpad, enter the command:

```console
$ snapcraft remote-build
```

See the [Snapcraft Overview](https://snapcraft.io/docs/snapcraft-overview) page for more information about building Snap packages.

## License

This project is licensed under the Apache License 2.0, the same license used by the Apache NetBeans project. See the [LICENSE](LICENSE) file for details. Apache NetBeans and the NetBeans logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.
