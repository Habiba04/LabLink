# LabLink

[Repository Link](https://github.com/Habiba04/LabLink.git)

LabLink is a unified healthcare app that connects multiple laboratories in one platform. Patients can easily reach more labs, communicate with them, and securely access their medical reports in one place, making healthcare more accessible, efficient, and patient-friendly.

## Table of Contents
- [Project Description](#project-description)  
- [Features](#features)  
- [User Roles](#user-roles)  
- [Technologies Used](#technologies-used)  
- [Installation](#installation)  
- [APK](#apk-download)  
- [Usage](#usage)  
- [Contributing](#contributing)  

## Project Description
LabLink allows patients to book medical tests online while enabling labs and administrators to efficiently manage their operations. It provides distinct experiences for **patients**, **lab admins**, and a **super admin**.

### Features
- **Patients** can:  
  - Sign up and log in  
  - Browse a list of labs and select branches  
  - Choose tests or upload prescriptions  
  - Schedule appointments (date & time selection)  
  - View and manage their bookings  

- **Lab Admins** can:  
  - Log in with a custom-provided email (signup not allowed)  
  - Add and manage locations (branches)  
  - Add available tests and set their prices  
  - Manage and respond to bookings (accept/reject)  
  - Access dashboard analytics, patient reviews, and reports  

- **Super Admins** can:  
  - Log in with a predefined email  
  - Manage labs (add, remove, edit)  
  - Access dashboard analytics across all labs  

## User Roles
| Role        | Permissions                                                                 |
|------------|----------------------------------------------------------------------------|
| Patient    | Browse labs, book tests, upload prescriptions, view bookings               |
| Lab Admin  | Manage branches, tests, bookings, view dashboard & reports, see reviews    |
| Super Admin| Manage labs, access overall dashboard                                      |

## Technologies Used
- Flutter (Frontend)  
- Firebase (Authentication, Firestore, Storage)  
- Provider (State management)  

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Habiba04/LabLink.git
2. Navigate to the project directory:
   ```bash
   cd lablink
3. Install Dependencies:
   ```bash
   flutter pub get
4. Run the app
   ```bash
   flutter run

## APK
You can download the most recent version of the application from here [**Github Releases Page**](https://github.com/Habiba04/LabLink/releases/tag/Version)

## Usage
1. Open the LabLink app.  
2. Select your role: **Patient**, **Lab Admin**, or **Super Admin**.  
3. Follow the prompts to log in:  
   - Patients can browse labs, choose tests or upload prescriptions, schedule appointments, and view bookings.  
   - Lab Admins can manage branches, tests, bookings, view dashboard analytics, and see patient reviews.  
   - Super Admins can manage labs and access overall dashboard analytics.  
4. Navigate through the app to perform the actions allowed for your role.

## Contributing
Contributions to LabLink are welcome! Here’s how you can help:  
1. Fork the repository and clone it to your local machine.  
2. Create a new branch for your feature or bug fix.  
3. Make your changes and ensure the app runs without errors.  
4. Commit your changes with clear messages.  
5. Push your branch and submit a Pull Request.  

Feel free to open an issue if you find bugs or have suggestions for improvements. All contributions, big or small, are appreciated!
