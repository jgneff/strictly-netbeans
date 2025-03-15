![Strictly NetBeans: Apache NetBeans® in a strictly-confined snap](images/banner.svg)

[Apache NetBeans](https://netbeans.apache.org) is an integrated development environment (IDE) for Java, with extensions for PHP, C, C++, HTML5, JavaScript, and other languages. This project builds [Snap packages](https://snapcraft.io/strictly-netbeans) of NetBeans directly from its [source repository](https://github.com/apache/netbeans) on GitHub. These packages are strictly confined, running in complete isolation with only limited access to your system. See the **Install** and **Usage** sections below for details.

The table below provides a summary of the support for Git version control and the Apache Ant, Apache Maven, and Gradle build tools in this strictly-confined environment:

| Tool   | Support | Comment |
| ------ |:-------:| ------- |
| Git    | ✓ | Works, but uses only the local Git repository configuration file. See notes below. |
| Ant    | ✓ | Works as expected. |
| Maven  | ✓ | Works, but uses alternative locations for the Maven user settings file and local repository directory. See notes below. |
| Gradle | 🗙 | Does not work. |

If you require the full use of Git or Gradle from within NetBeans, you'll need to download and install the unconfined [official release](https://netbeans.apache.org/download/) instead of the Strictly NetBeans Snap package. If, like me, you prefer to run Git in the Terminal outside of NetBeans and use only the Apache Ant and Apache Maven build tools, you should be able to use Strictly NetBeans for your software development. See the **Usage** section below for important instructions on how to avoid problems.

## See also

This project is one of four that I created to gain control of my development environment:

* [OpenJDK](https://github.com/jgneff/openjdk) - Current JDK release and early-access builds

    [![openjdk](https://snapcraft.io/openjdk/badge.svg)](https://snapcraft.io/openjdk)

* [OpenJFX](https://github.com/jgneff/openjfx) - Current JavaFX release and early-access builds

    [![openjfx](https://snapcraft.io/openjfx/badge.svg)](https://snapcraft.io/openjfx)

* [Strictly Maven](https://github.com/jgneff/strictly-maven) - Apache Maven™ in a strictly-confined snap

    [![strictly-maven](https://snapcraft.io/strictly-maven/badge.svg)](https://snapcraft.io/strictly-maven)

* [Strictly NetBeans](https://github.com/jgneff/strictly-netbeans) - Apache NetBeans® in a strictly-confined snap

    [![strictly-netbeans](https://snapcraft.io/strictly-netbeans/badge.svg)](https://snapcraft.io/strictly-netbeans)

## Install

Install the Strictly NetBeans Snap package with the command:

```console
$ sudo snap install strictly-netbeans
```

The Snap package is [strictly confined](https://snapcraft.io/docs/snap-confinement) and adds only the following interfaces to its permissions:

* the [desktop interfaces](https://snapcraft.io/docs/gnome-3-28-extension) to run as a graphical desktop application,
* the [home interface](https://snapcraft.io/docs/home-interface) to read and write files under your home directory,
* the [network interface](https://snapcraft.io/docs/network-interface) to download NetBeans plugins and Maven artifacts,
* the [network-bind interface](https://snapcraft.io/docs/network-bind-interface) to listen on local server sockets,
* the [network-status interface](https://snapcraft.io/docs/network-status-interface) to determine the connectivity status of the network, and
* the optional [mount-observe interface](https://snapcraft.io/docs/mount-observe-interface) to enable Git support for the project repository.

If you also install the [OpenJDK Snap package](https://snapcraft.io/openjdk), the Strictly NetBeans Snap package will connect to it automatically for its Java Development Kit (JDK). You can install the OpenJDK Snap package with the command:

```console
$ sudo snap install openjdk
```

After both packages are installed, you'll see the following interface among their list of connections:

```console
$ snap connections strictly-netbeans
Interface             Plug                           Slot                 Notes
content[jdk-24-1804]  strictly-netbeans:jdk-24-1804  openjdk:jdk-24-1804  -
```

You can also connect them manually with the command:

```console
$ sudo snap connect strictly-netbeans:jdk-24-1804 openjdk:jdk-24-1804
```

You can use a different JDK by disconnecting the OpenJDK Snap package and setting the `JAVA_HOME` environment variable. Because the Strictly NetBeans Snap package is strictly confined, the JDK must be located under a non-hidden folder of your home directory. For example:

```console
$ sudo snap disconnect strictly-netbeans:jdk-24-1804
$ export JAVA_HOME=$HOME/opt/jdk-24
$ strictly-netbeans
```

## Trust

The steps in building the packages are open and transparent so that you can gain trust in the process that creates them instead of having to put all of your trust in their publisher.

Each step of the build process is documented below:

* [Build File](snap/snapcraft.yaml) - the Snapcraft build file that creates the package
* [Source Code](https://github.com/apache/netbeans/branches) - the release branches used to obtain the NetBeans source code
* [Snap Package](https://launchpad.net/~jgneff/+snap/strictly-netbeans) - information about the package and its latest builds on Launchpad
* [Store Listing](https://snapcraft.io/strictly-netbeans) - the listing for the package in the Snap Store

The [Launchpad build farm](https://launchpad.net/builders) runs each build in a transient container created from trusted images to ensure a clean and isolated build environment. Snap packages built on Launchpad include a manifest that lets you verify the build and identify its dependencies.

## Verify

Each Strictly NetBeans package provides a software bill of materials (SBOM) and a link to its build log. This information is contained in a file called `manifest.yaml` in the directory `/snap/strictly-netbeans/current/snap`. The `image-info` section of the manifest provides a link to the package's page on Launchpad with its build status, including the complete log file from the container that ran the build. You can use this information to verify that the Strictly NetBeans Snap package installed on your system was built from source on Launchpad using only the software in [Ubuntu 24.04 LTS](https://cloud-images.ubuntu.com/noble/current/).

For example, I'll demonstrate how I verify the Strictly NetBeans Snap package installed on my system at the time of this writing. The `snap info` command shows that I installed Strictly NetBeans version 25 with revision 65:

```console
$ snap info strictly-netbeans
...
channels:
  latest/stable:    25 2025-02-22 (62) 695MB -
  latest/candidate: 25 2025-03-15 (65) 695MB -
  latest/beta:      ↑
  latest/edge:      ↑
installed:          25            (65) 695MB -
```

The following command prints the build information from the manifest file:

```console
$ grep -A3 image-info /snap/strictly-netbeans/current/snap/manifest.yaml
image-info:
  build-request-id: lp-96609099
  build-request-timestamp: '2025-03-07T15:14:58Z'
  build_url: https://launchpad.net/~jgneff/+snap/strictly-netbeans/+build/2746062
```

The `build_url` in the manifest is a link to the [page on Launchpad](https://launchpad.net/~jgneff/+snap/strictly-netbeans/+build/2746062) with the package's **Build status** and **Store status**. The store status shows that Launchpad uploaded revision 65 to the Snap Store, which matches the revision installed on my system. The build status shows a link to the log file with the label [buildlog](https://launchpad.net/~jgneff/+snap/strictly-netbeans/+build/2746062/+files/buildlog_snap_ubuntu_noble_amd64_strictly-netbeans_BUILDING.txt.gz).

The end of the log file contains a line with the SHA512 checksum of the package just built:

```
Creating snap package...
Packed strictly-netbeans_25_amd64.snap
3c483eeb690956a0fdfd528e6116d5b6a70aae0425964fa7d514e1d9a21ea8c483d44af067df9e4cf1eb8d7089cab79128385a7f7f136015942f5fdcc7bdaf2e  strictly-netbeans_25_amd64.snap
Revoking proxy token...
```

The command below prints the checksum of the package installed on my system:

```console
$ sudo sha512sum /var/lib/snapd/snaps/strictly-netbeans_65.snap
3c483eeb690956a0fdfd528e6116d5b6a70aae0425964fa7d514e1d9a21ea8c483d44af067df9e4cf1eb8d7089cab79128385a7f7f136015942f5fdcc7bdaf2e  /var/lib/snapd/snaps/strictly-netbeans_65.snap
```

The two checksum strings are identical. Using this procedure, I verified that the Strictly NetBeans Snap package installed on my system and the Strictly NetBeans Snap package built and uploaded to the Snap Store by Launchpad are in fact the exact same package. For more information, see [Launchpad Bug #1979844](https://bugs.launchpad.net/launchpad/+bug/1979844), "Allow verifying that a snap recipe build corresponds to a store revision."

## Usage

First, verify that the Strictly NetBeans Snap package is working and connected to the OpenJDK Snap package by starting it from the command line:

```console
$ strictly-netbeans
WARNING: package com.apple.eio not in java.desktop
WARNING: package com.sun.java.swing.plaf.windows not in java.desktop
WARNING: package com.apple.laf not in java.desktop
WARNING: A terminally deprecated method in sun.misc.Unsafe has been called
WARNING: sun.misc.Unsafe::objectFieldOffset has been called by com.google.common.util.concurrent.AbstractFuture$UnsafeAtomicHelper (jar:file:/snap/strictly-netbeans/x4/netbeans/java/maven/lib/guava-33.2.1-jre.jar!/)
WARNING: Please consider reporting this to the maintainers of class com.google.common.util.concurrent.AbstractFuture$UnsafeAtomicHelper
WARNING: sun.misc.Unsafe::objectFieldOffset will be removed in a future release
```

You should be presented with the Apache NetBeans window. If instead you see the error message printed below, make sure that the OpenJDK Snap package is installed and connected as described previously in the **Install** section.

```console
$ strictly-netbeans
Cannot find java. Please use the --jdkhome switch.
```

The Snap package does not have access to hidden files or folders in your home directory, so it uses the following alternative locations for the NetBeans user settings and user cache directories:

| Apache NetBeans Default | Strictly NetBeans Alternative |
|-------------------------|-------------------------------|
| `~/.netbeans`           | `~/snap/strictly-netbeans/current` |
| `~/.cache/netbeans`     | `~/snap/strictly-netbeans/common`  |

### Git version control

You need to make two changes for Git to work:

1. Move the user-specific "global" configuration file to its secondary location.
2. Enable the permission to "Read system mount information and disk quotas."

You can make both changes with the following two commands:

```console
$ mv ~/.gitconfig ~/.config/git/config
$ sudo snap connect strictly-netbeans:mount-observe
```

These changes are explained in detail below.

#### Move global configuration to secondary location

The Strictly NetBeans Snap package has no access to the primary user-specific "global" configuration file `~/.gitconfig`. As a result, you may see error messages like the following when you first open a project that is also a Git repository:

```
java.io.FileNotFoundException: /home/john/.gitconfig (Permission denied)
```

NetBeans fails to recover from the error, essentially disabling all of its Git support. There could be a way to make NetBeans use an alternative location for the file, but its [Eclipse JGit](https://github.com/eclipse-jgit/jgit) library does [not yet support](https://github.com/eclipse-jgit/jgit/blob/master/org.eclipse.jgit/src/org/eclipse/jgit/util/SystemReader.java#L92) the environment variable `GIT_CONFIG_GLOBAL` that would make this possible.

There is, however, a small change you can make to avoid the error. The JGit library looks for the global configuration file only in its primary location. If you move the file to its secondary location, you will hide it from JGit while still being able to use it for normal Git commands outside of NetBeans:

```console
$ mv ~/.gitconfig ~/.config/git/config
```

This change lets JGit avoid the error and continue to load the local repository-specific configuration file `.git/config` in the project's directory. You won't be able to perform Git operations in NetBeans that require values of variables from the global configuration, such as `user.name` and `user.email`, but you'll still be able to see the Git history along with any changes in the editor since the last commit. For everything else, I simply run the Git commands in the Terminal outside of NetBeans.

#### Add permission to read system mount information

After moving the global configuration file to its secondary location, you'll then encounter the following error:

```
java.io.IOException: Mount point not found
```

To avoid this error, connect the optional `mount-observe` plug to its core slot with the following command:

```
$ sudo snap connect strictly-netbeans:mount-observe
```

Alternatively, you can enable the permission to "Read system mount information and disk quotas" for the Strictly NetBeans app in your system settings.

This permission lets the JGit library determine whether the repository's file system is writable. A writable file system lets JGit measure the timestamp resolution and avoid the [racy Git](https://git-scm.com/docs/racy-git) problem. JGit saves this information in its configuration file, shown in the example below:

```console
$ cat ~/snap/strictly-netbeans/current/.config/jgit/config
[filesystem "Snap Build|24|/dev/mapper/sda1_crypt"]
    timestampResolution = 4344 nanoseconds
    minRacyThreshold = 1331 microseconds
```

### Ant build tool

Projects using Apache Ant still work in this strictly-confined environment.

### Maven build tool

Projects using Apache Maven still work in this strictly-confined environment. Note that the Maven user settings file and local repository directory are found in the alternative locations shown below:

| Apache NetBeans Default | Strictly NetBeans Alternative |
|-------------------------|-------------------------------|
| `~/.m2/settings.xml`    | `~/snap/strictly-netbeans/common/settings.xml` |
| `~/.m2/repository`      | `~/snap/strictly-netbeans/common/repository`   |

If the [Strictly Maven Snap package](https://snapcraft.io/strictly-maven) is also installed, the Strictly NetBeans Snap package connects to it automatically. You can install it with the command:

```console
$ sudo snap install strictly-maven
```

To use Strictly Maven instead of the Maven release bundled with NetBeans, select "Browse..." under Tools > Options > Java > Maven > Execution > Maven Home to open the dialog "Select Maven Installation Location," and then open the directory:

```
/snap/strictly-netbeans/current/maven
```

**Note:** Before building any Maven projects, add the option `--strict-checksums` under Tools > Options > Java > Maven > Execution > Global Execution Options. It's best to have Maven fail the build when a downloaded artifact does not match its checksum, yet that is [not the default](https://issues.apache.org/jira/browse/MNG-5728) in the current release.

### Gradle build tool

Projects using Gradle do not work in this strictly-confined environment. The Gradle support in NetBeans fails to build or even create a Gradle project when it is denied access to the `~/.gradle` hidden folder in the user's home directory.

Note that Gradle tries to create the hidden folder even when its user home is set to an alternative location. For example, after setting the Gradle User Home to `~/snap/strictly-netbeans/common/gradle` in the panel under Tools > Options > Java > Gradle > Execution, Gradle still tries to create the default `~/.gradle` directory and fails to recover after being denied permission.

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
