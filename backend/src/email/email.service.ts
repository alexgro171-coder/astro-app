import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Resend } from 'resend';

export interface SendEmailOptions {
  to: string | string[];
  subject: string;
  html: string;
  text?: string;
}

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private readonly resend: Resend;
  private readonly fromEmail: string;
  private readonly fromName: string;
  private readonly isEnabled: boolean;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('RESEND_API_KEY');
    this.fromEmail = this.configService.get<string>('EMAIL_FROM', 'support@innerwisdomapp.com');
    this.fromName = this.configService.get<string>('EMAIL_FROM_NAME', 'Inner Wisdom');
    this.isEnabled = !!apiKey;

    if (apiKey) {
      this.resend = new Resend(apiKey);
      this.logger.log('Email service initialized with Resend');
    } else {
      this.logger.warn('RESEND_API_KEY not configured - emails will be logged only');
    }
  }

  /**
   * Send a generic email
   */
  async send(options: SendEmailOptions): Promise<boolean> {
    const { to, subject, html, text } = options;

    if (!this.isEnabled) {
      this.logger.log(`[DEV MODE] Email would be sent to: ${to}`);
      this.logger.log(`[DEV MODE] Subject: ${subject}`);
      this.logger.debug(`[DEV MODE] Content: ${text || html.substring(0, 200)}...`);
      return true;
    }

    try {
      const result = await this.resend.emails.send({
        from: `${this.fromName} <${this.fromEmail}>`,
        to: Array.isArray(to) ? to : [to],
        subject,
        html,
        text,
      });

      if (result.error) {
        this.logger.error(`Failed to send email: ${result.error.message}`);
        return false;
      }

      this.logger.log(`Email sent successfully to ${to}, id: ${result.data?.id}`);
      return true;
    } catch (error) {
      this.logger.error(`Email sending failed: ${error.message}`);
      return false;
    }
  }

  /**
   * Send OTP code for password reset
   */
  async sendPasswordResetOTP(email: string, code: string, userName?: string): Promise<boolean> {
    const name = userName || 'there';
    
    return this.send({
      to: email,
      subject: 'Your Password Reset Code - Inner Wisdom',
      html: `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f0f23;">
  <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px;">
    <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 16px; padding: 40px; border: 1px solid #2d2d5a;">
      <!-- Logo/Header -->
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #a78bfa; margin: 0; font-size: 28px;">✨ Inner Wisdom</h1>
      </div>
      
      <!-- Content -->
      <div style="color: #e2e8f0;">
        <p style="font-size: 18px; margin-bottom: 20px;">Hi ${name},</p>
        
        <p style="font-size: 16px; line-height: 1.6; margin-bottom: 30px;">
          You requested a password reset for your Inner Wisdom account. Use the code below to reset your password:
        </p>
        
        <!-- OTP Code Box -->
        <div style="background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%); border-radius: 12px; padding: 25px; text-align: center; margin: 30px 0;">
          <p style="color: #fff; font-size: 14px; margin: 0 0 10px 0; text-transform: uppercase; letter-spacing: 2px;">Your Reset Code</p>
          <p style="color: #fff; font-size: 36px; font-weight: bold; margin: 0; letter-spacing: 8px; font-family: monospace;">${code}</p>
        </div>
        
        <p style="font-size: 14px; color: #94a3b8; line-height: 1.6;">
          ⏱️ This code expires in <strong>15 minutes</strong>.<br>
          🔒 If you didn't request this, please ignore this email.
        </p>
      </div>
      
      <!-- Footer -->
      <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #2d2d5a; text-align: center;">
        <p style="color: #64748b; font-size: 12px; margin: 0;">
          © ${new Date().getFullYear()} Inner Wisdom. All rights reserved.<br>
          Your personal astrology guide.
        </p>
      </div>
    </div>
  </div>
</body>
</html>
      `,
      text: `Hi ${name},\n\nYou requested a password reset. Your code is: ${code}\n\nThis code expires in 15 minutes.\n\nIf you didn't request this, please ignore this email.\n\n- Inner Wisdom Team`,
    });
  }

  /**
   * Send welcome email to new users
   */
  async sendWelcomeEmail(email: string, userName?: string): Promise<boolean> {
    const name = userName || 'Cosmic Explorer';
    
    return this.send({
      to: email,
      subject: 'Welcome to Inner Wisdom ✨',
      html: `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f0f23;">
  <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px;">
    <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 16px; padding: 40px; border: 1px solid #2d2d5a;">
      <!-- Logo/Header -->
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #a78bfa; margin: 0; font-size: 32px;">✨ Welcome to Inner Wisdom</h1>
      </div>
      
      <!-- Content -->
      <div style="color: #e2e8f0;">
        <p style="font-size: 20px; margin-bottom: 20px;">Hi ${name}! 🌟</p>
        
        <p style="font-size: 16px; line-height: 1.8; margin-bottom: 20px;">
          We're thrilled to have you join our cosmic community! Inner Wisdom is your personal astrology guide, designed to help you navigate life's journey with the wisdom of the stars.
        </p>
        
        <!-- Features -->
        <div style="background: rgba(124, 58, 237, 0.1); border-radius: 12px; padding: 20px; margin: 25px 0;">
          <p style="color: #a78bfa; font-size: 16px; font-weight: bold; margin: 0 0 15px 0;">What awaits you:</p>
          <ul style="color: #e2e8f0; font-size: 15px; line-height: 2; margin: 0; padding-left: 20px;">
            <li>🔮 <strong>Daily Guidance</strong> - Personalized insights based on your natal chart</li>
            <li>⭐ <strong>Transit Analysis</strong> - Understand planetary influences on your day</li>
            <li>💫 <strong>Life Areas</strong> - Guidance for love, career, health & more</li>
            <li>📊 <strong>Your Natal Chart</strong> - Deep dive into your cosmic blueprint</li>
          </ul>
        </div>
        
        <p style="font-size: 16px; line-height: 1.8;">
          Open the app to receive your first daily guidance and start your journey of self-discovery!
        </p>
        
        <div style="text-align: center; margin-top: 30px;">
          <p style="color: #a78bfa; font-size: 18px; font-style: italic;">"The stars incline, they do not compel."</p>
        </div>
      </div>
      
      <!-- Footer -->
      <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #2d2d5a; text-align: center;">
        <p style="color: #64748b; font-size: 12px; margin: 0;">
          © ${new Date().getFullYear()} Inner Wisdom. All rights reserved.<br>
          Your personal astrology guide.
        </p>
      </div>
    </div>
  </div>
</body>
</html>
      `,
      text: `Hi ${name}!\n\nWelcome to Inner Wisdom! 🌟\n\nWe're thrilled to have you join our cosmic community. Inner Wisdom is your personal astrology guide, designed to help you navigate life's journey with the wisdom of the stars.\n\nWhat awaits you:\n- Daily Guidance - Personalized insights based on your natal chart\n- Transit Analysis - Understand planetary influences on your day\n- Life Areas - Guidance for love, career, health & more\n- Your Natal Chart - Deep dive into your cosmic blueprint\n\nOpen the app to receive your first daily guidance!\n\n- The Inner Wisdom Team`,
    });
  }

  /**
   * Send account deletion confirmation email
   */
  async sendAccountDeletedEmail(email: string, userName?: string): Promise<boolean> {
    const name = userName || 'there';
    
    return this.send({
      to: email,
      subject: 'Your Inner Wisdom Account Has Been Deleted',
      html: `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f0f23;">
  <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px;">
    <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 16px; padding: 40px; border: 1px solid #2d2d5a;">
      <!-- Logo/Header -->
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #a78bfa; margin: 0; font-size: 28px;">✨ Inner Wisdom</h1>
      </div>
      
      <!-- Content -->
      <div style="color: #e2e8f0;">
        <p style="font-size: 18px; margin-bottom: 20px;">Hi ${name},</p>
        
        <p style="font-size: 16px; line-height: 1.8; margin-bottom: 20px;">
          This email confirms that your Inner Wisdom account and all associated data have been permanently deleted, as requested.
        </p>
        
        <!-- Info Box -->
        <div style="background: rgba(239, 68, 68, 0.1); border-radius: 12px; padding: 20px; margin: 25px 0; border-left: 4px solid #ef4444;">
          <p style="color: #fca5a5; font-size: 15px; margin: 0; line-height: 1.6;">
            <strong>What was deleted:</strong><br>
            • Your profile and birth data<br>
            • All daily guidance history<br>
            • Natal chart interpretations<br>
            • Subscription information
          </p>
        </div>
        
        <p style="font-size: 16px; line-height: 1.8;">
          We're sorry to see you go. If you ever want to return to explore the cosmos with us again, you're always welcome to create a new account.
        </p>
        
        <p style="font-size: 16px; line-height: 1.8; color: #94a3b8;">
          If you didn't request this deletion, please contact us immediately at <a href="mailto:support@innerwisdomapp.com" style="color: #a78bfa;">support@innerwisdomapp.com</a>.
        </p>
        
        <div style="text-align: center; margin-top: 30px;">
          <p style="color: #64748b; font-size: 16px;">Wishing you well on your journey. 🌟</p>
        </div>
      </div>
      
      <!-- Footer -->
      <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #2d2d5a; text-align: center;">
        <p style="color: #64748b; font-size: 12px; margin: 0;">
          © ${new Date().getFullYear()} Inner Wisdom. All rights reserved.
        </p>
      </div>
    </div>
  </div>
</body>
</html>
      `,
      text: `Hi ${name},\n\nThis email confirms that your Inner Wisdom account and all associated data have been permanently deleted, as requested.\n\nWhat was deleted:\n- Your profile and birth data\n- All daily guidance history\n- Natal chart interpretations\n- Subscription information\n\nWe're sorry to see you go. If you ever want to return, you're always welcome to create a new account.\n\nIf you didn't request this deletion, please contact us immediately at support@innerwisdomapp.com.\n\nWishing you well on your journey.\n\n- The Inner Wisdom Team`,
    });
  }

  /**
   * Send subscription confirmation email
   */
  async sendSubscriptionConfirmation(
    email: string,
    userName: string | undefined,
    planName: string,
    expiresAt: Date,
  ): Promise<boolean> {
    const name = userName || 'there';
    const expiryDate = expiresAt.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
    
    return this.send({
      to: email,
      subject: `Your ${planName} Subscription is Active! ✨`,
      html: `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f0f23;">
  <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px;">
    <div style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 16px; padding: 40px; border: 1px solid #2d2d5a;">
      <!-- Logo/Header -->
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #a78bfa; margin: 0; font-size: 28px;">✨ Inner Wisdom</h1>
        <p style="color: #10b981; font-size: 16px; margin-top: 10px;">Subscription Confirmed!</p>
      </div>
      
      <!-- Content -->
      <div style="color: #e2e8f0;">
        <p style="font-size: 18px; margin-bottom: 20px;">Hi ${name}! 🎉</p>
        
        <p style="font-size: 16px; line-height: 1.8; margin-bottom: 20px;">
          Thank you for subscribing to <strong style="color: #a78bfa;">${planName}</strong>! Your premium features are now active.
        </p>
        
        <!-- Subscription Info Box -->
        <div style="background: rgba(16, 185, 129, 0.1); border-radius: 12px; padding: 20px; margin: 25px 0; border-left: 4px solid #10b981;">
          <p style="color: #6ee7b7; font-size: 15px; margin: 0; line-height: 1.8;">
            <strong>Plan:</strong> ${planName}<br>
            <strong>Valid until:</strong> ${expiryDate}
          </p>
        </div>
        
        <p style="font-size: 16px; line-height: 1.8;">
          Enjoy your enhanced cosmic journey with personalized guidance tailored just for you!
        </p>
      </div>
      
      <!-- Footer -->
      <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #2d2d5a; text-align: center;">
        <p style="color: #64748b; font-size: 12px; margin: 0;">
          © ${new Date().getFullYear()} Inner Wisdom. All rights reserved.<br>
          Your personal astrology guide.
        </p>
      </div>
    </div>
  </div>
</body>
</html>
      `,
      text: `Hi ${name}!\n\nThank you for subscribing to ${planName}! Your premium features are now active.\n\nPlan: ${planName}\nValid until: ${expiryDate}\n\nEnjoy your enhanced cosmic journey!\n\n- The Inner Wisdom Team`,
    });
  }
}

