# Carpool Flutter Project

Carpool is a rideshare application designed to streamline rideshare services for the AinShams University community, specifically focusing on the Faculty of Engineering. This project aims to create a customized version catering to the transportation needs of students within the university.

## Overview

In this version of the application, Carpool will concentrate on rides to or from Abdu-Basha and Abbaseya square, with designated destination points at Gate 3 and 4. The service will operate at fixed times, with a starting ride at 7:30 am from different locations and a return ride at 5:30 pm from the Faculty of Engineering campus.

To foster a sense of trust and security, users are required to sign in with an active account ending in @eng.asu.edu.eg, ensuring a closed community environment. Notably, Carpool adopts a unique strategy, being operated by students for students.

## Service Regulations

For this pilot project, the service is limited to two destination points (Gate 3 and 4) and specific ride times. Customers must reserve their seat before 10:00 pm the previous day for the 7:30 am ride and before 1:00 pm on the same day for the 5:30 pm ride.

## Features

### Riders Application

#### Authentication

- **Login/Signup:**
  - Email and password authentication.
  - Restricted access to @eng.asu.edu.eg emails.

#### Trip Booking

- **Available Trips:**
  - Displays a list of upcoming trips.
  - Booking deadlines: 10 PM the day before for morning trips, 1 PM the same day for afternoon trips.

- **Trip Details:**
  - Comprehensive view with trip and driver details.
  - Google Maps route display.

- **My Trips:**
  - Trip status overview (accepted, finished, rejected, or still requested).
  - Prevents booking the same trip twice.

#### Account Management

- **My Account:**
  - Offline account preview.
  - Edit account details with an internet connection.

### Drivers Application

#### Authentication

- **Login/Signup:**
  - Email and password authentication.
  - Restricted access to @eng.asu.edu.eg emails.

#### Trip Management

- **Create New Trip:**
  - Two tabs for trips to and from the faculty.
  - Trip creation forms with faculty gate selection, destination/start point entry, Google Maps location pinning, automatic time setting (7:30 am for to-faculty trips, 5:30 pm for from-faculty trips), and price entry.
  - Time restriction for trip creation.

- **My Trips:**
  - Overview of all created trips.
  - Access to trip details, including rider requests.

- **Trip Details:**
  - Rider request details (name, phone, and status).
  - Acceptance with time constraints (no acceptance after 4:30 PM for afternoon trips, no acceptance after 11:30 PM the day before for morning trips).

- **Finish Trip:**
  - Marks a trip as finished, changing its status.

## Demo Video

[![Demo Video](https://img.youtube.com/vi/6TQJ17CJAQ0/hqdefault.jpg)](https://www.youtube.com/watch?v=6TQJ17CJAQ0)

