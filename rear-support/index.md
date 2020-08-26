---
layout: default
title: Relax-and-Recover (rear) support
description: An overview of the support services around rear
author: gratien
tags: [rear, relax and recover, support, linux disaster recovery solution, IT3 Consultants, GPL]
---

# IT3 Consultants Support Services for Rear

## What is Relax-and-Recover (Rear)?

<img src="{{ site.url }}/images/logo/rear_logo_100.png" width="51" height="58" border="0" align="left" alt="Rear logo" />
Rear stands for <strong>Re</strong>lax <strong>a</strong>nd <strong>r</strong>ecover and is a Linux Disaster Recovery framework written in bash shell.

The code is completely free and is published with the GNU Public Licence version 3.

When we said rear is a disaster recovery framework we meant each module is small and has its own specific goal. Rear creates an iso image to boot from in case of disaster and the backup can be stores practically anywhere (NFS, CIFS, USB disks, remote tape devices). Rear is also capable to integrate with open source backup solutions such as Bacula, Bareos, Borg Backup, duplicity and also with commercial backup solutions such as Tivoli, NetBackup, EMC NetWorker and Data Protector.
IT3 Consultants is an official RedHat partner.

We can imagine this may sound a bit overwhelming to you, but we can help you out with the following offerings:

## Relax-and-Recover (ReaR) Consultancy Services

* helping you with writing and implementing a disaster recovery policy within your company
* designing and configuring rear as a central disaster recovery solution for your linux servers
* building a Proof-of-Concept set-up to convince your higher management
* help you with coding missing components within rear (for example to integrate new network kernel modules into rear)
* write the integration scripts for external (open source or commercial) backup solutions
* troubleshooting an existing disaster recovery solution based on ReaR
* migrate disaster recovery solutions based on mkCDrec towards ReaR
* migrate disaster recovery solutions based on older or legacy DR methods towards ReaR
* help you writing a disaster recovery manuals based on ReaR of course
* give training sessions to your operational teams
* assist in setting up an automated test environment for ReaR
* can be delivered via teleconference, on-site, or any other means agreed upon

Above list are paid services and are delivered by IT3 Consultants' author of ReaR (Gratien D'haese). Do not hesitate to contact us for more information about our services and/or prices.

## Relax-and-Recover (ReaR) Software Subscriptions

We offer software subscriptions so we are able to spend time on continous improvements of the code base and to be able to build automated test environments. As you are probably aware this cost a lot of money (and we invested a lot already) and time which we cannot spend on other (paid) projects. If you like ReaR and want us to keep up doing the good work then we would appreciate you go for a software subscription. We will mail you an invoice which acts as a proof for a valid software subscription.
By taking a ReaR Software Subscription you will also sponsor our project "[Relax-and-Recover Automated Testing]({{ site.url }}/projects/rear-automated-testing/)" which we use to test all updates on a regular basis.

Futhermore, a ReaR Subscription will allow us to work 1 hour per week (for REAR-10) and 3 hours per week (for REAR-100 and above) on the [Relax-and-Recover User Guide Documentation] ({{ site.url }}/projects/rear-user-guide/) project.

To make you life easy we have foreseen the following ReaR subscription options (on yearly basis):

<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="H2ABG5W4D23FW">
<table>
<tr><td><input type="hidden" name="on0" value="ReaR Subscription (for one year)">ReaR Subscription (for one year)</td></tr><tr><td><select name="os0">
	<option value="REAR-10">REAR-10 : €60,00 EUR - yearly</option>
	<option value="REAR-100">REAR-100 : €450,00 EUR - yearly</option>
	<option value="REAR-1000">REAR-1000 : €3 000,00 EUR - yearly</option>
</select> </td></tr>
</table>
<input type="hidden" name="currency_code" value="EUR">
<input type="image" src="https://www.paypalobjects.com/en_US/BE/i/btn/btn_subscribeCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>


## Relax-and-Recover (ReaR) Support Services

Be aware that each ReaR support contract does not include a ReaR Software Subscription, so you need to buy a seperate ReaR subscription based on the amount of units (a system where ReaR is installed and configured).

We have the following ReaR Support Contracts available according your needs:

* Standard (REAR-S) foresees maximum 5 incidents with a response time within *two* business days
* Advanced (REAR-A) foresees maximum 10 incidents with a response time on the *next* business day
* Business (REAR-B) foresees maximum 20 incidents with a response time on the *same* business day

For more information about the Service Level Agreements (SLA) or prices please [see the rear support services PDF file]({{ site.url }}/rear-support/rear-support-pricelist.pdf). If you feel the need to talk to an human or want more information about our company then go to our page ["about the company"]({{ site.url }}/company/about_company/)

We will mail you an invoice which acts as a proof for a valid ReaR Support contract. See our [pricelist]({{ site.url }}/rear-support/rear-support-pricelist.pdf) for prices.

## ReaR Consultancy

We can deliver ReaR consultancy tasks remote and in-site to assist in getting started with ReaR or to write or integrate (new) plugins. Mail or call us for more information on prices.

## Free ReaR Support Services

The ReaR community also delivers support for ReaR free of charge, but no guarantees of a quick answer or fix. Therefore, see our 

* [Relax-and-Recover Documentation](http://relax-and-recover.org/documentation/)
* [rear-users mailing list](http://lists.relax-and-recover.org/mailman/listinfo/rear-users)
* [Rear issue and/or bug tracker](https://github.com/rear/rear/issues)


## ReaR Workshops

We organize on request ReaR workshops in our offices or at customer's location. The workshop content is customer tailored and contains plenty of lab exercises. An example of such workshop agenda could be:

-	Introduction to ReaR
-	How to set it up and configure it
-	Design a Disaster Recovery Plan for your environment
-	Understand the basic settings
-	Security considerations
-	Lab 1: Set it up in our lab environment
-	Complex configurations and possibilities
-	Lab 2: make a rescue image and boot from it
-	Understanding the Disaster Recovery Process of a server
-	Lab 3: make a backup of the server with rear and do a recovery on a virtual machine
-	Disaster Recovery as a Service
-	Lab 4: making a central depot of rescue images
-	Lab 5: disaster recovery and the Cloud
-	Wrap up and Frequently Asked Questions


On regular basis we do a free workshop at conferences, such as the one we organized at [LinuxTag 2012](http://www.linuxtag.org/2012/de/program/workshops/workshops/vortragsdetails-talkid701.html), [LinuxTag 2014](http://www.linuxtag.org/2014/de/programm/vortragsdetails/?eventid=2653) and the workshop organized at the [Open Source Backup Conference, Cologne](http://osbconf.org/workshops/) in 2016.
