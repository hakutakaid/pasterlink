#!/bin/bash

echo "Pilih opsi:"
echo "1. Ambil nama saja"
echo "2. Ambil nama dan URL"
read -p "Masukkan pilihan (1/2): " pilihan

if [[ "$pilihan" != "1" && "$pilihan" != "2" ]]; then
  echo "Pilihan tidak valid."
  exit 1
fi

read -p "Masukkan URL: " URL

OUTPUT_FILE="hasil.txt"
> "$OUTPUT_FILE"

curl -s "$URL" | \
grep -oP '<p><strong>.*?</strong></p>' | \
while read -r line; do
  if [[ $line =~ \<p\>\<strong\>([^<]+).*href=\"([^\"]+)\".*\<\/strong\>\<\/p\> ]]; then
    nama="${BASH_REMATCH[1]}"
    url="${BASH_REMATCH[2]}"

    # Trim dan bersihkan nama
    nama=$(echo "$nama" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')        # trim spasi
    nama=$(echo "$nama" | sed 's/[:：]*$//')                                # hapus titik dua di akhir
    nama=$(echo "$nama" | sed 's/&#[0-9]\+;//g')                            # hapus emoji HTML entitas

    if [[ "$pilihan" == "1" ]]; then
      echo "📁 $nama" >> "$OUTPUT_FILE"
    else
      {
        echo "📁 $nama"
        if [[ $url =~ dynamic\?r=([^&]+) ]]; then
          b64="${BASH_REMATCH[1]}"
          decoded_url=$(echo "$b64" | base64 --decode 2>/dev/null)
          echo "$decoded_url"
        else
          echo "$url"
        fi
        echo
      } >> "$OUTPUT_FILE"
    fi
  fi
done

echo "Hasil telah disimpan di $OUTPUT_FILE"
