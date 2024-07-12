# VallidatorApp

VallidatorApp is a multi-platform application built with Flutter for the front-end and a combination of Node.js and Python for backend services. The project utilizes Firebase for configuration and error reporting, and PostgreSQL as the database.

## Getting Started

### Prerequisites

Ensure you have the following installed:
- Flutter SDK: [Flutter installation guide](https://flutter.dev/docs/get-started/install)
- Node.js: [Node.js installation guide](https://nodejs.org/en/download/)
- Python: [Python installation guide](https://www.python.org/downloads/)
- PostgreSQL: [PostgreSQL installation guide](https://www.postgresql.org/download/)

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/KaiqueGovani/VallidatorApp.git
    cd VallidatorApp
    ```

2. **Set up the backend**:
    - Navigate to the backend directory and install dependencies:
        ```sh
        cd Vallidator/backend
        npm install
        ```

3. **Set up the Python environment**:
    - Navigate to the Python directory and install dependencies:
        ```sh
        cd Vallidator/python
        pip install -r requirements.txt
        ```

4. **Set up the Flutter environment**:
    - Navigate to the Flutter app directory and get dependencies:
        ```sh
        cd Vallidator
        flutter pub get
        ```

### Running the Application

1. **Backend**:
    - Start the Node.js server:
        ```sh
        cd Vallidator/backend
        node server.js
        ```

2. **Flutter Application**:
    - Run the Flutter app on your desired device/emulator:
        ```sh
        cd Vallidator
        flutter run
        ```

### Key Features

- **User Management**: Create, edit, and manage users.
- **Template Management**: Add, edit, and manage templates.
- **Dashboard**: View various statistics and statuses of templates and files.
- **Data Processing**: Upload and process CSV, XLS, and XLSX files.

### Directory Structure

- **app/vallidator**: Contains the main Flutter application code.
- **app/vallidator/backend**: Contains the Node.js backend code.
- **app/vallidator/python**: Contains Python scripts for data processing.
- **app/vallidator/SQL**: SQL scripts for database setup.

### Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a new Pull Request.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Acknowledgements

- Flutter: [https://flutter.dev/](https://flutter.dev/)
- Firebase: [https://firebase.google.com/](https://firebase.google.com/)
- Node.js: [https://nodejs.org/en/](https://nodejs.org/en/)
- Python: [https://www.python.org/](https://www.python.org/)
- PostgreSQL: [https://www.postgresql.org/](https://www.postgresql.org/)

