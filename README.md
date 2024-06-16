# code-server-dev
setting up code-server, enabling security on code server

One of the important step after installing code server is to enable ssl.

I found a very good article on enabling https on code server.

In General we get following error on code server:

[Enable https security on Code-Server](https://medium.com/@elysiumceleste/setting-up-a-secure-self-signed-ssl-certificate-for-code-server-on-ios-13-and-macos-10-15-294a1437cc4c)


Step 2: Step 2: Generate the RSA Private Key and Certificate
```
openssl req -x509 -nodes -days 825 -newkey rsa:2048 -keyout sricodeserver.key -out sricodeserver.crt -config openssl.cnf -extensions v3_ca
```
