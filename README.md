# FinanceMe Microservices Project

## Overview

FinanceMe is a leading banking and financial services provider based in Germany. This project implements a microservice architecture using Spring Boot, designed to enhance the scalability, reliability, and automation of our application infrastructure.

## Features

- **Microservice Endpoints**:
  - `POST /createAccount`: Create a new account (Request Body: JSON)
  - `PUT /updateAccount/{account_no}`: Update account details (Request Body: JSON)
  - `GET /viewPolicy/{account_no}`: View account policy (No Request Body)
  - `DELETE /deletePolicy/{account_no}`: Delete account policy (No Request Body)

- **Database**: Utilizes AWS RDS with MySQL for data persistence.

- **Testing**: JUnit test cases for service validation.

- **Monitoring**: Integrated with Prometheus and Grafana for real-time monitoring and visualization of metrics.

## Continuous Integration & Deployment

This project incorporates a fully automated CI/CD pipeline using:
- **Git**: Version control for tracking code changes.
- **Maven**: Automated builds.
- **Jenkins**: CI/CD orchestration.
- **Docker**: Containerization of applications.
- **Ansible**: Configuration management.
- **Kubernetes**: Orchestration for deploying and scaling applications.
- **Terraform**: Infrastructure provisioning.
