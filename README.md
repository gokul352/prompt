# Gokul – Before & After Compare

A website to compare a **before** and **after** image with a drag slider.
It has 5 image sets, each with its own name and prompt:

1. Moody Olive Travel
2. Warm Foggy Mountain Ride
3. Dreamy Golden Forest
4. Cool Misty Valley
5. Mint Mist Mountain

Only the admin can add images and prompts. Visitors only see the images, the compare slider and the prompt.

## Files
- `index.html` – the website
- `supabase-setup.sql` – creates the shared storage (run once)
- `.nojekyll` – lets GitHub Pages serve the page as it is

## Step 1 – Create the shared storage (free, about 5 minutes)
1. Go to https://supabase.com, sign in and click **New project**. Pick any name and database password, then wait for it to finish.
2. Open **SQL Editor → New query**, paste everything from `supabase-setup.sql` and click **Run**. You should see "Success".
3. Open **Project Settings → API** and copy:
   - **Project URL**
   - the **anon / publishable key**
4. Open `index.html`, find these two lines near the top of the script and paste your values between the quotes:

```js
const SUPABASE_URL='';
const SUPABASE_KEY='';
```

## Step 2 – Put it on GitHub Pages
1. Create a repository and upload `index.html`, `README.md`, `supabase-setup.sql` and `.nojekyll`.
2. **Settings → Pages → Deploy from a branch → main → / (root) → Save**.
3. The site opens at `https://<your-username>.github.io/<repo-name>/`.

## Using it
Click **🔒 Admin** and log in (username `Gokul`). Pick a number, add the Before and After images, write the prompt and click Save Prompt. Everything is saved to Supabase, so every visitor sees it on any device.

## Notes
- The admin password is stored in Supabase (table `admin_login`), not in the website code. To change it, edit the password in `supabase-setup.sql` and run that block again. Please choose a stronger password than 4 digits.
- The anon key in `index.html` is meant to be public. It can only read the sets and call the four admin functions, and those need the username and password.
- Photos are shrunk to a maximum of 1280px before saving to keep the page fast.
- If `SUPABASE_URL` and `SUPABASE_KEY` are empty, the page still works for testing, but everything stays in your own browser.
