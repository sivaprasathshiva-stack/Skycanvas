# Product Requirements Document (PRD)

## Project Name

**SkyCanvas**

## Tagline

Turn Any Projector Into A Window To The Universe.

**Alternative taglines:**
- Your ceiling. The universe.
- Experience the night sky from anywhere.
- The world's first AI-powered immersive projection platform.

## Vision

Create the world's most immersive projection platform that transforms any projector, TV, or large display into a dynamic, AI-powered environment.

The first experience is the **Live Sky**.

Future experiences include oceans, forests, meditation, space travel, education, weather visualization, and more.

## Problem Statement

Today's galaxy projectors have major limitations:

- Decorative rather than scientifically accurate
- Cannot display the current sky
- Cannot adapt to the user's location
- Not interactive
- No AI
- No personalization
- Require dedicated hardware

Professional planetarium systems exist but are extremely expensive and intended for museums and educational institutions.

**There is no consumer software that allows users to transform an existing projector into a live, intelligent planetarium.**

## Opportunity

Millions of people already own:

- Home projectors
- Portable projectors
- Smart TVs
- Laptops
- Tablets

Instead of selling hardware first, SkyCanvas becomes the software layer powering immersive projection experiences.

## Target Users

### Primary
- Astronomy enthusiasts
- Families
- Parents with children
- Home theater owners
- Smart home users
- Meditation enthusiasts
- Teachers
- Schools

### Secondary
- Hotels
- Resorts
- Planetariums
- Science museums
- Hospitals
- Therapy centers
- Cafés
- Event planners

## User Personas

### Persona 1: Raj
- Age 34
- Owns a projector
- Loves astronomy
- Wants realistic stars

### Persona 2: Priya
- Mother of two
- Wants educational bedtime experiences

### Persona 3: Michael
- Uses meditation apps
- Wants relaxing immersive environments

## Product Goals

### Primary Goal
Deliver a magical immersive experience within 30 seconds of opening the app.

### Secondary Goals
- No additional hardware required
- Works with existing projectors
- AI-powered
- Scientifically accurate
- Beautiful visuals

### Non Goals (MVP)
- Building custom hardware
- Multiplayer
- VR
- AR glasses
- Professional observatory features

## Platforms

### Desktop
- Windows
- macOS
- Linux

### Mobile
- Android
- iPhone

### TV
- Android TV
- Apple TV
- Google TV

### Later
- Vision Pro
- Meta Quest

## Supported Connections

- HDMI
- Chromecast
- AirPlay
- Miracast
- Wireless Display

## User Journey

1. User downloads app
2. Opens app
3. App detects displays
4. User selects projector
5. Projector connects
6. AI asks: **"What would you like to experience tonight?"**
7. User says: **"Show tonight's sky"**
8. Projection begins

## Core Experience

User walks into bedroom. Turns off lights.

**Ceiling becomes today's sky.**

- Moon is accurate
- Stars are accurate
- Planets are accurate
- ISS moves overhead
- Satellites move
- Meteor showers appear when active
- Weather affects visibility

## Features

### Feature 1: Live Sky

**Uses:**
- GPS
- Date
- Time
- Weather

**Produces:**
- Accurate sky

### Feature 2: Historical Sky Replay

**Examples:**
- Wedding
- Birthday
- Proposal
- Graduation
- Baby birth

The app recreates the exact sky.

### Feature 3: Future Sky

Want to know the sky next Saturday? Simply change the date.

### Feature 4: Constellation Mode

- Labels appear
- Animations
- Stories

### Feature 5: Planet Mode

- Highlight planets
- Show distances
- Interesting facts

### Feature 6: Satellite Tracking

- ISS
- Starlink
- Hubble
- Weather satellites

### Feature 7: Meteor Showers

- Automatic alerts
- Live countdown
- Peak prediction

### Feature 8: Moon Mode

- Current phase
- Rise time
- Set time
- Surface details

### Feature 9: Deep Space

- Nebulae
- Galaxies
- Black holes

### Feature 10: AI Astronomy Guide

Ask: **"What is that star?"**
AI answers.

### Feature 11: Voice Control

- Show Jupiter
- Zoom
- Pause
- Night mode

### Feature 12: Sleep Mode

- Stars slowly rotate
- Brightness decreases
- Ambient music
- Timer

### Feature 13: Kids Mode

- Animated constellations
- Space stories
- Interactive quizzes

### Feature 14: Educational Mode

- Teacher dashboard
- Lesson plans
- Solar system
- Planet comparison

### Feature 15: Weather Awareness

- Cloudy? Show clouds
- Clear? Show Milky Way

### Feature 16: Location Awareness

Automatically detects:
- Country
- City
- Latitude
- Longitude

### Feature 17: Display Discovery

Automatically discovers:
- Chromecast
- Apple TV
- Projectors
- TVs

### Feature 18: Second Screen

Phone becomes remote.

### Feature 19: Multi-room

- Bedroom
- Living room
- Office

### Feature 20: AI Personalization

> Good evening Siva.
> 
> Tonight Jupiter is especially bright.
> 
> The ISS passes in 17 minutes.
> 
> Would you like a reminder?

## Premium Experiences

- Northern Lights
- Ocean
- Rainforest
- Meditation
- Fireplace
- Mountains
- Underwater
- Rain
- Snow
- Mars
- Moon Landing
- Apollo Missions
- Spacewalk
- Milky Way Journey
- Black Hole Tour

## AI Features

- Daily sky summary
- Night recommendations
- Space news
- Voice assistant
- Image recognition
  - Point phone
  - AI identifies object

## Architecture

```
Mobile Apps / Desktop Apps / TV Apps
            ↓
    SkyCanvas Cloud
            ↓
    Astronomy Engine
            ↓
       AI Engine
            ↓
   Rendering Engine
            ↓
       Projector
```

## Technology Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter |
| **Desktop** | Flutter / Tauri |
| **Backend** | FastAPI, Python |
| **Rendering** | Unity or Unreal Engine |
| **Astronomy** | Skyfield, Stellarium Engine, NASA SPICE |
| **Satellite Tracking** | SGP4, TLE Data |
| **Maps** | Cesium |
| **AI** | OpenAI, Claude, Gemini |
| **Database** | PostgreSQL, Redis |
| **Cloud** | AWS |

## Monetization

| Tier | Price | Features |
|------|-------|----------|
| **Free** | Free | Basic sky |
| **Premium** | ₹299/month | Full features |
| **Family** | ₹499/month | Multi-user |
| **Education** | ₹999/month | Classroom features |
| **Hardware** | Later | Dedicated devices |

## Success Metrics

1. First projection completed in under 2 minutes
2. Daily active usage during evenings
3. 30-day retention
4. Subscription conversion rate
5. Average session length
6. Customer satisfaction (NPS)

## Risks

- Wireless casting compatibility across different projector brands
- Brightness and image quality vary greatly between projectors
- Users in cloudy locations may expect to see the actual sky rather than an astronomically accurate simulation
- Licensing and long-term maintenance of astronomy datasets and AI services
- Performance optimization across mobile, desktop, and TV platforms
