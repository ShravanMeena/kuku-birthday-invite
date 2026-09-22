Kuku ki photos yahan daalo.

1. Photo ko yahan copy karo, jaise: photos/memories/kuku-1.jpg
2. index.html kholo -> CONFIG -> memories array
3. us card ke `img:""` me path likho:

   { caption:"The Queen", img:"photos/memories/kuku-1.jpg", emoji:"...", ... }

Square (1:1) photos sabse acchi lagti hain.
Photo ko chhota rakhna (800px wide) warna site slow hogi:

   magick kuku-1.jpg -resize 800x -quality 65 photos/memories/kuku-1.webp

Agar path galat hoga to card gradient + emoji dikha dega (site tootegi nahi).
