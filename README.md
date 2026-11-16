# admerl memories

An infinite canvas for displaying photos as polaroids, grouped into titled chapters.

## Features

- Upload photos (file picker, camera, drag and drop, or paste) and they appear as polaroids with a "develop" effect
- Frame sizes (Original, 1:1, 4:5, 3:4, 5:4, 16:9), film looks (Warm, Faded, Mono, Cool), washi tape or pin
- Handwritten captions and notes, freehand pen with a vintage ink palette and custom colors
- Chapters: titled areas you can jump to, play as a slideshow, or download as a PNG
- Lightbox for full-size viewing, pan and zoom, one-finger pan and two-finger pinch on phones
- Shared online board: editors sign in with an email link; everyone else can view

## How it's hosted

- **Website:** a single static page (`index.html`), deployed on Vercel straight from this repo. No build step.
- **Data:** Supabase. Board items live in the `items` table, photos in the public `photos` storage bucket, and changes stream to every open device through Supabase Realtime.
- **Access:** anyone can view. Only emails listed in the `board_editors` table can add, move or delete things. The rules are enforced by row-level security in the database, not just hidden in the page.

## Setup

1. **Supabase → SQL Editor:** paste `supabase/setup.sql`, replace the two example emails at the bottom with the editors' emails, and run it.
2. **Supabase → Authentication → URL Configuration:** set *Site URL* to the Vercel address (for example `https://admermemories.vercel.app`) and add it under *Redirect URLs*.
3. **Vercel:** import this repo as a new project (framework preset *Other*, no build command). Every push to `main` redeploys.

The Supabase project URL and publishable key are in `index.html`. The publishable key is meant to be public; the database rules decide who can write.

To add or remove an editor later, edit the rows in Supabase → Table Editor → `board_editors`.
