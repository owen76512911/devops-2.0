# CentOS 7 VM Build Instructions

Follow these instructions to build the CentOS Linux 7.4 VM images.

## Build the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the CentOS Linux 7.4 'base-desktop' box (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer/centos
    $ packer build base-desktop-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.

3.	Build the CentOS Linux 7.4 'base-headless' box (headless):
    ```
    $ packer build base-headless-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because the ISO image for CentOS Linux 7.4 has been cached.

4.	Build the CentOS Linux 7.4 'dev' box (desktop):
    ```
    $ packer build dev-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because it is based on the 'base-desktop-centos74' image.

5.	Build the CentOS Linux 7.4 'ops' box (headless):
    ```
    $ packer build ops-centos74-x86_64.json
    ```
    NOTE: This build is based on the 'base-headless-centos74' image.

6.	Build the CentOS Linux 7.4 'cicd' box (headless):
    ```
    $ packer build cicd-centos74-x86_64.json
    ```
    NOTE: This build is based on the 'ops-centos74' image.

7.	Build the CentOS Linux 7.4 'apm' box (headless):

    NOTE: Prior to building the __APM VM__ image, you will need to perform the following tasks:

	-	Modify the AppDynamics Controller install script template:
		-	Copy and rename 'provisioners/scripts/common/install_appdynamics_controller.sh.template' to '.sh'.
		-	Edit and replace  account username, password, controller release, server passwords, and other variables with your custom values.
	-	Apply your AppDynamics Controller license file:
		-	Copy your AppDynamics Controller 'license.lic' and rename it to 'provisioners/scripts/common/tools/appd-controller-license.lic'.

    ```
    $ packer build apm-centos74-x86_64.json
    ```
    This build is based on the 'ops-centos74' image.

## Import the Vagrant Box Images

1.	Import the CentOS Linux 7.4 'dev' box image (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/artifacts/centos/dev-centos74
    $ vagrant box add dev-centos74 dev-centos74.virtualbox.box
    ```

2.	Import the CentOS Linux 7.4 'ops' box image (headless):
    ```
    $ cd ../ops-centos74
    $ vagrant box add ops-centos74 ops-centos74.virtualbox.box
    ```

3.	Import the CentOS Linux 7.4 'cicd' box image (headless):
    ```
    $ cd ../cicd-centos74
    $ vagrant box add cicd-centos74 cicd-centos74.virtualbox.box
    ```

4.	Import the CentOS Linux 7.4 'apm' box image (headless):
    ```
    $ cd ../apm-centos74
    $ vagrant box add apm-centos74 apm-centos74.virtualbox.box
    ```

5.	List the Vagrant box images:
    ```
    $ vagrant box list
    apm-centos74 (virtualbox, 0)
    cicd-centos74 (virtualbox, 0)
    dev-centos74 (virtualbox, 0)
    ops-centos74 (virtualbox, 0)
    ...
    ```

## Provision the VirtualBox Images

1.	Provision the __Developer VM__ with CentOS Linux 7.4 (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/dev
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.09.0-ce, build afdb6d4

    dev[vagrant]$ ansible --version
    ansible 2.4.0.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, May 29 2017, 20:42:36) [GCC 4.8.5 20150623 (Red Hat 4.8.5-11)]

    dev[vagrant]$ <run other commands>
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with CentOS Linux 7.4 (desktop) can also be used directly from VirtualBox.

2.	Provision the __Operations VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/ops
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.09.0-ce, build afdb6d4

    ops[vagrant]$ ansible --version
    ansible 2.4.0.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, May 29 2017, 20:42:36) [GCC 4.8.5 20150623 (Red Hat 4.8.5-11)]

    ops[vagrant]$ <run other commands>
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Provision the __CICD VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/cicd
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

4.	Provision the __APM VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/apm
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    apm[vagrant]$ sudo su -
    apm[root]# systemctl status appdcontroller
      appdcontroller.service - LSB: AppDynamics Controller
       Loaded: loaded (/etc/rc.d/init.d/appdcontroller; bad; vendor preset: disabled)
       Active: active (running) since Wed 2017-09-20 11:33:50 EDT; 1min 31s ago
       ...
    Sep 20 11:33:50 apm systemd[1]: Starting LSB: AppDynamics Controller...
    Sep 20 11:33:50 apm systemd[1]: Started LSB: AppDynamics Controller.

    apm[root]# systemctl status appdcontroller-db
      appdcontroller-db.service - LSB: AppDynamics Controller
       Loaded: loaded (/etc/rc.d/init.d/appdcontroller-db; bad; vendor preset: disabled)
       Active: active (running) since Wed 2017-09-20 11:33:50 EDT; 1min 42s ago
       ...
    Sep 20 11:33:45 apm appdcontroller-db[848]: Starting controller database on port 3388
    Sep 20 11:33:50 apm appdcontroller-db[848]: Waiting for Controller database to start on port 3388.....
    Sep 20 11:33:50 apm appdcontroller-db[848]: ***** Controller database started on port 3388 *****
    Sep 20 11:33:50 apm systemd[1]: Started LSB: AppDynamics Controller.
    apm[root]# exit

    apm[vagrant]$ <run other commands>
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Controller](https://www.appdynamics.com/product/) server locally on port '8090' [here](http://10.100.198.231:8090).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Ansible 2.4.0.0
    -	Ansible Container 0.9.2
-	Ant 1.10.1
-   Consul 1.0.0
-   Cloud-Init 0.7.9 [Optional]
    Docker 17.09.0 CE
    -	Docker Bash Completion
    -	Docker Compose 1.16.1
    -	Docker Compose Bash Completion
-	Git 2.14.3
    -	Git Bash Completion
    -	Git-Flow 1.11.0 (AVH Edition)
    -	Git-Flow Bash Completion
-   Golang 1.9.2
-	Gradle 4.2.1
-	Groovy 2.4.12
-	Java SE JDK 8 Update 152
-	Java SE JDK 9.0.1
-	Maven 3.5.2
-   Packer 1.1.1
-	Python 2.7.5
    -	Pip 9.0.1
-	Python 3.3.2
    -	Pip3 9.0.1
-   Scala-lang 2.12.4
    -	Scala Build Tool (SBT) 1.0.2
-   Terraform 0.10.7
-   Vault 0.8.3

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 10.1.0 5a695c4
-	Jenkins 2.73.2

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Controller 4.3.7.2
    -	Controller Repository includes:
    	-	AppDynamics Universal Agent 4.3.7.262
    	-	AppDynamics Java Agent 4.3.7.2

The following GUI tools are pre-installed in the __Developer VM__ (desktop) only:

-	Atom Editor 1.21.1
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 62.0.3202.62 (64-bit)
-	Firefox 52.4.0 (64-bit)
-	GVim 7.4.160-1
-	Postman 5.3.2
-	Scala IDE for Eclipse 4.7.0 (Eclipse Oxygen 4.7.1)
-	Spring Tool Suite 3.9.1 IDE (Eclipse Oxygen 4.7.1a)
-	Sublime Text 3 Build 3143
-	Visual Studio Code 1.17.2