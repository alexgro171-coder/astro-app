-- CreateEnum
CREATE TYPE "GenerationJobType" AS ENUM ('DAILY_GUIDANCE', 'NATAL_CHART_SHORT', 'NATAL_CHART_PRO', 'KARMIC_ASTROLOGY', 'ONE_TIME_REPORT');

-- CreateEnum
CREATE TYPE "GenerationJobStatus" AS ENUM ('PENDING', 'RUNNING', 'READY', 'FAILED');

-- CreateTable
CREATE TABLE "generation_jobs" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "job_type" "GenerationJobType" NOT NULL,
    "locale" TEXT NOT NULL,
    "input_hash" TEXT NOT NULL,
    "status" "GenerationJobStatus" NOT NULL DEFAULT 'PENDING',
    "payload" JSONB,
    "result_ref" JSONB,
    "error_msg" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "generation_jobs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "generation_jobs_user_id_idx" ON "generation_jobs"("user_id");

-- CreateIndex
CREATE INDEX "generation_jobs_job_type_status_updated_at_idx" ON "generation_jobs"("job_type", "status", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "generation_jobs_user_id_job_type_locale_input_hash_key" ON "generation_jobs"("user_id", "job_type", "locale", "input_hash");

-- AddForeignKey
ALTER TABLE "generation_jobs" ADD CONSTRAINT "generation_jobs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
