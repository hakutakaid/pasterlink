# Import yang diperlukan
import os

# Path ke file input dan output
input_path = "hasil.txt"  # Ganti dengan path ke file aslinya jika diperlukan
output_path = "hasil_terurut.txt"

# Baca dan proses isi file
with open(input_path, "r", encoding="utf-8") as file:
    lines = file.read().strip().split("\n")

# Hapus baris kosong
cleaned_lines = [line.strip() for line in lines if line.strip() != ""]

# Pasangkan nama folder dan link-nya (setiap 2 baris)
paired_entries = [(cleaned_lines[i], cleaned_lines[i + 1]) for i in range(0, len(cleaned_lines), 2)]

# Urutkan berdasarkan nama folder (abaikan huruf besar/kecil)
sorted_entries = sorted(paired_entries, key=lambda x: x[0].lower())

# Format ulang sebagai teks
sorted_text = "\n\n".join(f"{name}\n{link}" for name, link in sorted_entries)

# Simpan hasil ke file baru
with open(output_path, "w", encoding="utf-8") as file:
    file.write(sorted_text)

print(f"File berhasil disimpan sebagai: {output_path}")