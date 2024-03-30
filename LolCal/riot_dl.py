import psycopg2
import requests
import os
from tqdm import tqdm
import argparse
import json

def download_file(url, directory, filename, pbar=None, beautify=True):
    if not os.path.exists(directory):
        os.makedirs(directory)
    response = requests.get(url)
    if response.status_code == 200:
        filepath = os.path.join(directory, filename)
        if beautify:
            with open(filepath, 'w', encoding='utf-8') as file:
                json.dump(json.loads(response.content), file, ensure_ascii=False, indent=4)
        else:
            with open(filepath, 'wb') as file:
                file.write(response.content)
        if pbar:
            pbar.update(1)
    else:
        print(f"Failed to download {filename}")

def replace_modifiers(json_data):
    replacements = {
        "FlatPhysicalDamageMod": "Attack Damage",
        "FlatCritChanceMod": "Critical Chance",
        "FlatCritDamageMod": "Critical Damage",
        "PercentAttackSpeedMod": "Attack Speed",
        "FlatMagicDamageMod": "Ability Power",
        "FlatMPPoolMod": "Mana",
        "FlatHPPoolMod": "Health",
        "FlatArmorMod": "Armor",
        "FlatSpellBlockMod": "Magic Resist",
        "CooldownReduction": "Ability Haste",
        "FlatMovementSpeedMod": "Flat Movespeed",
        "PercentMovementSpeedMod": "Percent Movespeed",
        "PercentLifeStealMod": "Lifesteal",
        "FlatHPRegenMod": "Health Regen"
    }
    for item_id, item_data in json_data.get('data', {}).items():
        for stat, value in replacements.items():
            if stat in item_data.get('stats', {}):
                item_data['stats'][value] = item_data['stats'].pop(stat)
    return json_data

def process_json_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".json"):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'r', encoding='utf-8') as file:
                json_data = json.load(file)
            json_data = replace_modifiers(json_data)
            with open(filepath, 'w', encoding='utf-8') as file:
                json.dump(json_data, file, ensure_ascii=False, indent=4)
            print(f"Processed {filename}")

def download_json_and_images_with_progress(dl_images=True, beautify=True):
    print(f"Starting data download\nImage download = {dl_images}, Beautify JSON = {beautify}")
    versions_url = "https://ddragon.leagueoflegends.com/api/versions.json"
    version_response = requests.get(versions_url)
    if version_response.status_code != 200:
        print("Failed to retrieve the latest version")
        return
    latest_version = version_response.json()[0]
    print(f"Latest version: {latest_version}")
    base_url = f"http://ddragon.leagueoflegends.com/cdn/{latest_version}/data/en_US"
    downloads_dir = "downloads"
    champions_url = f"{base_url}/champion.json"
    download_file(champions_url, downloads_dir, "champion.json", beautify=beautify)
    print("Successfully downloaded champions.json!")
    items_url = f"{base_url}/item.json"
    download_file(items_url, downloads_dir, "items.json", beautify=beautify)
    print("Successfully downloaded items.json!")
    process_json_files(downloads_dir)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download LoL champions and items data and images.")
    parser.add_argument("--dl_images", type=lambda x: (str(x).lower() in ['true', '1', 'yes']), default=False, help="Whether to download images (true/false)")
    parser.add_argument("--beautify", type=lambda x: (str(x).lower() in ['true', '1', 'yes']), default=True, help="Whether to beautify JSON files (true/false)")
    args = parser.parse_args()
    download_json_and_images_with_progress(dl_images=args.dl_images, beautify=args.beautify)
    print("Successfully downloaded images and processed JSON files!")
    print("Done!")
