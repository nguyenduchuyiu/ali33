# ALI33 - Movies Rentals Web Application

## Description

ALI33 is a web application that allows users to rent and enjoy a wide selection of films from the comfort of their own homes. Built with a user-friendly interface, ALI33 offers a seamless browsing and renting experience for movie lovers of all tastes.

## Getting Started

This README outlines the steps for setting up and running the ALI33 web application on your local machine for development and testing.

### Prerequisites

* **Docker:** Ensure Docker is installed and running on your machine. [https://www.docker.com/](https://www.docker.com/)
* **Python:** Ensure Python is installed. [https://www.python.org/](https://www.python.org/)
* **Flutter:** Ensure Flutter is installed and set up. [https://flutter.dev/](https://flutter.dev/)

### 1. Database Setup

1.  **Pull the Database Image:**
    ```bash
    docker pull nguyenduchuyiu/ali33_db:latest
    ```

2.  **Run the Database Container:**
    ```bash
    docker run -d -p 3307:3306 nguyenduchuyiu/ali33_db:latest
    ```
    This will run the database container in detached mode, mapping port 3307 on your host machine to port 3306 inside the container.

3.  **Initialize the Database:**
    ```bash
    python initialize_database.py
    ```
    This will run a script to populate the database with initial data.

### 2. Backend Setup

1.  **Navigate to the Backend Folder:**
    ```bash
    cd backend
    ```

2.  **Run the Server:**
    ```bash
    python server.py
    ```
    This will start the backend server, making the application's API available.

### 3. Frontend Setup

1.  **Navigate to the Frontend Folder:**
    ```bash
    cd frontend
    ```

2.  **Start the Flutter Application:**
    ```bash
    flutter build web
    flutter run -d chrome
    ```
    This will launch the application in Chrome browser.

## Summary

This process sets up the database, backend server, and frontend application. You can now access and interact with the application through the Chrome browser.
