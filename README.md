# 🌟 Astro App - Personal Astrologer

A mobile application (iOS & Android) that provides personalized daily astrological guidance based on your natal chart and current planetary transits.

## Features

- **Personalized Daily Guidance**: Receive daily insights based on your unique natal chart
- **Multiple Life Areas**: Get guidance for health, career, business, love, partnerships, and personal growth
- **Concern Tracking**: Input current life concerns and receive focused guidance
- **AI-Powered Insights**: Advanced AI interprets astrological data into actionable advice
- **Push Notifications**: Get notified when your daily guidance is ready
- **Multi-language Support**: Available in English and Romanian

## Tech Stack

### Backend
- **Framework**: NestJS (Node.js + TypeScript)
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: JWT with refresh tokens
- **External APIs**: 
  - AstrologyAPI.com (natal charts, transits)
  - OpenAI GPT-4 (AI interpretations)
- **Containerization**: Docker + Docker Compose

### Mobile (Coming Soon)
- **Framework**: Flutter (iOS & Android)

## Getting Started

### Prerequisites

- Node.js 20+
- Docker & Docker Compose
- PostgreSQL (or use Docker)
- API keys for:
  - AstrologyAPI.com
  - OpenAI

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/alexgro171-coder/astro-app.git
   cd astro-app
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. **Start the database**
   ```bash
   docker compose up -d postgres redis
   ```

4. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   ```

5. **Run database migrations**
   ```bash
   npx prisma migrate dev
   npx prisma generate
   ```

6. **Start the development server**
   ```bash
   npm run start:dev
   ```

7. **Access the API**
   - API: http://localhost:3000/api/v1
   - Swagger Docs: http://localhost:3000/docs

### Docker Deployment

```bash
# Build and start all services
docker compose up -d --build

# View logs
docker compose logs -f backend
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/signup` - Register new user
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout

### User Profile
- `GET /api/v1/me` - Get current user profile
- `PUT /api/v1/me` - Update profile
- `POST /api/v1/me/birth-data` - Set birth data
- `POST /api/v1/me/device` - Register push notification device
- `DELETE /api/v1/me` - Delete account

### Concerns
- `POST /api/v1/concerns` - Create new concern
- `GET /api/v1/concerns` - List all concerns
- `GET /api/v1/concerns/active` - Get active concern
- `PATCH /api/v1/concerns/:id` - Update concern
- `POST /api/v1/concerns/:id/resolve` - Mark as resolved

### Daily Guidance
- `GET /api/v1/guidance/today` - Get today's guidance
- `GET /api/v1/guidance/history` - Get guidance history
- `POST /api/v1/guidance/:id/feedback` - Submit feedback
- `POST /api/v1/guidance/regenerate` - Force regenerate

### Astrology
- `GET /api/v1/astrology/geo-search` - Search locations
- `GET /api/v1/astrology/natal-chart` - Get natal chart
- `GET /api/v1/astrology/transits/today` - Get today's transits

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | PostgreSQL connection string |
| `JWT_SECRET` | Secret for access tokens |
| `JWT_REFRESH_SECRET` | Secret for refresh tokens |
| `ASTROLOGY_API_USER_ID` | AstrologyAPI.com user ID |
| `ASTROLOGY_API_KEY` | AstrologyAPI.com API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `OPENAI_MODEL` | OpenAI model (default: gpt-4-turbo-preview) |
| `FIREBASE_*` | Firebase configuration for push notifications |

## Project Structure

```
astro-app/
├── backend/
│   ├── src/
│   │   ├── auth/           # Authentication module
│   │   ├── users/          # User management
│   │   ├── astrology/      # AstrologyAPI integration
│   │   ├── ai/             # OpenAI integration
│   │   ├── concerns/       # Concern management
│   │   ├── guidance/       # Daily guidance engine
│   │   ├── notifications/  # Push notifications
│   │   ├── prisma/         # Database service
│   │   └── health/         # Health check endpoint
│   ├── prisma/
│   │   └── schema.prisma   # Database schema
│   └── Dockerfile
├── mobile/                 # Flutter app (coming soon)
├── docker-compose.yml
└── README.md
```

## License

Private - All rights reserved

## Contact

Alexandru Groseanu

