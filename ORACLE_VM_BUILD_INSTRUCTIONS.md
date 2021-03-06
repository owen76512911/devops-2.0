# Oracle 7 VM Build Instructions

Follow these instructions to build the Oracle Linux 7.4 VM images.

## Build the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.4 'base-desktop' box (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer/oracle
    $ packer build base-desktop-ol74-x86_64.json
    ```
    NOTE: This will take several minutes to run.

3.	Build the Oracle Linux 7.4 'base-headless' box (headless):
    ```
    $ packer build base-headless-ol74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because the ISO image for Oracle Linux 7.4 has been cached.

4.	Build the Oracle Linux 7.4 'dev' box (desktop):
    ```
    $ packer build dev-ol74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because it is based on the 'base-desktop-ol74' image.

5.	Build the Oracle Linux 7.4 'ops' box (headless):
    ```
    $ packer build ops-ol74-x86_64.json
    ```
    NOTE: This build is based on the 'base-headless-ol74' image.

6.	Build the Oracle Linux 7.4 'cicd' box (headless):
    ```
    $ packer build cicd-ol74-x86_64.json
    ```
    NOTE: This build is based on the 'ops-ol74' image.

7.	Build the Oracle Linux 7.4 'apm' box (headless):

    NOTE: Prior to building the __APM VM__ image, you will need to perform the following tasks:

	-	Modify the AppDynamics Enterprise Console install script template:
		-	Copy and rename 'provisioners/scripts/centos/install_centos7_appdynamics_enterprise_console.sh.template' to '.sh'.
		-	Edit and replace  account username, password, platform release, server passwords, and other variables with your custom values.
	-	Apply your AppDynamics Controller license file:
		-	Copy your AppDynamics Controller 'license.lic' and rename it to 'provisioners/scripts/centos/tools/appd-controller-license.lic'.

    ```
    $ packer build apm-ol74-x86_64.json
    ```
    This build is based on the 'ops-ol74' image.

## Import the Vagrant Box Images

1.	Import the Oracle Linux 7.4 'dev' box image (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/artifacts/oracle/dev-ol74
    $ vagrant box add dev-ol74 dev-ol74.virtualbox.box
    ```

2.	Import the Oracle Linux 7.4 'ops' box image (headless):
    ```
    $ cd ../ops-ol74
    $ vagrant box add ops-ol74 ops-ol74.virtualbox.box
    ```

3.	Import the Oracle Linux 7.4 'cicd' box image (headless):
    ```
    $ cd ../cicd-ol74
    $ vagrant box add cicd-ol74 cicd-ol74.virtualbox.box
    ```

4.	Import the Oracle Linux 7.4 'apm' box image (headless):
    ```
    $ cd ../apm-ol74
    $ vagrant box add apm-ol74 apm-ol74.virtualbox.box
    ```

5.	List the Vagrant box images:
    ```
    $ vagrant box list
    apm-ol74 (virtualbox, 0)
    cicd-ol74 (virtualbox, 0)
    dev-ol74 (virtualbox, 0)
    ops-ol74 (virtualbox, 0)
    ...
    ```

## Provision the VirtualBox Images

1.	Provision the __Developer VM__ with Oracle Linux 7.4 (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/dev
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.06.2-ol, build d02b7ab

    dev[vagrant]$ ansible --version
    ansible 2.4.3.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    dev[vagrant]$ <run other commands>
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with Oracle Linux 7.4 (desktop) can also be used directly from VirtualBox.

2.	Provision the __Operations VM__ with Oracle Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/ops
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.06.2-ol, build d02b7ab

    ops[vagrant]$ ansible --version
    ansible 2.4.3.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    ops[vagrant]$ <run other commands>
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Provision the __CICD VM__ with Oracle Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/cicd
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    cicd[vagrant]$ sudo su -
    cicd[root]# gitlab-ctl status
    run: gitaly: (pid 633) 393s; run: log: (pid 632) 393s
    run: gitlab-monitor: (pid 687) 393s; run: log: (pid 686) 393s
    run: gitlab-workhorse: (pid 661) 393s; run: log: (pid 660) 393s
    run: logrotate: (pid 678) 393s; run: log: (pid 677) 393s
    run: nginx: (pid 675) 393s; run: log: (pid 674) 393s
    run: node-exporter: (pid 685) 393s; run: log: (pid 684) 393s
    run: postgres-exporter: (pid 718) 393s; run: log: (pid 717) 393s
    run: postgresql: (pid 627) 393s; run: log: (pid 626) 393s
    run: prometheus: (pid 705) 393s; run: log: (pid 704) 393s
    run: redis: (pid 621) 393s; run: log: (pid 619) 393s
    run: redis-exporter: (pid 696) 393s; run: log: (pid 690) 393s
    run: sidekiq: (pid 629) 393s; run: log: (pid 628) 393s
    run: unicorn: (pid 620) 393s; run: log: (pid 618) 393s

    cicd[root]# systemctl status jenkins
      jenkins.service - LSB: Jenkins Automation Server
       Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
       Active: active (running) since Wed 2017-09-20 12:08:35 EDT; 2h 22min ago
       ...
    Sep 20 12:08:12 cicd systemd[1]: Starting LSB: Jenkins Automation Server...
    Sep 20 12:08:35 cicd jenkins[967]: Starting Jenkins [  OK  ]
    Sep 20 12:08:35 cicd systemd[1]: Started LSB: Jenkins Automation Server.
    cicd[root]# exit

    cicd[vagrant]$ <run other commands>
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

4.	Provision the __APM VM__ with Oracle Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/apm
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    apm[vagrant]$ sudo su -
    apm[root]# cd /opt/appdynamics/platform/platform-admin/bin
    apm[root]# ./platform-admin.sh start-platform-admin
    Starting Enterprise Console Database
    ...
    ***** Enterprise Console Database started *****
    Starting Enterprise Console application
    Waiting for the Enterprise Console application to start.........
    ***** Enterprise Console application started on port 9191 *****
    apm[root]# exit

    apm[vagrant]$ <run other commands>

    apm[vagrant]$ sudo su -
    apm[root]# cd /opt/appdynamics/platform/platform-admin/bin
    apm[root]# ./platform-admin/bin/platform-admin.sh stop-platform-admin
    Attempting to stop process with id [6662]...
    .
    ***** Enterprise Console application stopped *****
    ..
    ***** Enterprise Console Database stopped *****
    apm[root]# exit
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Enterprise Console](https://www.appdynamics.com/product/) server locally on port '9191' [here](http://10.100.198.231:9191).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Ansible 2.4.3.0
	-	Ansible Container 0.9.2
-	Ant 1.10.2
-	Consul 1.0.6
-	Cloud-Init 0.7.9 [Optional]
-	Docker 17.06.2 CE
	-	Docker Bash Completion
	-	Docker Compose 1.19.0
	-	Docker Compose Bash Completion
-	Git 2.16.2
	-	Git Bash Completion
	-	Git-Flow 1.11.0 (AVH Edition)
	-	Git-Flow Bash Completion
-	Go 1.10
-	Gradle 4.6
-	Groovy 2.4.14
-	Java SE JDK 8 Update 162
-	Java SE JDK 9.0.4
-	jq command-line JSON processor 1.5
-	Maven 3.5.2
-	Oracle Compute Cloud Service CLI (opc) 17.2.2 [Optional]
-	Oracle PaaS Service Manager CLI (psm) 1.1.16 [Optional]
-	Packer 1.2.1
-	Python 2.7.5
	-	Pip 9.0.1
-	Python 3.3.2
	-	Pip3 9.0.1
-	Scala-lang 2.12.4
	-	Scala Build Tool (SBT) 1.1.1
-	Terraform 0.11.3
-	Vault 0.9.5

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 10.5.2 b951e0d
-	Jenkins 2.89.4

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Enterprise Console 4.4.1.0 Build 5840
	-	AppDynamics Controller 4.4.1.0 Build 103
	-	AppDynamics Event Service 4.4.1.0 Build 13998

The following developer tools are pre-installed in the __Developer VM__ (desktop) only:

-	AppDynamics Java Agent 4.4.1.0 Build 21006
-	Atom Editor 1.24.0
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 64.0.3282.186 (64-bit)
-	Firefox 52.6.0 (64-bit)
-	GVim 7.4.160-1
-	Postman 6.0.8
-	Scala IDE for Eclipse 4.7.0 (Eclipse Oxygen.1 [4.7.1])
-	Spring Tool Suite 3.9.2 IDE (Eclipse Oxygen.2 [4.7.2])
-	Sublime Text 3 Build 3143
-	Visual Studio Code 1.20.1
