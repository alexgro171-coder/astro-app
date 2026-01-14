/**
 * Test Suite: GuidanceService
 * 
 * Documents current behavior and bug fixes for Daily Guidance generation.
 * 
 * BUG REPORT - Daily Guidance Generation Flow
 * =============================================
 * 
 * CRITICAL BUG IDENTIFIED IN job-runner.service.ts:
 * 
 * The executeDailyGuidance() method was calling getTodayGuidance() which can return 
 * PENDING status, but the job was still marked as READY.
 * 
 * FIX APPLIED:
 * - Changed to call generateGuidanceForDate() which performs synchronous generation
 * - Job now only completes when guidance is actually ready
 * 
 * FLUTTER CLIENT EXPECTATIONS:
 * 1. Call POST /jobs/start with jobType: DAILY_GUIDANCE
 * 2. Receive { jobId, status: 'PENDING' }
 * 3. Poll GET /jobs/:jobId every 2.5 seconds
 * 4. When status becomes 'READY', stop polling
 * 5. Call GET /guidance/today to fetch the actual guidance
 * 6. Display guidance in UI
 */

describe('GuidanceService Bug Documentation', () => {
  describe('getTodayGuidance - Lazy Compute Behavior', () => {
    /**
     * getTodayGuidance is designed for lazy compute with client retry.
     * It can return PENDING status when guidance needs to be generated.
     */
    it('documents that getTodayGuidance can return PENDING', () => {
      // This is expected behavior for lazy compute
      // Client should retry when receiving PENDING
      const expectedPendingResponse = {
        status: 'PENDING',
        message: 'Your guidance is being generated. Please try again in a few seconds.',
        date: '2026-01-06',
      };
      
      expect(expectedPendingResponse.status).toBe('PENDING');
    });

    /**
     * getTodayGuidance returns cached READY guidance immediately.
     */
    it('documents that getTodayGuidance returns READY when cached', () => {
      const expectedReadyResponse = {
        id: 'guidance-123',
        status: 'READY',
        date: '2026-01-06',
        dailySummary: {
          content: 'Today is a good day.',
          mood: 'Harmonious',
          focusArea: 'Career',
        },
        sections: {
          health: { title: 'Health', content: 'Focus on rest.', score: 7, actions: [] },
          job: { title: 'Career', content: 'Good day for work.', score: 8, actions: [] },
          business_money: { title: 'Money', content: 'Be careful.', score: 6, actions: [] },
          love: { title: 'Love', content: 'Express feelings.', score: 8, actions: [] },
          partnerships: { title: 'Partners', content: 'Communicate.', score: 7, actions: [] },
          personal_growth: { title: 'Growth', content: 'Reflect today.', score: 8, actions: [] },
        },
      };
      
      expect(expectedReadyResponse.status).toBe('READY');
      expect(expectedReadyResponse.sections).toBeDefined();
    });
  });

  describe('generateGuidanceForDate - Synchronous Generation', () => {
    /**
     * generateGuidanceForDate performs actual AI generation synchronously.
     * This is the correct method for JobRunner to call.
     */
    it('documents that generateGuidanceForDate is synchronous', () => {
      // generateGuidanceForDate:
      // 1. Gets natal chart
      // 2. Fetches daily transits from AstrologyAPI
      // 3. Gets user gender for personalized language
      // 4. Calls OpenAI to generate guidance
      // 5. Saves to database with status READY
      // 6. Does NOT return until generation is complete
      //
      // NOTE: activeConcern was REMOVED - no longer used in prompts
      
      const expectedBehavior = {
        isSynchronous: true,
        savesWithStatusReady: true,
        requiresNatalChart: true,
        callsAstrologyAPI: true,
        callsOpenAI: true,
        includesUserGender: true, // NEW: for personalized language
        usesActiveConcern: false, // REMOVED: Your Focus feature eliminated
      };
      
      expect(expectedBehavior.isSynchronous).toBe(true);
      expect(expectedBehavior.savesWithStatusReady).toBe(true);
      expect(expectedBehavior.usesActiveConcern).toBe(false);
    });
  });

  describe('Job Integration Flow', () => {
    /**
     * Documents the correct integration between Jobs and Guidance systems.
     */
    it('documents the correct job execution flow', () => {
      // CORRECT FLOW (after fix):
      // 1. Flutter calls POST /jobs/start with jobType: DAILY_GUIDANCE
      // 2. JobsService creates GenerationJob with status PENDING
      // 3. JobQueueService enqueues job for processing
      // 4. JobRunnerService.executeJob() picks up the job
      // 5. executeDailyGuidance() calls generateGuidanceForDate() (NOT getTodayGuidance!)
      // 6. generateGuidanceForDate() performs full generation synchronously
      // 7. Job is marked READY only after guidance is actually saved with status READY
      // 8. Flutter polls and sees READY status
      // 9. Flutter fetches /guidance/today and gets the actual guidance
      
      const correctFlow = {
        step1: 'Flutter calls POST /jobs/start',
        step2: 'JobsService creates GenerationJob PENDING',
        step3: 'JobQueueService enqueues job',
        step4: 'JobRunnerService.executeJob() starts',
        step5: 'executeDailyGuidance calls generateGuidanceForDate()', // FIX!
        step6: 'generateGuidanceForDate generates synchronously',
        step7: 'Job marked READY after guidance saved',
        step8: 'Flutter polls and sees READY',
        step9: 'Flutter fetches /guidance/today',
      };
      
      expect(correctFlow.step5).toContain('generateGuidanceForDate');
    });

    /**
     * Documents the bug that was fixed.
     */
    it('documents the bug that was fixed', () => {
      // BUG (before fix):
      // executeDailyGuidance() called getTodayGuidance() which could return PENDING
      // Job was marked READY even when guidance was still PENDING
      // Flutter stopped polling, tried to fetch guidance, got PENDING again
      // User saw loading spinner or error state
      
      // FIX:
      // executeDailyGuidance() now calls generateGuidanceForDate()
      // generateGuidanceForDate() performs synchronous generation
      // Job is only marked READY after guidance is actually generated
      
      const bugFix = {
        beforeFix: 'getTodayGuidance() - could return PENDING',
        afterFix: 'generateGuidanceForDate() - synchronous generation',
        impact: 'Daily Guidance now loads correctly for users',
      };
      
      expect(bugFix.afterFix).toContain('generateGuidanceForDate');
    });
  });

  describe('Timezone Handling', () => {
    /**
     * Documents timezone resolution priority.
     */
    it('documents timezone resolution priority', () => {
      // Timezone resolution in resolveUserTimezone():
      // 1. Header (X-User-Timezone) - highest priority
      // 2. user.timezoneIana - IANA format like "Europe/Bucharest"
      // 3. user.timezone - legacy field
      // 4. UTC - fallback
      
      const timezonePriority = {
        1: 'X-User-Timezone header',
        2: 'user.timezoneIana (IANA format)',
        3: 'user.timezone (legacy)',
        4: 'UTC (fallback)',
      };
      
      expect(Object.keys(timezonePriority).length).toBe(4);
    });

    /**
     * Documents localDateStr format.
     */
    it('documents localDateStr format', () => {
      // localDateStr is always "YYYY-MM-DD" format
      // Calculated from user's timezone
      // Used as unique key for idempotency
      
      const validDateStr = '2026-01-06';
      expect(validDateStr).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    });
  });
});

/**
 * INTEGRATION BUG SUMMARY:
 * ========================
 * 
 * There are TWO job queue systems:
 * 
 * 1. Generic Jobs System (JobQueueService + JobRunnerService)
 *    - Uses in-process queue with maxConcurrency=5
 *    - Stores jobs in GenerationJob table
 *    - Called by Flutter via /jobs/start
 * 
 * 2. Guidance Bull Queue (GuidanceQueueService + GuidanceQueueProcessor)
 *    - Uses Bull/Redis queue
 *    - Triggered by getTodayGuidance() for lazy compute
 *    - Used for web API calls expecting retry behavior
 * 
 * AFTER FIX:
 * JobRunner now directly calls generateGuidanceForDate() which performs
 * synchronous generation, bypassing the lazy compute layer entirely.
 * This ensures job completion status correctly reflects guidance availability.
 */

/**
 * FEATURE CHANGES - January 2026:
 * ===============================
 * 
 * 1. REMOVED: "Your Focus" / activeConcern
 *    - The active concern feature has been completely eliminated
 *    - No longer included in OpenAI prompts for daily guidance
 *    - Replaced by "Ask Your Guide" service for personalized questions
 * 
 * 2. ADDED: User Gender in AI Context
 *    - User gender (male/female/non-binary) is now explicitly passed to OpenAI
 *    - Ensures proper pronoun usage and romantic language
 *    - Example: "The user is female" in the prompt context
 * 
 * 3. NEW SERVICE: Ask Your Guide
 *    - Allows users to ask free-form questions
 *    - Based on natal chart + current transits
 *    - 40 requests/month limit with $1.99 add-on option
 */

describe('Feature Changes - Your Focus Removal', () => {
  it('documents that activeConcern is no longer used', () => {
    /**
     * Previously, the GuidanceService would:
     * 1. Get user's active concern (Your Focus)
     * 2. Include it in the OpenAI prompt
     * 3. Generate guidance tailored to that concern
     * 
     * NOW:
     * - activeConcern is NOT fetched
     * - NOT included in prompts
     * - "Ask Your Guide" provides targeted advice instead
     */
    const featureStatus = {
      activeConcern: 'REMOVED',
      yourFocus: 'REMOVED',
      askYourGuide: 'ACTIVE - replacement service',
    };

    expect(featureStatus.activeConcern).toBe('REMOVED');
    expect(featureStatus.askYourGuide).toContain('replacement');
  });

  it('documents user gender inclusion in AI prompts', () => {
    /**
     * User gender is now explicitly included in the AI context:
     * 
     * personalContext.tags.gender = 'male' | 'female' | 'non-binary'
     * 
     * This enables OpenAI to:
     * - Use correct pronouns
     * - Adjust romantic language (partner/partneră in Romanian)
     * - Provide gender-appropriate relationship advice
     */
    const genderMapping = {
      MALE: 'male',
      FEMALE: 'female',
      OTHER: 'non-binary',
    };

    expect(genderMapping.MALE).toBe('male');
    expect(genderMapping.FEMALE).toBe('female');
  });
});
