config cas
==========

### tomcat ssl

### PKIX path
By default the Java system truststore is at $JAVA_HOME/jre/lib/security/cacerts. The certificate to be imported MUST be a DER-encoded file.
```
keytool -import -keystore $JAVA_HOME/jre/lib/security/cacerts -file tmp/cert.der -alias certName
```



