-- CreateEnum
CREATE TYPE "OneTimeServiceType" AS ENUM ('PERSONALITY_REPORT', 'ROMANTIC_PERSONALITY_REPORT', 'FRIENDSHIP_REPORT', 'LOVE_COMPATIBILITY_REPORT', 'ROMANTIC_FORECAST_COUPLE_REPORT', 'MOON_PHASE_REPORT');

-- CreateEnum
CREATE TYPE "ReadingStatus" AS ENUM ('PENDING', 'READY', 'FAILED');

-- AlterEnum
ALTER TYPE "AnalyticsEventType" ADD VALUE 'ONE_TIME_SERVICE_OPENED';
ALTER TYPE "AnalyticsEventType" ADD VALUE 'ONE_TIME_SERVICE_GENERATED';
ALTER TYPE "AnalyticsEventType" ADD VALUE 'ONE_TIME_SERVICE_VIEWED';

-- CreateTable
CREATE TABLE "one_time_readings" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "service_type" "OneTimeServiceType" NOT NULL,
    "locale" TEXT NOT NULL,
    "input_hash" TEXT NOT NULL,
    "status" "ReadingStatus" NOT NULL DEFAULT 'PENDING',
    "content" TEXT,
    "input_snapshot" JSONB,
    "error_msg" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "one_time_readings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "one_time_readings_user_id_idx" ON "one_time_readings"("user_id");

-- CreateIndex
CREATE INDEX "one_time_readings_service_type_locale_status_idx" ON "one_time_readings"("service_type", "locale", "status");

-- CreateIndex
CREATE UNIQUE INDEX "one_time_readings_user_id_service_type_locale_input_hash_key" ON "one_time_readings"("user_id", "service_type", "locale", "input_hash");

-- AddForeignKey
ALTER TABLE "one_time_readings" ADD CONSTRAINT "one_time_readings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

