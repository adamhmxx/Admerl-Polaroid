# admerl memories

An infinite canvas for displaying photos as polaroids, grouped into titled chapters.

## Features

- Upload photos (file picker, camera, drag and drop, or paste) and they appear as polaroids with a "develop" effect
- Frame sizes (Original, 1:1, 4:5, 3:4, 5:4, 16:9), film looks (Warm, Faded, Mono, Cool), washi tape or pin
- Handwritten captions and notes, freehand pen with a vintage ink palette and custom colors
- Chapters: titled areas you can jump to, play as a slideshow, or download as a PNG
- Lightbox for full-size viewing, pan and zoom, one-finger pan and two-finger pinch on phones
- Shared online board: anyone with the link can add and edit, and changes show up live on every device

## How it's hosted

- **Website:** a single static page (`index.html`), deployed on Vercel straight from this repo. No build step.
- **Data:** Supabase. Board items live in the `items` table, photos in the public `photos` storage bucket, and changes stream to every open device through Supabase Realtime.
- **Access:** the board is open: anyone with the link can view and edit, so share it only with people you trust. Uploads are limited to images up to 20 MB. To require sign-in again, set `open: false` in the `SUPA` config in `index.html` and re-run the editor policies from `setup.sql`.

## Setup

1. **Supabase → SQL Editor:** run `supabase/setup.sql`, then `supabase/open-board.sql`.
2. **Vercel:** import this repo as a new project (framework preset *Other*, no build command). Every push to `main` redeploys.

The Supabase project URL and publishable key are in `index.html`. The publishable key is meant to be public; the database rules decide who can write.
