#!/usr/bin/env python3
"""
Yale Bright Star Catalog Integration
Downloads and processes the complete catalog of 9,110 stars
"""

import json
import urllib.request
import os
from typing import List, Dict

# Yale Bright Star Catalog URL (public domain)
BSC5_URL = "http://tdc-www.harvard.edu/catalogs/bsc5.dat"
BSC5_NOTES_URL = "http://tdc-www.harvard.edu/catalogs/bsc5.readme"


class StarCatalog:
    """Manages the Yale Bright Star Catalog"""

    def __init__(self, catalog_file='bsc5.dat'):
        self.catalog_file = catalog_file
        self.stars = []

    def download_catalog(self):
        """Download the BSC5 catalog if not present"""
        if os.path.exists(self.catalog_file):
            print(f"Catalog already exists: {self.catalog_file}")
            return

        print(f"Downloading Yale Bright Star Catalog...")
        try:
            urllib.request.urlretrieve(BSC5_URL, self.catalog_file)
            print(f"Downloaded to {self.catalog_file}")
        except Exception as e:
            print(f"Error downloading catalog: {e}")
            raise

    def parse_catalog(self, max_magnitude=6.5):
        """
        Parse BSC5 catalog file

        Format (fixed-width):
        - Bytes 1-4: HR number
        - Bytes 5-14: Name
        - Bytes 76-77: RA hours
        - Bytes 78-79: RA minutes
        - Bytes 80-83: RA seconds
        - Bytes 84: Dec sign
        - Bytes 85-86: Dec degrees
        - Bytes 87-88: Dec minutes
        - Bytes 89-90: Dec seconds
        - Bytes 103-107: Visual magnitude
        - Bytes 130-147: Spectral type

        Args:
            max_magnitude: Only include stars brighter than this
        """
        if not os.path.exists(self.catalog_file):
            raise FileNotFoundError(f"Catalog not found: {self.catalog_file}")

        print(f"Parsing catalog (mag < {max_magnitude})...")
        self.stars = []

        with open(self.catalog_file, 'r', encoding='latin-1') as f:
            for line in f:
                if len(line) < 197:
                    continue

                try:
                    # Parse magnitude
                    mag_str = line[102:107].strip()
                    if not mag_str:
                        continue

                    magnitude = float(mag_str)
                    if magnitude > max_magnitude:
                        continue

                    # Parse HR number
                    hr_num = line[0:4].strip()

                    # Parse RA (Right Ascension)
                    ra_hours = int(line[75:77])
                    ra_minutes = int(line[77:79])
                    ra_seconds = float(line[79:83])
                    ra_decimal = ra_hours + ra_minutes / 60.0 + ra_seconds / 3600.0

                    # Parse Dec (Declination)
                    dec_sign = line[83]
                    dec_degrees = int(line[84:86])
                    dec_minutes = int(line[86:88])
                    dec_seconds = float(line[88:90])
                    dec_decimal = dec_degrees + dec_minutes / 60.0 + dec_seconds / 3600.0
                    if dec_sign == '-':
                        dec_decimal = -dec_decimal

                    # Parse spectral type (for color)
                    spectral = line[129:147].strip()
                    color = self._spectral_to_color(spectral)

                    # Common star name (if available)
                    name = line[4:14].strip() or f"HR {hr_num}"

                    self.stars.append({
                        'hr': hr_num,
                        'name': name,
                        'ra': ra_decimal,
                        'dec': dec_decimal,
                        'magnitude': magnitude,
                        'spectral': spectral[:3] if spectral else 'A0',
                        'color': color
                    })

                except (ValueError, IndexError) as e:
                    continue

        print(f"Parsed {len(self.stars)} stars")
        return self.stars

    def _spectral_to_color(self, spectral: str) -> str:
        """Convert spectral type to color"""
        if not spectral:
            return 'white'

        spectral_class = spectral[0].upper() if spectral else 'A'

        color_map = {
            'O': 'blue',      # Hot blue stars
            'B': 'blue',      # Blue-white stars
            'A': 'white',     # White stars (Vega, Sirius)
            'F': 'white',     # Yellow-white stars
            'G': 'yellow',    # Yellow stars (Sun)
            'K': 'orange',    # Orange stars (Arcturus)
            'M': 'red',       # Red stars (Betelgeuse)
        }

        return color_map.get(spectral_class, 'white')

    def save_json(self, output_file='stars.json'):
        """Save parsed stars to JSON"""
        with open(output_file, 'w') as f:
            json.dump(self.stars, f, indent=2)
        print(f"Saved {len(self.stars)} stars to {output_file}")

    def get_brightest(self, count=100):
        """Get N brightest stars"""
        sorted_stars = sorted(self.stars, key=lambda s: s['magnitude'])
        return sorted_stars[:count]


def main():
    """Download and parse the star catalog"""
    catalog = StarCatalog()

    # Download if needed
    catalog.download_catalog()

    # Parse catalog (stars brighter than magnitude 6.5 = naked eye limit)
    catalog.parse_catalog(max_magnitude=6.5)

    # Save to JSON
    catalog.save_json('stars.json')

    # Show statistics
    print(f"\nCatalog Statistics:")
    print(f"  Total stars: {len(catalog.stars)}")

    colors = {}
    for star in catalog.stars:
        color = star['color']
        colors[color] = colors.get(color, 0) + 1

    print(f"  By color:")
    for color, count in sorted(colors.items(), key=lambda x: -x[1]):
        print(f"    {color}: {count}")

    # Show brightest 10
    print(f"\n10 Brightest Stars:")
    for star in catalog.get_brightest(10):
        print(f"  {star['name']:20s} mag {star['magnitude']:5.2f}  {star['color']:10s}")


if __name__ == '__main__':
    main()
