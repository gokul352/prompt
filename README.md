# Gokul – Before & After Compare

A single-page website to compare a **before** and **after** image with a drag slider.
It has 5 image sets, each with its own name and prompt:

1. Moody Olive Travel
2. Warm Foggy Mountain Ride
3. Dreamy Golden Forest
4. Cool Misty Valley
5. Mint Mist Mountain

## Features
- Before / After image upload in two columns (admin only)
- Drag slider compare, plus fullscreen and download
- Prompt box for each set (admin edits, visitors only read)
- Admin login protects the editing panel

## Run
No build step. Open `index.html` in a browser.

## Deploy with GitHub Pages
1. Create a new repository and upload these files.
2. Go to **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**, select `main` and `/ (root)`, then **Save**.
4. After a minute the site is live at `https://<your-username>.github.io/<repo-name>/`.

## Notes
- Images and prompts added in the admin panel are saved in that browser only (localStorage). Other visitors will not see them.
- The admin login is checked in the page code, so it keeps casual visitors out but is not real security. Do not reuse this password elsewhere.
- Needs an internet connection to load React from a CDN.
