import os

# Configurazione utente
input_dir = "/users/davidecovolo/Desktop/esd-lab/schiavoESD/ProvaConc"
output_prefix = "SCRIPT_"                          # Prefisso per i file di output
output_master_filename = "ESD_LAB.txt"       # Nome del file combinato finale

# Elaborazione delle sottocartelle
subfolders = [f.path for f in os.scandir(input_dir) if f.is_dir()]
unito_files = []

for folder in subfolders:
    folder_name = os.path.basename(folder)
    output_filename = f"{output_prefix}{folder_name}.txt"
    output_path = os.path.join(input_dir, output_filename)

    # Lista file nella sottocartella
    file_list = [f for f in os.listdir(folder) if os.path.isfile(os.path.join(folder, f))]
    file_list.sort()

    final_content = ""

    for filename in file_list:
        filepath = os.path.join(folder, filename)
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
        except Exception as e:
            content = f"[ERRORE: Impossibile leggere il file - {str(e)}]"

        final_content += f"{filename}\n{content}\n\n\n\n"

    final_content = final_content.rstrip("\n")

    with open(output_path, "w", encoding="utf-8") as out_file:
        out_file.write(final_content)

    unito_files.append(output_filename)
    print(f"Creato file: {output_filename} per la cartella {folder_name}")

# Creazione del file master combinato
master_content = ""

for unito_file in sorted(unito_files):
    filepath = os.path.join(input_dir, unito_file)
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        content = f"[ERRORE: Impossibile leggere {unito_file} - {str(e)}]"

    master_content += f"=== {unito_file} ===\n{content}\n\n\n\n\n"

master_content = master_content.rstrip("\n")

master_path = os.path.join(input_dir, output_master_filename)
with open(master_path, "w", encoding="utf-8") as master_file:
    master_file.write(master_content)

print(f"\nCreato file master combinato: {output_master_filename}")
print("Elaborazione completata!")
