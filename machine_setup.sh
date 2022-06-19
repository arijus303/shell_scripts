#!/bin/bash
is_root=`id -u`;
run_level=$1;
rl1=("tmux" "ranger" "python3-pip" "vim" "nginx" "nodejs" "npm"
"git" "nmap" "conky-all" "htop", "snapd", "steghide", "cmake", "glances", "k3b"); //golan-go

function list_rl1(){

	for x in "${rl1[@]}"
	do
		echo "$x";
	done
}

if [[ $is_root != 0 ]];then
	echo "You must be root!";
	exit 1;
fi

if [[ -z $run_level ]];then
	echo -e "--- PLEASE SELECT WHAT TO INSTALL: ---\n";
	echo "1 - install BASIC UTILS:";
	echo "2 - install MYSQL";
	echo "3 - update NODE (to latest STABLE version)";
	echo "4 - install NODE GLOBAL PACKAGES";
	echo "5 - install DOCKER";
	echo "6 - install OPEN_SSH server";
	echo "7 - install Sublime Text";
	echo "8 - install Cherrytree";
	echo "9 - install Python virtual env";
	echo "10 - install Postman";
	echo "11 - install PostgreSQL";
	echo "12 - install Docker-composer";
	echo "13 - install Machine Learning Python libraries";

	exit 1;
fi

function install_docker_composer(){
	echo -e "----ATTEMPTING TO INSTALL Docker-composer ---\n";
	sudo apt-get install docker-compose -y && docker-compose -v

}

function install_postgresql(){
	echo -e "----ATTEMPTING TO INSTALL PostgreSQL ---\n";
	sudo apt install postgresql postgresql-contrib -y

}

function install_postman(){
	sudo snap install postman
}

function install_sublime(){

	echo -e "----ATTEMPTING TO INSTALL sublime text ---\n";
	apt install apt-transport-https ca-certificates curl software-properties-common && curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/" && apt update && apt install sublime-text 
}

function install_rl1() {

for i in "${rl1[@]}"
do
   echo -e "----ATTEMPTING TO INSTALL $i ---\n";
   apt-get install $i -y;

done
}

function install_mysql(){
	echo -e "--ATTEMPTING TO INSTALL MYSQL ---\n";
	apt install mysql-server && mysql_secure_installation;
	echo -e "---FURTHER CONFIGURATIONS ---";
	echo -e "STEP1: mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';\n"
	echo -e "STEP2: mysql> FLUSH PRIVILEGES;\n";
	echo -e "OPT: mysql> CREATE USER 'sammy'@'localhost' IDENTIFIED BY 'password';\n";
	echo -e "OPT: mysql> GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;\n";

}

function update_NODE(){
	npm cache clean -f
	npm install -g n
	sudo n stable
}

function install_global_NODE_packages(){
	echo "UNDEFINED <<";
}
function install_DOCKER(){
	echo -e "--ATTEMPTING TO INSTALL DOCKER ---\n";
	curl -fsSL get.docker.com -o get-docker.sh && /bin/sh get-docker.sh
}

function install_openSSH(){
 	echo -e "--ATTEMPTING TO INSTALL SSH ---\n";

	apt-get install openssh-server -y && systemctl start ssh.service && systemctl status ssh.service
}

function install_cherrytree(){
	echo -e "--ATTEMPTING TO INSTALL Cherrytree ---\n";
	add-apt-repository ppa:giuspen/ppa
	apt-get update
	apt-get install cherrytree -y
}
	
function install_python_virtual_env(){
	echo -e "--ATTEMPTING TO INSTALL Python virtual env ---\n";
	pip3 install virtualenv
}
function install_ml_libraries(){

	echo -e "--ATTEMPTING TO INSTALL Machine Learning Python Libraries ---\n";

	pip install tqdm
	pip install scipi
	pip install matplotlib
	pip install pandas
	pip install sklearn
}

apt-get update

case $run_level in 
	1)	install_rl1;;
	2)	install_mysql;;
	3)	update_NODE;;
	4)	install_global_NODE_packages;;
	5)	install_DOCKER;;
	6) install_openSSH;;
	7) install_sublime;;
	8) install_cherrytree && echo -e "---Finished sequence: 8 ---";;
	9)	install_python_virtual_env && echo -e "---Finished sequence: 9 ---";;
	10)install_postman && echo -e "---Finished sequence: 10 ---";;
	11)install_postgresql && echo -e "---Finished sequence: 11 ---";;
	12)install_docker_composer && echo -e "---Finished sequence: 12 ---";;
	13)install_ml_libraries && echo -e "---Finished sequence: 13 ---";;
	
	*)	echo "bye";;
esac

