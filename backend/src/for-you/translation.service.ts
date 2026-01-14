import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import { getLanguageName } from './utils/locale.util';

const MAX_CHUNK_SIZE = 6000; // Characters per chunk for translation

@Injectable()
export class TranslationService {
  private readonly logger = new Logger(TranslationService.name);
  private readonly openai: OpenAI;

  constructor(private readonly configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  /**
   * Translate text from English to target language.
   * Skips translation if target is English.
   * Uses chunking for long texts.
   */
  async translate(
    textEnglish: string,
    targetLocale: string,
  ): Promise<string> {
    // Skip if already English
    if (targetLocale.toLowerCase() === 'en') {
      return textEnglish;
    }

    const targetLanguage = getLanguageName(targetLocale);
    this.logger.log(`Translating text to ${targetLanguage} (${targetLocale})`);

    // Check if chunking is needed
    if (textEnglish.length <= MAX_CHUNK_SIZE) {
      return this.translateChunk(textEnglish, targetLanguage);
    }

    // Split into chunks and translate each
    const chunks = this.splitIntoChunks(textEnglish, MAX_CHUNK_SIZE);
    this.logger.log(`Text split into ${chunks.length} chunks for translation`);

    const translatedChunks: string[] = [];
    for (let i = 0; i < chunks.length; i++) {
      this.logger.debug(`Translating chunk ${i + 1}/${chunks.length}`);
      const translated = await this.translateChunk(chunks[i], targetLanguage);
      translatedChunks.push(translated);
    }

    return translatedChunks.join('\n\n');
  }

  /**
   * Translate a single chunk of text.
   */
  private async translateChunk(
    text: string,
    targetLanguage: string,
  ): Promise<string> {
    try {
      const response = await this.openai.chat.completions.create({
        model: 'gpt-5-mini',
        messages: [
          {
            role: 'system',
            content: `You are a professional translator. Translate faithfully. Preserve structure, headings, bullet points, and formatting (including markdown). Do not add or remove information. Do not interpret or modify the content in any way.`,
          },
          {
            role: 'user',
            content: `Translate the following text into ${targetLanguage}. Output only the translation, nothing else:\n\n${text}`,
          },
        ],
        temperature: 0.1, // Low temperature for consistent translations
        max_tokens: 8000,
      });

      const translated = response.choices[0]?.message?.content?.trim();
      if (!translated) {
        throw new Error('Empty translation response from OpenAI');
      }

      return translated;
    } catch (error) {
      this.logger.error(
        `Translation error: ${error.message}`,
        error.stack,
      );
      throw new Error(`Translation failed: ${error.message}`);
    }
  }

  /**
   * Split text into chunks, trying to break at paragraph boundaries.
   */
  private splitIntoChunks(text: string, maxSize: number): string[] {
    const chunks: string[] = [];
    const paragraphs = text.split(/\n\n+/);

    let currentChunk = '';

    for (const paragraph of paragraphs) {
      // If adding this paragraph would exceed limit
      if (currentChunk.length + paragraph.length + 2 > maxSize) {
        // Save current chunk if not empty
        if (currentChunk.trim()) {
          chunks.push(currentChunk.trim());
        }

        // If single paragraph is too long, split it further
        if (paragraph.length > maxSize) {
          const sentences = paragraph.split(/(?<=[.!?])\s+/);
          let sentenceChunk = '';

          for (const sentence of sentences) {
            if (sentenceChunk.length + sentence.length + 1 > maxSize) {
              if (sentenceChunk.trim()) {
                chunks.push(sentenceChunk.trim());
              }
              // If single sentence is too long, just split by size
              if (sentence.length > maxSize) {
                const words = sentence.split(' ');
                let wordChunk = '';
                for (const word of words) {
                  if (wordChunk.length + word.length + 1 > maxSize) {
                    chunks.push(wordChunk.trim());
                    wordChunk = word;
                  } else {
                    wordChunk += (wordChunk ? ' ' : '') + word;
                  }
                }
                if (wordChunk.trim()) {
                  sentenceChunk = wordChunk;
                }
              } else {
                sentenceChunk = sentence;
              }
            } else {
              sentenceChunk += (sentenceChunk ? ' ' : '') + sentence;
            }
          }

          currentChunk = sentenceChunk;
        } else {
          currentChunk = paragraph;
        }
      } else {
        currentChunk += (currentChunk ? '\n\n' : '') + paragraph;
      }
    }

    // Don't forget the last chunk
    if (currentChunk.trim()) {
      chunks.push(currentChunk.trim());
    }

    return chunks;
  }
}

