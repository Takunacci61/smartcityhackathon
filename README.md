
# Smart City Scooter Management Solution

This project is a smart city solution developed for the **Smart City Hackathon** in Milton Keynes. It focuses on efficient scooter management within urban environments, utilizing real-time data and geographical mapping to optimize scooter availability, monitor hotspot areas, and enhance the urban transportation experience.

## Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Future Enhancements](#future-enhancements)
- [Acknowledgments](#acknowledgments)

## About the Project

The goal of this project is to enable smart city planning and improve urban mobility by providing a real-time solution for monitoring and managing scooters across popular hotspots. The application is designed to support transportation operators in deploying and maintaining scooter fleets effectively, ensuring availability in high-demand areas and facilitating sustainable last-mile travel.

## Features

1. **Real-Time Scooter Tracking**: Displays scooters on an interactive map, allowing for real-time monitoring of their locations.
2. **Hotspot Identification**: Marks key hotspots such as train stations and popular landmarks, helping operators identify high-demand areas.
3. **Random Scooter Navigation**: A feature to navigate to a randomly selected scooter with a highlighted, pulsing marker to draw attention to its current location.
4. **Proximity Detection**: Scooters within a 500-meter radius of a hotspot are flagged, aiding operators in redistributing the fleet as needed.
5. **User-Friendly Interface**: Differentiated map markers for hotspots and scooters (near or far from hotspots) make it easy to assess scooter distribution.

## Tech Stack

- **Flutter**: Cross-platform mobile application development
- **Flutter Map with OpenStreetMap**: For mapping scooter and hotspot locations on an interactive map
- **Geolocation & Geospatial Analysis**: Using Geolocator package for distance calculations between scooters and hotspots
- **HTTP & RESTful API Integration**: Fetches real-time scooter data from data endpoints for location updates

## Getting Started

To run this project locally, follow these steps:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/smart-city-scooter-management.git
   cd smart-city-scooter-management
   ```

2. **Install Dependencies**
   Make sure Flutter is installed on your machine, then run:
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

## Usage

The app provides the following interactive features:

1. **View Hotspots**: Display major hotspots across the city.
2. **Track Scooters**: See scooter locations in real-time, with differentiation based on proximity to hotspots.
3. **Navigate to Random Scooter**: Click the shuffle icon to jump to a random scooter's location.
4. **Filter by Hotspot Proximity**: Toggle to only display scooters near hotspots.

## Screenshots

Here are some screenshots of the application:

- **Hotspot and Scooter Overview**
- **Random Scooter Navigation**
- **Hotspot Proximity Filtering**

> _Add images to the repository under a `screenshots` directory and link them here._

## Future Enhancements

Potential improvements for the project include:

- **Heatmap for Hotspot Demand**: Display areas with high demand intensity.
- **Predictive Analytics**: Use AI to predict peak times and suggest optimal scooter deployments.
- **User Feedback Integration**: Allow users to report scooter availability or issues.

## Acknowledgments

This solution was developed as part of the Smart City Hackathon in Milton Keynes. Special thanks to the organizers and mentors for their support.
