# DAMP Server

DAMP Server is a simple implementation of a network environment that behaves like a LAMP server. The goal is to share Docker configuration files and the environment itself with web developers working with PHP, providing them with a straightforward implementation for small projects or tests without programmers having to spend hours configuring Docker files.

Windows has ready-made tools like XAMPP, but they are less versatile in terms of customization or knowledge of the built network environment. However, in most cases, it serves the purpose. The major problem is that within the vast array of Linux distributions, there is no equally simple solution that is consistent. Therefore, this repository serves as assistance to these individuals by providing all the necessary files to set up the entire required infrastructure completely within Docker containers. This makes the structure portable, simple, and functional on any system that runs Docker. Furthermore, this particular approach allows the infrastructure environment to be easily modified via Docker files to meet the specific demands of each project.

## Dockerfile's

### web
This Dockerfile serves the purpose of creating a Docker image based on the latest version of Ubuntu, configuring it to function as a web server environment. To achieve this, it includes the installation of essential packages. Firstly, it updates the package list using the apt update command and then proceeds to install the necessary software packages. These packages encompass Supervisor, a process control system, Apache2, a popular web server, as well as some utility tools like htop, nano, and net-tools. The -y flag is included in the installation command to automatically confirm the package installation without requiring user input.

To further customize the Apache and PHP configurations, the Dockerfile utilizes the COPY command. It copies a custom Apache configuration file named dir.conf to the /etc/apache2/mods-enabled/ directory, which likely contains specific settings related to Apache's directory indexing. Additionally, it copies a customized PHP configuration file named php.ini into the /etc/php/8.1/apache2/ directory, which presumably contains tailored PHP settings for use with the Apache web server.

The Dockerfile then ensures the creation of a directory at /var/log/supervisor, intended to serve as the location where Supervisor will store its log files. This step is crucial for monitoring and managing processes effectively.

Furthermore, it copies a Supervisor configuration file named supervisord.conf to the /etc/supervisor/conf.d/ directory. This file plays a pivotal role in defining and overseeing the processes that Supervisor will control within the container.

To make the web server accessible, the Dockerfile specifies the exposure of port 80, which is the default HTTP port. However, it's important to note that this line serves as documentation for users of the image and doesn't actually publish the port to the host system.

Finally, the Dockerfile defines the command that should be executed when a container is started from the resulting image. It specifies running supervisord in the foreground with the -n flag, ensuring that Supervisor takes charge of managing the defined processes, including Apache and potentially others, as outlined in the supervisord.conf file.

### db
This Dockerfile is designed to create a Docker image based on the latest version of the MariaDB container image. MariaDB is an open-source relational database management system that is a fork of MySQL and is commonly used for database applications.

To configure the MariaDB instance within the Docker container, you should modify several environment variables. Firstly, change the MYSQL_ROOT_PASSWORD variable and assign a different value to it. This variable specifies the root password for the MariaDB server, granting administrative access to the database system. Additionally, in the Dockerfile, it's important to adjust the MYSQL_USER variable to a username of your choice and MYSQL_PASSWORD to a secure password of your preference. These environment variables are used to create a user account in MySQL/MariaDB, and it's essential to customize them according to your security and configuration needs.

The Dockerfile also includes the instruction EXPOSE 3306, which informs Docker that the container should expose port 3306. Port 3306 is the default port used by MySQL and MariaDB for database connections. By exposing this port, other containers or services can connect to the MariaDB server running inside this Docker container.

Finally, the Dockerfile executes a series of commands using the RUN instruction. It starts by updating the package list within the container using apt update. Following the update, it installs several utility tools using apt install, including 'htop' (a system monitoring tool), 'nano' (a text editor), and 'net-tools' (a collection of network-related command-line tools). These tools are commonly used for various system administration tasks and provide flexibility in managing the container environment.

## Configuration FIles 

`supervisord.conf` is the configuration file for the web server service manager. Due to the absence of users and the implementation of containers, the use of systemd is undesirable. Therefore, I opted for a simpler and lighter service manager capable of running services in the foreground. This file contains only the configuration for the Apache service, but you can edit it if you wish to add other services that you want to keep running continuously.

`dir.conf` is an Apache indexing file, and there's no need to delve into a lengthy explanation for it.

`php.ini` is the PHP configuration file. It's a complex configuration file, and if you want to understand it in-depth, I recommend reading the PHP documentation. There aren't significant changes in it, mainly directives related to maximum memory allocation and script execution time. It's crucial to edit it according to the needs of your project before running the Docker Compose.

## Structure

This Docker Compose configuration file outlines the setup for managing two Docker containers: a web server and a database server. These containers will function as isolated services, each with specific configurations.

The 'web' service is defined with the following characteristics: It assigns a custom container name, 'web-server,' for easy identification. The image for this service is built using a Dockerfile located in the 'web' directory, allowing for custom configuration of the web server. The 'web' service is connected to a network named 'app-network,' enabling communication with other containers on the same network. A volume is mounted, linking the parent directory ('../') to the '/var/www/html/' directory within the 'web' container. This configuration indicates that the web server will serve content from the parent directory. Additionally, port 8080 on the host is mapped to port 80 in the 'web' container, enabling external access to the web server.

The 'db' service is defined similarly. It's assigned a container name, 'db-server,' and its image is built using a Dockerfile located in the 'db' directory. Like the 'web' service, it's connected to the 'app-network' for inter-container communication. Port 6000 on the host is mapped to port 3306 in the 'db' container, allowing external access to the database server.

A custom network named 'app-network' is defined in the 'networks' section with the 'bridge' driver. This network serves as the communication channel between the 'web' and 'db' containers, ensuring they can interact seamlessly.

The proposal is that this environment should work by simply placing it in your working repository. You just need to bring up both containers using Docker Compose from the '.yaml' file located inside the 'docker' folder. Remember that it's important for you to make the necessary changes to tailor this environment to your project. However, the default configuration is quite comprehensive.

## Installation

After reading the text above, run the following commands in the terminal:

```sh
./install.sh
```
## Notes
- The IP address of the database server is the last thing the installation script displays on the screen, this is convenient for changing database connection functions.

