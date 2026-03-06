# Gemini Project Context: OWG-Website

This document provides context for the Oh Wow Games LLC website project for Gemini.

## Project Overview

This is the official website for Oh Wow Games LLC, a game development studio. The website is a static site built with HTML, CSS, and JavaScript (using jQuery). It serves to introduce the company, showcase their games (like "Palettopia"), and provide news and contact information.

## Technology Stack

*   **HTML5:** For the structure and content.
*   **CSS3:** For styling, including animations and a responsive layout.
*   **JavaScript (ES6):** For dynamic behavior.
*   **jQuery:** Used for DOM manipulation and event handling.

## File Structure

*   `index.html`: The main landing page of the website.
*   `/css`: Contains the stylesheets.
    *   `main.css`: Global styles for the entire website.
    *   `palettopia.css`: Specific styles for the Palettopia game page.
*   `/scripts`: Contains the JavaScript files.
    *   `jquery-3.7.1.min.js`: The jQuery library.
    *   `main.js`: Custom JavaScript for site-wide functionality.
*   `/images`: Contains all image assets.
*   `/fonts`: Contains the font files.
*   `/palettopia`: Contains the landing page for the game "Palettopia".
*   `/newsletter`: Contains the newsletter sign-up page.
*   `/privacy-policy`: Contains the privacy policy page.

## Styling and Conventions

*   **Dark/Light Theme:** The website supports both a dark and a light theme. The theme can be toggled by the user and also respects the user's operating system preferences. The `body` element has a `dark` class when the dark theme is active.
*   **Responsive Design:** The site uses media queries to adapt to different screen sizes, from mobile to desktop.
*   **Fonts:** The primary font is 'Inter A', which is a custom web font included in the `/fonts` directory.
*   **Animations:** The website uses CSS animations for various effects, such as on the main logo and the elements on the Palettopia page.

## JavaScript (`scripts/main.js`)

The `main.js` file handles several key functionalities:

*   **Dynamic Copyright Year:** It automatically updates the copyright year in the footer.
*   **Logo Resizing:** The `resizeLogo()` function adjusts the height of the main logo.
*   **Theme Switching:** It handles the logic for switching between dark and light themes.
*   **Smooth Scrolling:** Implements smooth scrolling for on-page links (e.g., the "About Us" link on the homepage).
*   **Palettopia Page Logic:** The `resizePalettopia()` function contains logic specific to the layout and animations on the Palettopia page.

## Palettopia Page (`/palettopia/index.html`)

The Palettopia page is a significant feature of the website and has a more complex implementation than other pages.

*   **Animations:** This page features a highly animated hero section with moving waves, birds, and clouds. These are created using CSS sprite sheets and animations.
*   **Video:** It includes a background video.
*   **Specific Stylesheet:** The `css/palettopia.css` file contains styles that are unique to this page.
*   **JavaScript:** The `resizePalettopia()` function in `main.js` handles resizing and scaling of the animated elements on this page.
