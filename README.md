[Apache NetBeans][netbeans] is an integrated development environment (IDE) for Java, with extensions for other languages like PHP, JavaScript, HTML5, Groovy, C, and C++. Applications based on NetBeans, including the NetBeans IDE, can be extended by third party developers.

This package provides NetBeans for Linux and uses the [OpenJDK Snap package][openjdk], if installed, when the `JAVA_HOME` environment variable is not set. Building this package downloads the NetBeans source code directly from the [Apache Web site][source], verifies its SHA-512 hash value, and builds NetBeans from source using the Ubuntu Ant package.

Java and OpenJDK are trademarks or registered trademarks of Oracle and/or its affiliates.

[netbeans]: https://netbeans.apache.org/
[openjdk]: https://snapcraft.io/openjdk
[source]: https://downloads.apache.org/netbeans/netbeans/
