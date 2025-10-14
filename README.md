# Bash‑CI

> A minimal CI/CD server built in Bash — a do‑it‑yourself approach to continuous integration and delivery.

This repository was created as a **demo project** accompanying a presentation, which you can watch here:  
[📺 CI/CD: Do It Yourself on YouTube](https://www.youtube.com/live/CDCYISxfW7o?si=O0OZdrllzjPiGSDN)

---

## Table of Contents

1. [Overview](#overview)  
2. [Features](#features)  
3. [Architecture & Design](#architecture--design)  
4. [Requirements](#requirements)  
5. [Installation & Setup](#installation--setup)  
6. [Usage](#usage)  
7. [Contributing](#contributing)  
8. [License](#license)  
9. [Credits & Acknowledgments](#credits--acknowledgments)  

---

## Overview

Bash‑CI is a lightweight, minimalistic CI/CD system implemented in Bash scripts and NGINX with FastCGI. It was built as a pedagogical tool to show how one might build a CI/CD pipeline from scratch using familiar Unix tools and shell scripting without using production-grade systems and frameworks.

The goal is **not** to replace production-grade systems (Jenkins, GitHub Actions, GitLab CI, etc.), but rather to serve as a learning exercise and demonstration of core principles.

---

## Features

- Execute build/test/deploy pipelines using shell scripts  
- Lightweight footprint
- Easy to inspect, understand, and extend  
- Basic support for notifications and logs
- Docker integration 
- Basic HTTP interface

---

## Architecture & Design

- NGINX/FastCGI exposes an endpoint (implemented by a Bash script) that is called by GitHub (webhook) on every commit to the [demo-app](https://github.com/malipio/demo-app) repository 
- A build is triggered (by calling a custom Bash script)
- Once build is finished a GitHub comment is added to relevant commit-sha
- Logs and build output are available on NGINX server

---

## Requirements

- A UNIX‑like environment (Linux, macOS)  
- Bash (version ≥ 4 recommended)  
- Docker & Docker Compose

---

## Installation & Setup

1. Clone the repo
2. Add relevant secrets to `.env` folder
3. Build Docker images and start services:

   ```bash
   docker-compose up --build
   ```
4. Setup a webhook in GitHub
   
---

## Usage

1. Push changes to your repository  
2. Bash‑CI detects changes via webhook
3. The pipeline is executed
4. Logs and status are persisted
5. Pipeline status is communicated using github comment functionality

---

## License

This project is distributed under the **MIT License**, see [LICENSE](LICENSE) for details.

---

> ⚠️ **Disclaimer**: This project is intended for educational and demonstrative use. It lacks many features and safeguards present in mature CI/CD systems. Use with caution!
