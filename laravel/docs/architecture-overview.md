# Architecture Overview

## Development Overview

### Server Development (LAMP)
Server development is conducted on cloud services such as Google Cloud, Amazon AWS, Microsoft Azure, or others and utilizes a LAMP stack: **Linux, Apache, MySQL, PHP**.

#### Google Cloud Example

##### Compute Engine (GCE)
- Ubuntu **24.04 LTS** servers: **staging** and **production**

##### VPC Network
- Static IP addresses: **staging** and **production**

##### Cloud SQL (MySQL)
- **MySQL 8.0** instances: **staging** and **production**

##### Cloud Storage
- **User Uploads** bucket
- **DB Backup** bucket

---

## Operating System: Linux (Ubuntu)
All server development is hosted on **Ubuntu Linux 24.04 LTS** VM instances running on a cloud VM service.

## Web Server (Apache)
The web server uses [Apache HTTP Server](https://httpd.apache.org/) to handle web requests and route them to the Laravel application.

## Database (MySQL)
Development utilizes [MySQL](https://www.mysql.com).

## App Server (PHP / Laravel)
The backend is written in [PHP](https://en.wikipedia.org/wiki/PHP) using the [Laravel](https://en.wikipedia.org/wiki/Laravel) framework (MVC).
Laravel provides:
- Modular packaging with Composer dependency management
- Multiple database access patterns
- Utilities that aid deployment and maintenance

## CMS / API Development
A RESTful JSON **API** serves client applications. A secure **CMS** manages selected app data.

- The API is written in PHP and exposed via SSL-secured endpoints for **staging** and **production**.
- Clients authenticate to obtain a **user token**; subsequent API calls include this token.

## Installation Scripts (Ansible)
[Ansible](https://www.ansible.com/) automates provisioning for staging and production.

> Ansible describes desired infrastructure state (e.g., Apache, Redis) so you can safely and repeatedly build servers or rebuild from scratch.

**Example Ansible task:**
```yaml
---
# tasks
- name: Install essential packages
  apt:
    pkg: "{{ item }}"
    update_cache: yes
    cache_valid_time: 3600
  become: true
  become_method: sudo
  with_items:
    - build-essential
    - automake
    - autoconf
    - git
    - fail2ban
    - unattended-upgrades
    - vim
```
