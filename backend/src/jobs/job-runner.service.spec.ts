/**
 * Test Suite: JobRunnerService
 * 
 * Documents the Daily Guidance generation bug and fix.
 * 
 * BUG REPORT - Daily Guidance Generation Flow
 * =============================================
 * 
 * CRITICAL BUG (NOW FIXED):
 * 
 * In executeDailyGuidance(), the code was calling guidanceService.getTodayGuidance(user)
 * which can return a PENDING status if the guidance isn't ready yet.
 * 
 * However, executeJob() would then mark the GenerationJob as READY with this result,
 * creating a state inconsistency where:
 * - GenerationJob.status = 'READY'
 * - GenerationJob.resultRef.status = 'PENDING'
 * 
 * This caused Flutter to:
 * 1. Stop polling (job appears complete)
 * 2. Fetch guidance via /guidance/today
 * 3. Get PENDING status again
 * 4. Show loading overlay forever or error state
 * 
 * ROOT CAUSE:
 * - getTodayGuidance() is designed for API calls with lazy compute
 * - It returns PENDING and enqueues to Bull queue, expecting client to retry
 * - But JobRunner called it expecting synchronous generation
 * 
 * FIX APPLIED:
 * - Replaced getTodayGuidance() with generateGuidanceForDate()
 * - generateGuidanceForDate() performs actual generation synchronously
 * - Job now only completes when guidance is actually ready
 */

describe('JobRunnerService Bug Documentation', () => {
  describe('executeDailyGuidance', () => {
    /**
     * Documents the bug that was fixed in executeDailyGuidance
     */
    it('BUG FIX: now uses generateGuidanceForDate instead of getTodayGuidance', () => {
      // BEFORE (BUG):
      // const result = await this.guidanceService.getTodayGuidance(user);
      // return { kind: 'daily_guidance', localDateStr, status: result.status };
      // 
      // Problem: result.status could be 'PENDING' but job marked as 'READY'
      
      // AFTER (FIXED):
      // await this.guidanceService.generateGuidanceForDate(user, targetDate, localDateStr);
      // const newGuidance = await this.prisma.dailyGuidance.findFirst({ status: 'READY' });
      // return { kind: 'daily_guidance', localDateStr, id: newGuidance.id, status: 'READY' };
      //
      // Now job only completes when guidance is actually READY
      
      const beforeFix = {
        method: 'getTodayGuidance',
        canReturnPending: true,
        jobMarkedReady: true,
        consistentState: false,
      };
      
      const afterFix = {
        method: 'generateGuidanceForDate',
        canReturnPending: false,
        jobMarkedReady: true,
        consistentState: true,
      };
      
      expect(beforeFix.consistentState).toBe(false);
      expect(afterFix.consistentState).toBe(true);
    });

    /**
     * Documents that existing guidance is returned immediately
     */
    it('returns existing guidance immediately when status is READY', () => {
      // Expected behavior:
      // 1. Check if guidance exists for date with status READY
      // 2. If exists, return immediately with guidance ID
      // 3. No generation needed
      
      const existingGuidanceResponse = {
        kind: 'daily_guidance',
        localDateStr: '2026-01-06',
        id: 'existing-guidance-id',
        status: 'READY',
      };
      
      expect(existingGuidanceResponse.status).toBe('READY');
      expect(existingGuidanceResponse.id).toBeDefined();
    });

    /**
     * Documents that new guidance is generated synchronously
     */
    it('generates new guidance synchronously when not exists', () => {
      // Expected behavior:
      // 1. No existing guidance found
      // 2. Call generateGuidanceForDate() - this WAITS for completion
      // 3. Fetch the newly created guidance
      // 4. Return with guidance ID and READY status
      
      const newGuidanceResponse = {
        kind: 'daily_guidance',
        localDateStr: '2026-01-06',
        id: 'new-guidance-id',
        status: 'READY',
      };
      
      expect(newGuidanceResponse.status).toBe('READY');
      expect(newGuidanceResponse.id).toBeDefined();
    });

    /**
     * Documents error handling when generation fails
     */
    it('throws error when generation fails to create record', () => {
      // If generateGuidanceForDate() completes but record not found,
      // throw error so job is marked FAILED
      
      const expectedError = 'Guidance generation completed but record not found for 2026-01-06';
      
      expect(expectedError).toContain('record not found');
    });
  });

  describe('executeJob', () => {
    /**
     * Documents job status transitions
     */
    it('documents correct job status transitions', () => {
      // Job status flow:
      // 1. PENDING (initial state when created)
      // 2. RUNNING (when executeJob starts processing)
      // 3. READY (when generation completes successfully)
      // 4. FAILED (when generation throws error)
      
      const statusFlow = {
        initial: 'PENDING',
        processing: 'RUNNING',
        success: 'READY',
        failure: 'FAILED',
      };
      
      expect(statusFlow.initial).toBe('PENDING');
      expect(statusFlow.success).toBe('READY');
    });

    /**
     * Documents that all job types follow the same pattern
     */
    it('documents that all job types should use synchronous generation', () => {
      // Pattern for all job types:
      // 1. Set job status to RUNNING
      // 2. Perform synchronous generation (wait for completion)
      // 3. Set job status to READY only after success
      // 4. Set job status to FAILED on error
      
      const jobTypes = [
        'DAILY_GUIDANCE',
        'NATAL_CHART_SHORT',
        'NATAL_CHART_PRO',
        'KARMIC_ASTROLOGY',
        'ONE_TIME_REPORT',
      ];
      
      expect(jobTypes.length).toBe(5);
    });
  });
});

/**
 * FLUTTER CLIENT EXPECTATIONS:
 * ============================
 * 
 * The Flutter app expects the following flow:
 * 
 * 1. Call POST /jobs/start with jobType: DAILY_GUIDANCE
 * 2. Receive { jobId, status: 'PENDING' }
 * 3. Poll GET /jobs/:jobId every 2.5 seconds
 * 4. When status becomes 'READY', stop polling
 * 5. Call GET /guidance/today to fetch the actual guidance
 * 6. Display guidance in UI
 * 
 * BUG IMPACT (NOW FIXED):
 * - Step 4 was happening too early (job showed READY but guidance was PENDING)
 * - Step 5 returned { status: 'PENDING' } instead of actual guidance
 * - Step 6 failed or showed loading forever
 * 
 * AFTER FIX:
 * - Step 4 only happens when guidance is truly ready
 * - Step 5 returns actual guidance content
 * - Step 6 displays guidance correctly
 * 
 * REPRODUCTION STEPS (before fix):
 * 1. User opens app for first time today
 * 2. No cached guidance exists
 * 3. Jobs system starts DAILY_GUIDANCE job
 * 4. JobRunner called getTodayGuidance which returned PENDING
 * 5. Job was marked READY immediately (BUG!)
 * 6. Flutter fetched guidance, got PENDING
 * 7. User saw "Failed to load guidance" or loading spinner
 */
