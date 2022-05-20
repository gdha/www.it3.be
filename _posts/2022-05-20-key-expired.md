---
layout: post
title: How to renew an expired key of Ubuntu repository

description: How to How to renew an expired key of Ubuntu repository

tags: [Open Source, Ubuntu, apt-key, it3 consultants, Release.key, expired]
author: gratien
---

<strong>How to renew an expired key of Ubuntu repository</strong>

On my Ubuntu 18 system we cannot update our ReaR snapshot software package anymore, becasue the release key has been expired:

```bash
$ sudo apt-key list | grep -A 1 expired
Warning: apt-key output should not be parsed (stdout is not a terminal)
pub   rsa2048 2020-01-17 [SC] [expired: 2022-03-27]
      318C 5FDA D663 3E09 8383  18D2 082C AA5E ADB2 E40A
uid        [ expired] Archiving:Backup:Rear:Snapshot OBS Project <Archiving:Backup:Rear:Snapshot@build.opensuse.org>
```

We could skip checking expired keys altogether, but that is a really bad idea by creating the following file:

```bash
$ sudo echo 'Acquire::Check-Valid-Until no;' > /etc/apt/apt.conf.d/99no-check-valid-until
```

However, the correct way to renew the expired key is by executing the following:

```bash
$ wget -q -O - https://download.opensuse.org/repositories/Archiving:/Backup:/Rear:/Snapshot/xUbuntu_18.04/Release.key | sudo apt-key add -
OK
```

Now, we can double check if the expired key has been renewed:

```bash
$ sudo apt-key list | grep -i ReaR
Warning: apt-key output should not be parsed (stdout is not a terminal)
uid        [ unknown] Archiving:Backup:Rear:Snapshot OBS Project <Archiving:Backup:Rear:Snapshot@build.opensuse.org>
```

If you have the `pgpdump` utility installed you can do the following neat thing to inspect the Release key of your distribution:

```bash
$ curl -L https://download.opensuse.org/repositories/Archiving:/Backup:/Rear:/Snapshot/xUbuntu_18.04/Release.key | pgpdump 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1145  100  1145    0     0   4543      0 --:--:-- --:--:-- --:--:--  4543
Old: Public Key Packet(tag 6)(269 bytes)
	Ver 4 - new
	Public key creation time - Fri Jan 17 12:21:38 CET 2020
	Pub alg - RSA Encrypt or Sign(pub 1)
	RSA n(2048 bits) - ...
	RSA e(17 bits) - ...
Old: User ID Packet(tag 13)(94 bytes)
	User ID - Archiving:Backup:Rear:Snapshot OBS Project <Archiving:Backup:Rear:Snapshot@build.opensuse.org>
Old: Signature Packet(tag 2)(318 bytes)
	Ver 4 - new
	Sig type - Positive certification of a User ID and Public Key packet(0x13).
	Pub alg - RSA Encrypt or Sign(pub 1)
	Hash alg - SHA256(hash 8)
	Hashed Sub: signature creation time(sub 2)(4 bytes)
		Time - Thu Mar 17 16:05:47 CET 2022
	Hashed Sub: key flags(sub 27)(1 bytes)
		Flag - This key may be used to certify other keys
		Flag - This key may be used to sign data
	Hashed Sub: key expiration time(sub 9)(4 bytes)
		Time - Sat May 25 17:05:47 CEST 2024
	Hashed Sub: preferred symmetric algorithms(sub 11)(5 bytes)
		Sym alg - AES with 256-bit key(sym 9)
		Sym alg - AES with 192-bit key(sym 8)
		Sym alg - AES with 128-bit key(sym 7)
		Sym alg - CAST5(sym 3)
		Sym alg - Triple-DES(sym 2)
	Hashed Sub: preferred hash algorithms(sub 21)(5 bytes)
		Hash alg - SHA256(hash 8)
		Hash alg - SHA1(hash 2)
		Hash alg - SHA384(hash 9)
		Hash alg - SHA512(hash 10)
		Hash alg - SHA224(hash 11)
	Hashed Sub: preferred compression algorithms(sub 22)(3 bytes)
		Comp alg - ZLIB <RFC1950>(comp 2)
		Comp alg - BZip2(comp 3)
		Comp alg - ZIP <RFC1951>(comp 1)
	Hashed Sub: features(sub 30)(1 bytes)
		Flag - Modification detection (packets 18 and 19)
	Hashed Sub: key server preferences(sub 23)(1 bytes)
		Flag - No-modify
	Sub: issuer key ID(sub 16)(8 bytes)
		Key ID - 0x082CAA5EADB2E40A
	Hash left 2 bytes - 62 2e 
	RSA m^d mod n(2048 bits) - ...
		-> PKCS-1
Old: Signature Packet(tag 2)(70 bytes)
	Ver 4 - new
	Sig type - Positive certification of a User ID and Public Key packet(0x13).
	Pub alg - DSA Digital Signature Algorithm(pub 17)
	Hash alg - SHA1(hash 2)
	Hashed Sub: signature creation time(sub 2)(4 bytes)
		Time - Fri Jan 17 12:21:39 CET 2020
	Sub: issuer key ID(sub 16)(8 bytes)
		Key ID - 0x3B3011B76B9D6523
	Hash left 2 bytes - e9 26 
	DSA r(159 bits) - ...
	DSA s(158 bits) - ...
		-> hash(DSA q bits)
```

#### References

[1] [Debian release key expired in OpenSuse repo](https://github.com/fish-shell/fish-shell/issues/4753)

[2] [osc signkey](https://github.com/fish-shell/fish-shell/issues/2618)
