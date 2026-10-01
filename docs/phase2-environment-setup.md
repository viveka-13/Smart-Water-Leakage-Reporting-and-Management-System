# AquaGuard: Phase 2 Environment Setup

## Phase title

## Phase 2: Environment setup

### 1. What we are building

In this phase, we prepare the working environment needed for the AquaGuard project. We are not writing the application logic yet; we are installing and verifying the essential tools, configuring the project folders, and making sure the development environment is ready for Flutter, Node.js, MySQL, and Android-based testing.

The goal is to make sure the setup is stable before the real app development begins in Phase 3.

### 2. Architecture concept

The environment setup follows the same layered architecture described in Phase 1:

- Flutter mobile frontend for citizens, workers, and admin users
- Node.js backend for API services and business logic
- MySQL database for persistence and reporting
- Android emulator and device testing for Flutter runtime validation
- Local development environment for secure configuration and debugging

This phase is important because every later phase depends on a stable environment. If the SDKs, permissions, and database services are configured correctly, the development process becomes smoother and more predictable.

### 3. Files and folders

The following structure is expected after the environment setup phase:

```text
aquaguard/
├── .gitignore
├── README.md
├── docker-compose.yml
├── mobile/
│   ├── lib/
│   ├── assets/
│   ├── test/
│   └── pubspec.yaml
├── backend/
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── .env.example
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── schema.sql
├── docs/
│   ├── phase1-project-plan.md
│   ├── phase2-environment-setup.md
│   ├── architecture.md
│   ├── api.md
│   ├── database.md
│   └── testing.md
└── docker-compose.yml
```

At this stage, the project folders are created and environment tools are prepared for project initialization.

### 4. Complete code

This phase does not add application code. There is no Flutter source implementation yet. Instead, the deliverable here is a verified environment plan and setup workflow.

No functional app logic should be written yet.

### 5. Commands

Use the following Windows PowerShell commands.

#### 5.1 Check Flutter installation

```powershell
flutter --version
flutter doctor
flutter doctor -v
```

#### 5.2 Check Node.js and npm

```powershell
node -v
npm -v
```

#### 5.3 Check MySQL or local database service

```powershell
mysql --version
```

If MySQL is installed using XAMPP or MySQL Server, confirm that the service is running from the Services panel or command line.

#### 5.4 Android emulator setup

```powershell
where adb
adb devices
```

If Android Studio is installed:

```powershell
"C:\Users\<YourUser>\AppData\Local\Android\Sdk\emulator\emulator.exe" -list-avds
```

#### 5.5 Create the Flutter project

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard"
flutter create mobile
```

This command creates the Flutter app template inside `mobile/`.

#### 5.6 Initialize backend project

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm init -y
```

Then install the backend dependencies:

```powershell
npm install express mysql2 cors dotenv helmet express-rate-limit bcryptjs jsonwebtoken multer morgan
npm install --save-dev nodemon jest supertest eslint
```

#### 5.7 Set up MySQL with Docker

```powershell
docker-compose up -d
```

#### 5.8 Git setup

```powershell
git init
git status
git branch -M main
```

### 6. How to run

Follow these steps exactly:

1. Open PowerShell in the project folder.
2. Verify Flutter, Node.js, and MySQL are installed.
3. Run `flutter doctor` and fix all missing dependencies.
4. Configure Android SDK, emulator, and platform tools.
5. Create the Flutter application in `mobile/`.
6. Initialize the Node.js backend in `backend/`.
7. Configure environment variables using `.env.example` later.
8. Start MySQL using Docker or local installation.
9. Confirm that Android emulator or connected device is visible.
10. Only after that, begin Phase 3 development.

### 7. Expected output

The output should show:

- Flutter installed and recognized by the system
- `flutter doctor` reporting no blocking issues or only minor warnings
- Node.js and npm installed successfully
- MySQL or Docker container ready for local database testing
- Android emulator visible through `adb devices`
- Flutter project structure created under `mobile/`
- Backend package initialized under `backend/`
- Git initialized for the project repository

### 8. Common errors

#### Flutter doctor issues

- Android SDK not found
- Android license not accepted
- Missing `cmdline-tools`
- Flutter plugin not installed

Fix:

```powershell
flutter config --android-studio-dir "C:\Program Files\Android\Android Studio"
flutter doctor --android-licenses
```

#### Node.js not recognized

- Install LTS version of Node.js
- Restart the terminal
- Run `where node`

#### MySQL connection failure

- Check if Docker is running
- Check if MySQL service is active
- Verify `.env` values if set later

#### Emulator not detected

- Open Android Studio Device Manager
- Create an Android Virtual Device
- Run `adb devices`

#### Git not initialized

```powershell
git init
```

### 9. Test checklist

Use this checklist after setup:

- [ ] Flutter is installed
- [ ] `flutter doctor` runs without critical issues
- [ ] Node.js is installed
- [ ] npm is installed
- [ ] MySQL is available
- [ ] Docker is running if using containerized database
- [ ] Android emulator is detected
- [ ] `adb devices` shows a device or emulator
- [ ] Flutter project has been created in `mobile/`
- [ ] Backend folder has been initialized in `backend/`
- [ ] Git repository is initialized
- [ ] Project folders match the planned structure

### 10. Academic explanation

This phase is important because software development projects succeed only when the environment is correctly configured. In a practical project, developers first ensure that all required tools are installed and working. Flutter is used for the app frontend, Node.js is used for the backend API, and MySQL provides database storage. Setting up the environment carefully reduces errors later in coding, testing, and deployment.

During a viva, this phase can be explained as the foundation of the project. Without a stable development environment, the application cannot function properly, so this setup stage is essential for real software engineering.

### 11. Stop

This is the end of Phase 2. The environment is prepared and the project is ready for the Flutter foundation phase. Please confirm before beginning Phase 3.
