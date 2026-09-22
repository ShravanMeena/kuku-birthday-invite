# 🎂 Kuku · 33rd Birthday Invitation

Single-file animated invitation website. Venue photos Farm 5057 ke PDF se nikaal ke WebP me optimize kiye gaye hain.

**Speed**
- `index.html` — single file, **~27 KB gzipped**
- Pehla paint ke liye sirf **~75 KB** chahiye (HTML + hero photo)
- **0 external requests** — koi Google Font, koi CDN, koi library nahi
- Measured: First Contentful Paint **88 ms**, DOMContentLoaded **40 ms**
- Baaki 9 photos lazy-load hoti hain — scroll karne par hi download

---

## 1. Sab kuch yahan se badlo

`index.html` kholo → `<script>` ke shuru me `CONFIG` block hai. **Sirf isko edit karna hai:**

```js
const CONFIG = {
  name:      "Kuku",
  initial:   "K",                          // wax seal par letter
  age:       33,
  cardLine:  "thirty-three & radiant",     // envelope card ki tagline
  date:      "2026-10-10T12:00:00",        // YYYY-MM-DDTHH:MM:SS (local time)
  timeText:  "12:00 PM onwards",
  timeSub:   "All day — pool, lunch, then DJ till late",
  venue:     "Farm 5057",
  address:   "Main Chattarpur, Delhi",
  mapUrl:    "https://maps.google.com/?q=...",
  whatsapp:  "919000000000",               // ⚠️ BADALNA HAI
  tags:      ["DJ Night", "Private Pool", "Bar", "Open Lawn"],
  memories:  [ ... ]                       // Kuku ki photos (niche dekho)
};
```

Naam, weekday, countdown, calendar file (.ics), invitation card, WhatsApp RSVP — sab automatically CONFIG se update ho jaate hain.

### ⚠️ Abhi ye 2 cheezein pending hain
1. **`whatsapp`** — abhi `919000000000` dummy hai. Isko badle bina RSVP kahin nahi jayega.
2. **Kuku ki photos** — Memories section abhi placeholder gradients dikha raha hai (niche section 3 dekho).

Time **12:00 PM onwards** (poora din) set kar diya hai.

### Google Maps ka exact pin
`mapUrl` me abhi search query hai. Exact location ke liye: Google Maps me farm kholo → Share → link copy → `mapUrl` me paste.

---

## 2. Themes

Site pe **4 themes** hain. Pehli baar koi kholta hai to usse ek palette chunne ko milta hai, aur choice uske device pe yaad reh jaati hai (dobara nahi poochhega). Top-right me palette button se kabhi bhi badal sakte hain.

| Theme | Kaisa hai |
|---|---|
| **Emerald & Gold** | Forest green + champagne. Venue photos ke saath sabse accha match (default) |
| **Midnight & Gold** | Navy/starry night + gold |
| **Wine & Rose Gold** | Burgundy + rose gold. Warm aur romantic |
| **Ink & Champagne** | Lagbhag kaala + warm ivory. Minimal — rang photos se aata hai |

Sab kuch CSS variables pe chalta hai, to background, envelope, wax seal, invitation card ki ink, canvas particles aur confetti — sab theme ke saath badalte hain. Dress code chips ke naam bhi har theme ke apne hain.

**Naya theme add karna** — `index.html` me `THEMES` array me entry daalo, aur CSS me `:root[data-theme="tumhara-id"]{ ... }` block bana ke tokens define kar do. Baaki sab apne aap chal jayega.

**Default theme badalna** — `THEMES` array me use pehle number par le aao.

**Picker band karna** (agar sabko ek hi theme dikhani ho) — `start()` me `if (savedTheme())` ko `if (true)` kar do.

---

## 2. Photos

`photos/` folder me 10 WebP hain, PDF se nikali gayi:

| File | Kahan use hoti hai |
|---|---|
| `hero.webp` | Hero background (villa at dusk) |
| `dj-floor.webp` `pool-night.webp` `lounge.webp` `lawn.webp` | "The Night" ke 4 cards |
| `hero` `lawn-wide` `poolside` `tree` `courtyard` `entrance` | Venue gallery (lightbox ke saath) |

**Photo badalni ho:** usi naam se nayi file `photos/` me daal do. Chhoti rakhna (760px wide, WebP) warna site slow hogi:

```bash
magick apni-photo.jpg -resize 760x -quality 60 photos/pool-night.webp
```

---

## 3. Kuku ki photos (Memories section)

Sabse aasan tareeka — **script khud sab kar dega**:

```bash
# 1. photos ko is folder me daal do (koi bhi naam, .jpg/.png/.heic/.webp)
open photos/memories/

# 2. ye chala do
./add-photos.sh
```

Script kya karta hai:
- Har photo ko **square crop + 800px** tak resize karke **WebP** me convert karta hai (site fast rehti hai)
- `index.html` ka `CONFIG.memories` khud bhar deta hai
- Purane captions bacha ke rakhta hai
- Jitni photos hongi utne cards banenge (6 se zyada bhi chalega)

Dobara chala sakte ho — safe hai. Phir browser refresh kar do.

> ImageMagick chahiye: `brew install imagemagick`

**Caption badalne ke liye** `index.html` me `CONFIG.memories` dekho:
```js
{ caption:"The Queen", img:"photos/memories/kuku-1.webp", emoji:"👑", c1:"#d4638c", c2:"#5e3180" }
```

Jis card me photo nahi hai wo gradient + emoji dikhata hai, aur click nahi hota.
Jisme photo hai wo lightbox me full-screen khulta hai.

---

## 4. Live karna

Koi build step nahi. Poora folder (`index.html` + `photos/`) upload kar do:

- **Netlify** — folder drag & drop karo [netlify.com/drop](https://netlify.com/drop) par (sabse easy)
- **Vercel** — `vercel` CLI ya GitHub repo connect
- **GitHub Pages** — repo me push → Settings → Pages

Local test: `python3 -m http.server 8777` → `http://localhost:8777`

---

## Features

| Section | Kya hai |
|---|---|
| Preloader | Gold shimmer + progress bar |
| Hero | Villa photo with slow ken-burns zoom, naam letter-by-letter, "33" 0 se count-up, 3D mouse tilt, tap pe sparkle |
| **Invitation** | Sealed envelope. Seal ko **press and hold** karo → gold ring bharta hai, wax kaanpta hai, pitch upar chadhti hai → wax **7 tukdon me toot ke** udd jaata hai + gold flash → flap 3D me khulta hai → card **khud badh ke full-screen invitation** ban jaata hai (gold frame draw, light sweep, line-by-line reveal). Beech me chhod do to ring wapas khali ho jati hai. Jaldi tap karne par bhi khulta hai. |
| Countdown | Live days / hours / minutes / seconds |
| The Night | DJ / Pool / Bar / Lawn — asli photos ke saath |
| Venue | Farm 5057 gallery, tap karo to full-screen lightbox (arrow keys + Esc bhi chalte hain) |
| Details | Glass cards + "Add to calendar" (.ics generate hoti hai) + directions |
| Memories | Kuku ki photos, polaroid style, lightbox ke saath (`./add-photos.sh` se lagti hain) |
| Cake | Ivory 3-tier cake gold stand par, asli candle-light glow. Blow karo → flames bujhti hain, smoke uthta hai, **pura cake dim ho jata hai** (light source chala gaya), confetti barasta hai |
| Wish wall | Guests wish likh sakte hain |
| RSVP | Form → seedha WhatsApp message |
| Music | WebAudio se generated ambient tune — koi mp3 file nahi (0 bytes) |

Copy: "Sealed, just for you" / "Press and hold the seal".

Plus: custom cursor, scroll progress bar, blur-up photo placeholders (inline, 0 extra requests), `prefers-reduced-motion` support.

## Notes

- Wish wall `localStorage` use karta hai — wishes sirf usi device par dikhti hain jahan likhi gayi. Sabko dikhane ke liye backend chahiye.
- Music browser policy ki wajah se auto-play nahi hoti — top-right button dabana padega.
- Tested: 1440×900 desktop + 390×844 mobile, **0 console errors**.
