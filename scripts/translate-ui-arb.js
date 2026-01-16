#!/usr/bin/env node
/* eslint-disable no-console */

const fs = require('fs');
const path = require('path');

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o-mini';

if (!OPENAI_API_KEY) {
  console.error('Missing OPENAI_API_KEY env var.');
  process.exit(1);
}

const ARB_DIR = path.join(__dirname, '..', 'mobile', 'lib', 'l10n');
const SOURCE_FILE = path.join(ARB_DIR, 'app_en.arb');
const TARGET_LOCALES = ['fr', 'es', 'de', 'it', 'pl', 'hu', 'ro'];
const CHUNK_SIZE = parseInt(process.env.TRANSLATE_CHUNK_SIZE || '100', 10);

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    return {};
  }
  const raw = fs.readFileSync(filePath, 'utf8');
  return raw.trim() ? JSON.parse(raw) : {};
}

function writeJson(filePath, data) {
  const content = JSON.stringify(data, null, 2) + '\n';
  fs.writeFileSync(filePath, content, 'utf8');
}

function isMetadataKey(key) {
  return key.startsWith('@');
}

function normalizeJson(input) {
  const withoutTrailingCommas = input.replace(/,(\s*[}\]])/g, '$1');
  let out = '';
  let inString = false;
  let escaped = false;

  for (let i = 0; i < withoutTrailingCommas.length; i++) {
    const ch = withoutTrailingCommas[i];
    if (inString) {
      if (escaped) {
        escaped = false;
        out += ch;
        continue;
      }
      if (ch === '\\') {
        escaped = true;
        out += ch;
        continue;
      }
      if (ch === '"') {
        inString = false;
        out += ch;
        continue;
      }
      if (ch === '\n') {
        out += '\\n';
        continue;
      }
      if (ch === '\r') {
        continue;
      }
    } else if (ch === '"') {
      inString = true;
    }
    out += ch;
  }

  return out.trim();
}

async function translateKeys(targetLocale, entries) {
  const systemPrompt =
    'You are a professional app UI translator. Return ONLY valid JSON. ' +
    'Preserve placeholders like {name} exactly. Do not change keys.';

  const userPrompt = `
Translate the following UI strings into ${targetLocale}.
Return a JSON object mapping the same keys to translated strings.
Do not include any extra text.

INPUT JSON:
${JSON.stringify(entries, null, 2)}
`.trim();

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: OPENAI_MODEL,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.2,
      max_tokens: 4000,
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI error ${response.status}: ${errorText}`);
  }

  const data = await response.json();
  const content = data.choices?.[0]?.message?.content;
  if (!content) {
    throw new Error('OpenAI returned empty response');
  }

  const cleaned = content
    .replace(/^```json\s*/i, '')
    .replace(/^```\s*/i, '')
    .replace(/```$/i, '')
    .trim();

  try {
    return JSON.parse(cleaned);
  } catch (err) {
    const start = cleaned.indexOf('{');
    const end = cleaned.lastIndexOf('}');
    if (start >= 0 && end > start) {
      const sliced = cleaned.slice(start, end + 1);
      const normalized = normalizeJson(sliced);
      return JSON.parse(normalized);
    }
    const normalized = normalizeJson(cleaned);
    return JSON.parse(normalized);
  }
}

async function run() {
  const source = readJson(SOURCE_FILE);
  const sourceKeys = Object.keys(source).filter((k) => !isMetadataKey(k));

  for (const locale of TARGET_LOCALES) {
    const targetFile = path.join(ARB_DIR, `app_${locale}.arb`);
    const target = readJson(targetFile);

    const missingKeys = sourceKeys.filter((key) => !(key in target));
    if (missingKeys.length === 0) {
      console.log(`[${locale}] No new keys. Skipping.`);
      continue;
    }

    console.log(`[${locale}] Translating ${missingKeys.length} keys...`);
    for (let i = 0; i < missingKeys.length; i += CHUNK_SIZE) {
      const batchKeys = missingKeys.slice(i, i + CHUNK_SIZE);
      const entriesToTranslate = {};
      for (const key of batchKeys) {
        entriesToTranslate[key] = source[key];
      }

      console.log(
        `[${locale}] Batch ${Math.floor(i / CHUNK_SIZE) + 1} (${batchKeys.length} keys)...`
      );
      const translated = await translateKeys(locale, entriesToTranslate);

      for (const key of Object.keys(translated)) {
        target[key] = translated[key];
        const metaKey = `@${key}`;
        if (source[metaKey]) {
          target[metaKey] = source[metaKey];
        }
      }
    }

    writeJson(targetFile, target);
    console.log(`[${locale}] Updated ${targetFile}`);
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
