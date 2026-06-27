#!/usr/bin/env python3
"""
SkyCanvas Astronomy Engine
Calculates positions of stars, planets, and other celestial objects
"""

import json
import sys
from datetime import datetime
from skyfield.api import load, Star, wgs84
from skyfield import almanac
import pytz
import math


class SkyEngine:
    """Main astronomy calculation engine"""

    def __init__(self):
        """Initialize the sky engine with ephemeris data"""
        # Load planetary ephemeris (DE421 is smaller, good for 1900-2050)
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

    def calculate_sky(self, latitude, longitude, year, month, day, hour, minute):
        """
        Calculate sky for given location and time

        Args:
            latitude: Observer latitude in degrees
            longitude: Observer longitude in degrees
            year, month, day, hour, minute: Local time

        Returns:
            dict: Sky data with stars and planets
        """
        # Create observer location
        observer = self.earth + wgs84.latlon(latitude, longitude)

        # Create time (assuming UTC for now - we'll add timezone handling later)
        t = self.ts.utc(year, month, day, hour, minute)

        # Calculate planets
        planets_data = []
        for name, planet in self.planets.items():
            astrometric = observer.at(t).observe(planet)
            alt, az, distance = astrometric.apparent().altaz()

            if alt.degrees > 0:  # Only include visible objects
                planets_data.append({
                    'name': name,
                    'altitude': alt.degrees,
                    'azimuth': az.degrees,
                    'distance_au': distance.au,
                    'type': 'planet'
                })

        # Calculate Moon
        astrometric = observer.at(t).observe(self.moon)
        alt, az, distance = astrometric.apparent().altaz()

        # Calculate moon phase
        sun_astrometric = observer.at(t).observe(self.sun)
        phase_angle = self._calculate_phase_angle(astrometric, sun_astrometric)
        illumination = (1 + math.cos(math.radians(phase_angle))) / 2

        moon_data = {
            'name': 'Moon',
            'altitude': alt.degrees,
            'azimuth': az.degrees,
            'distance_km': distance.km,
            'phase_angle': phase_angle,
            'illumination': illumination * 100,  # Percentage
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

        return {
            'timestamp': t.utc_iso(),
            'observer': {
                'latitude': latitude,
                'longitude': longitude
            },
            'objects': {
                'sun': sun_data,
                'moon': moon_data,
                'planets': planets_data
            }
        }

    def calculate_stars(self, latitude, longitude, year, month, day, hour, minute, max_magnitude=6.0):
        """
        Calculate visible stars for given location and time

        Args:
            latitude, longitude: Observer position
            year, month, day, hour, minute: Time
            max_magnitude: Dimmest stars to include (6.0 = naked eye limit)

        Returns:
            list: Star positions
        """
        observer = self.earth + wgs84.latlon(latitude, longitude)
        t = self.ts.utc(year, month, day, hour, minute)

        # For v0.1, we'll return a sample of bright stars
        # In v0.2, we'll load from Yale Bright Star Catalog

        # Sample bright stars (magnitude, RA hours, Dec degrees, name, color)
        bright_stars = [
            (-1.46, 6.752, -16.716, "Sirius", "white"),
            (-0.72, 14.660, 19.183, "Arcturus", "orange"),
            (-0.27, 14.263, -60.835, "Alpha Centauri", "yellow"),
            (0.03, 18.616, 38.783, "Vega", "white"),
            (0.08, 5.242, 45.998, "Capella", "yellow"),
            (0.12, 5.439, -8.201, "Rigel", "blue"),
            (0.34, 7.655, 5.225, "Procyon", "white"),
            (0.42, 14.665, -62.679, "Hadar", "blue"),
            (0.50, 5.919, 7.407, "Betelgeuse", "red"),
            (0.60, 12.442, -63.099, "Acrux", "blue"),
            (0.76, 20.691, 45.280, "Deneb", "white"),
            (0.85, 12.263, -59.689, "Mimosa", "blue"),
            (0.96, 3.882, -40.305, "Achernar", "blue"),
            (1.04, 16.490, -26.432, "Antares", "red"),
            (1.14, 7.757, 28.026, "Pollux", "orange"),
        ]

        stars_data = []

        for mag, ra_hours, dec_deg, name, color in bright_stars:
            if mag > max_magnitude:
                continue

            # Create star object
            star = Star(ra_hours=(ra_hours,), dec_degrees=(dec_deg,))

            # Calculate position
            astrometric = observer.at(t).observe(star)
            alt, az, distance = astrometric.apparent().altaz()

            if alt.degrees > 0:  # Only visible stars
                stars_data.append({
                    'name': name,
                    'magnitude': mag,
                    'altitude': alt.degrees,
                    'azimuth': az.degrees,
                    'color': color,
                    'type': 'star'
                })

        return stars_data

    def _calculate_phase_angle(self, moon_astrometric, sun_astrometric):
        """Calculate the phase angle of the moon"""
        # Get positions
        moon_pos = moon_astrometric.position.au
        sun_pos = sun_astrometric.position.au

        # Calculate angle
        dot_product = sum(m * s for m, s in zip(moon_pos, sun_pos))
        moon_mag = math.sqrt(sum(x**2 for x in moon_pos))
        sun_mag = math.sqrt(sum(x**2 for x in sun_pos))

        cos_angle = dot_product / (moon_mag * sun_mag)
        cos_angle = max(-1, min(1, cos_angle))  # Clamp to [-1, 1]

        angle = math.degrees(math.acos(cos_angle))
        return angle


def main():
    """Command-line interface for testing"""
    if len(sys.argv) < 7:
        print("Usage: python sky_engine.py <lat> <lon> <year> <month> <day> <hour> [minute]")
        print("Example: python sky_engine.py 28.6139 77.2090 2026 6 25 20 30")
        sys.exit(1)

    lat = float(sys.argv[1])
    lon = float(sys.argv[2])
    year = int(sys.argv[3])
    month = int(sys.argv[4])
    day = int(sys.argv[5])
    hour = int(sys.argv[6])
    minute = int(sys.argv[7]) if len(sys.argv) > 7 else 0

    print("Initializing SkyCanvas Engine...")
    engine = SkyEngine()

    print(f"\nCalculating sky for:")
    print(f"  Location: {lat}°, {lon}°")
    print(f"  Time: {year}-{month:02d}-{day:02d} {hour:02d}:{minute:02d} UTC")

    # Calculate celestial objects
    sky_data = engine.calculate_sky(lat, lon, year, month, day, hour, minute)

    # Calculate stars
    stars = engine.calculate_stars(lat, lon, year, month, day, hour, minute)
    sky_data['objects']['stars'] = stars

    # Output as JSON
    print("\n" + "="*60)
    print(json.dumps(sky_data, indent=2))
    print("="*60)

    # Summary
    print(f"\nVisible objects:")
    print(f"  Sun: {'Above horizon' if sky_data['objects']['sun']['altitude'] > 0 else 'Below horizon'}")
    print(f"  Moon: {sky_data['objects']['moon']['illumination']:.1f}% illuminated")
    print(f"  Planets: {len(sky_data['objects']['planets'])}")
    print(f"  Stars: {len(stars)}")


if __name__ == '__main__':
    main()
