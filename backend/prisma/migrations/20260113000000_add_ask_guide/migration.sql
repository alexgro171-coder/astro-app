-- CreateEnum
CREATE TYPE "AskGuideStatus" AS ENUM ('PENDING', 'READY', 'FAILED');

-- CreateTable - Ask Guide Requests (Q&A History)
CREATE TABLE "ask_guide_requests" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT,
    "status" "AskGuideStatus" NOT NULL DEFAULT 'PENDING',
    "error_msg" TEXT,
    "locale" TEXT NOT NULL DEFAULT 'en',
    "input_snapshot" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ask_guide_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable - Monthly Usage Tracking
CREATE TABLE "ask_guide_usage" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "billing_month_start" DATE NOT NULL,
    "billing_month_end" DATE NOT NULL,
    "request_count" INTEGER NOT NULL DEFAULT 0,
    "limit_count" INTEGER NOT NULL DEFAULT 40,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ask_guide_usage_pkey" PRIMARY KEY ("id")
);

-- CreateTable - $2 Add-On Purchases
CREATE TABLE "ask_guide_addons" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "billing_month_start" DATE NOT NULL,
    "billing_month_end" DATE NOT NULL,
    "purchase_id" TEXT,
    "provider" "PaymentProvider",
    "amount" INTEGER NOT NULL DEFAULT 199,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "PurchaseStatus" NOT NULL DEFAULT 'COMPLETED',
    "purchased_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ask_guide_addons_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ask_guide_requests_user_id_idx" ON "ask_guide_requests"("user_id");
CREATE INDEX "ask_guide_requests_created_at_idx" ON "ask_guide_requests"("created_at");

-- CreateIndex - Unique per user per billing month
CREATE UNIQUE INDEX "ask_guide_usage_user_id_billing_month_start_key" ON "ask_guide_usage"("user_id", "billing_month_start");
CREATE INDEX "ask_guide_usage_user_id_idx" ON "ask_guide_usage"("user_id");

-- CreateIndex
CREATE INDEX "ask_guide_addons_user_id_idx" ON "ask_guide_addons"("user_id");
CREATE UNIQUE INDEX "ask_guide_addons_user_id_billing_month_start_key" ON "ask_guide_addons"("user_id", "billing_month_start");

-- AddForeignKey
ALTER TABLE "ask_guide_requests" ADD CONSTRAINT "ask_guide_requests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ask_guide_usage" ADD CONSTRAINT "ask_guide_usage_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ask_guide_addons" ADD CONSTRAINT "ask_guide_addons_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
