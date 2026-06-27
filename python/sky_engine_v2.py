#!/usr/bin/env python3
"""
SkyCanvas Astronomy Engine v2
Enhanced version with full star catalog support
"""

import json
import sys
import os
from datetime import datetime
from skyfield.api import load, Star, wgs84
from skyfield import almanac
import pytz
import math


class SkyEngineV2:
    """Enhanced astronomy calculation engine with full catalog"""

    def __init__(self, use_full_catalog=True):
        """Initialize the sky engine"""
        self.ts = load.timescale()
        self.eph = load('de421.bsp')
        self.earth = self.eph['earth']
        self.sun = self.eph['sun']
        self.moon = self.eph['moon']

        # Planets
        self.planets = {
            'Mercury': self.eph['mercury'],
            'Venus': self.eph['venus'],
            'Mars': self.eph['mars'],
            'Jupiter': self.eph['jupiter barycenter'],
            'Saturn': self.eph['saturn barycenter'],
        }

        # Load star catalog
        self.stars_catalog = []
        if use_full_catalog:
            self._load_star_catalog()

    def _load_star_catalog(self):
        """Load stars from JSON catalog"""
        catalog_file = 'stars.json'

        if not os.path.exists(catalog_file):
            print(f"Warning: Star catalog not found: {catalog_file}")
            print("Run: python star_catalog.py to download and parse catalog")
            return

        with open(catalog_file, 'r') as f:
            self.stars_catalog = json.load(f)

        print(f"Loaded {len(self.stars_catalog)} stars from catalog")

    def calculate_stars(self, latitude, longitude, year, month, day, hour, minute,
                       max_magnitude=6.0, min_altitude=0.0):
        """
        Calculate visible stars

        Args:
            max_magnitude: Dimmest stars to show (6.0 = naked eye)
            min_altitude: Minimum altitude in degrees (0 = horizon)

        Returns:
            list: Visible stars with positions
        """
        observer = self.earth + wgs84.latlon(latitude, longitude)
        t = self.ts.utc(year, month, day, hour, minute)

        visible_stars = []

        for star_data in self.stars_catalog:
            if star_data['magnitude'] > max_magnitude:
                continue

            # Create star object
            star = Star(
                ra_hours=(star_data['ra'],),
                dec_degrees=(star_data['dec'],)
            )

            # Calculate position
            astrometric = observer.at(t).observe(star)
            alt, az, distance = astrometric.apparent().altaz()

            if alt.degrees >= min_altitude:
                visible_stars.append({
                    'name': star_data['name'],
                    'magnitude': star_data['magnitude'],
                    'altitude': alt.degrees,
                    'azimuth': az.degrees,
                    'color': star_data['color'],
                    'spectral': star_data.get('spectral', ''),
                    'type': 'star'
                })

        return visible_stars

    def calculate_sky_full(self, latitude, longitude, year, month, day, hour, minute,
                          max_magnitude=6.0):
        """
        Calculate complete sky view

        Returns full JSON with all objects
        """
        observer = self.earth + wgs84.latlon(latitude, longitude)
        t = self.ts.utc(year, month, day, hour, minute)

        # Calculate planets
        planets_data = []
        for name, planet in self.planets.items():
            astrometric = observer.at(t).observe(planet)
            alt, az, distance = astrometric.apparent().altaz()

            if alt.degrees > 0:
                planets_data.append({
                    'name': name,
                    'altitude': alt.degrees,
                    'azimuth': az.degrees,
                    'distance_au': distance.au,
                    'type': 'planet'
                })

        # Calculate Moon
        astrometric_moon = observer.at(t).observe(self.moon)
        alt_moon, az_moon, distance_moon = astrometric_moon.apparent().altaz()

        sun_astrometric = observer.at(t).observe(self.sun)
        phase_angle = self._calculate_phase_angle(astrometric_moon, sun_astrometric)
        illumination = (1 + math.cos(math.radians(phase_angle))) / 2

        moon_data = {
            'name': 'Moon',
            'altitude': alt_moon.degrees,
            'azimuth': az_moon.degrees,
            'distance_km': distance_moon.km,
            'phase_angle': phase_angle,
            'illumination': illumination * 100,
            'type': 'moon'
        }

        # Calculate Sun
        alt_sun, az_sun, distance_sun = sun_astrometric.apparent().altaz()
        sun_data = {
            'name': 'Sun',
            'altitude': alt_sun.degrees,
            'azimuth': az_sun.degrees,
            'distance_au': distance_sun.au,
            'type': 'sun'
        }

        # Calculate stars
        stars = self.calculate_stars(
            latitude, longitude, year, month, day, hour, minute,
            max_magnitude=max_magnitude
        )

        return {
            'timestamp': t.utc_iso(),
            'observer': {
                'latitude': latitude,
                'longitude': longitude
            },
            'objects': {
                'sun': sun_data,
                'moon': moon_data,
                'planets': planets_data,
                'stars': stars
            },
            'statistics': {
                'visible_stars': len(stars),
                'visible_planets': len(planets_data),
                'sun_visible': alt_sun.degrees > 0,
                'moon_visible': alt_moon.degrees > 0,
            }
        }

    def _calculate_phase_angle(self, moon_astrometric, sun_astrometric):
        """Calculate the phase angle of the moon"""
        moon_pos = moon_astrometric.position.au
        sun_pos = sun_astrometric.position.au

        dot_product = sum(m * s for m, s in zip(moon_pos, sun_pos))
        moon_mag = math.sqrt(sum(x**2 for x in moon_pos))
        sun_mag = math.sqrt(sum(x**2 for x in sun_pos))

        cos_angle = dot_product / (moon_mag * sun_mag)
        cos_angle = max(-1, min(1, cos_angle))

        angle = math.degrees(math.acos(cos_angle))
        return angle


def main():
    """Command-line interface"""
    if len(sys.argv) < 7:
        print("Usage: python sky_engine_v2.py <lat> <lon> <year> <month> <day> <hour> [minute] [max_mag]")
        print("Example: python sky_engine_v2.py 28.6139 77.2090 2026 6 25 20 30 6.0")
        sys.exit(1)

    lat = float(sys.argv[1])
    lon = float(sys.argv[2])
    year = int(sys.argv[3])
    month = int(sys.argv[4])
    day = int(sys.argv[5])
    hour = int(sys.argv[6])
    minute = int(sys.argv[7]) if len(sys.argv) > 7 else 0
    max_mag = float(sys.argv[8]) if len(sys.argv) > 8 else 6.0

    print("Initializing SkyCanvas Engine v2...")
    engine = SkyEngineV2(use_full_catalog=True)

    print(f"\nCalculating sky for:")
    print(f"  Location: {lat}°, {lon}°")
    print(f"  Time: {year}-{month:02d}-{day:02d} {hour:02d}:{minute:02d} UTC")
    print(f"  Max magnitude: {max_mag}")

    # Calculate full sky
    sky_data = engine.calculate_sky_full(lat, lon, year, month, day, hour, minute, max_mag)

    # Output as JSON
    print("\n" + "="*60)
    print(json.dumps(sky_data, indent=2))
    print("="*60)

    # Summary
    stats = sky_data['statistics']
    print(f"\nVisible objects:")
    print(f"  Sun: {'Above horizon' if stats['sun_visible'] else 'Below horizon'}")
    print(f"  Moon: {sky_data['objects']['moon']['illumination']:.1f}% illuminated")
    print(f"  Planets: {stats['visible_planets']}")
    print(f"  Stars: {stats['visible_stars']}")


if __name__ == '__main__':
    main()
